#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
REGION_FILE="$ROOT/source/regions.json"

generated_files='
  QuantumultX/qlingxing.conf
  Surge/macOS/Surge-5.conf
  Surge/macOS/Surge-6.conf
  Surge/iOS/Surge-6.conf
  Loon/Loon.conf
'

failed=0

for relative_path in $generated_files; do
  file="$ROOT/$relative_path"
  if rg -n '\{\{(SUB_STORE_TARGET|REGION_[A-Z_]+)\}\}' "$file" >/dev/null; then
    printf 'FAIL unresolved template variable in %s\n' "$relative_path" >&2
    failed=1
  fi
done

if ! rg -q 'sub-store-org/Sub-Store/master/config/QX\.snippet,tag=Sub-Store' "$ROOT/QuantumultX/qlingxing.conf"; then
  printf 'FAIL Quantumult X is missing its official named Sub-Store module entry\n' >&2
  failed=1
fi

if ! node - "$ROOT" "$REGION_FILE" <<'NODE'
const fs = require('fs');

const [root, regionFile] = process.argv.slice(2);
const regions = JSON.parse(fs.readFileSync(regionFile, 'utf8'));
let failed = false;

function checkRegion(name, positive, negative) {
  const expression = regions[name].replace(/^\(\?i\)/, '');
  const regex = new RegExp(expression, 'i');
  for (const value of positive) {
    if (!regex.test(value)) {
      console.error(`FAIL ${name} does not match expected node tag: ${value}`);
      failed = true;
    }
  }
  for (const value of negative) {
    if (regex.test(value)) {
      console.error(`FAIL ${name} incorrectly matches node tag: ${value}`);
      failed = true;
    }
  }
}

checkRegion('hongKong', ['HK-01', 'Hong Kong 01', '香港 01'], ['Hacker-01']);
checkRegion('japan', ['JP-01', 'Japan 01', '东京 01'], ['Project JPX']);
checkRegion('singapore', ['SG-01', 'Singapore 01', '新加坡 01'], ['Message 01']);
checkRegion('unitedStates', ['US-01', 'USA 01', 'United States 01', '美国 01'], ['Russia 01', 'AUS 01']);
checkRegion('unitedKingdom', ['UK-01', 'GB 01', 'United Kingdom 01', '英国 01'], ['Ukraine 01']);
checkRegion('taiwan', ['TW-01', 'Taiwan 01', '台湾 01'], ['Network TWX']);

const builtins = new Set(['DIRECT', 'REJECT', 'REJECT-DROP', 'direct', 'reject', 'proxy']);

function normalizePolicy(value) {
  return value.trim().replace(/^"(.*)"$/, '$1');
}

function section(content, start, end) {
  const startIndex = content.indexOf(start);
  if (startIndex < 0) throw new Error(`missing section ${start}`);
  const remaining = content.slice(startIndex + start.length);
  const endIndex = end ? remaining.indexOf(end) : -1;
  return endIndex < 0 ? remaining : remaining.slice(0, endIndex);
}

function validateReferences(relativePath, references, policies) {
  for (const target of references) {
    if (target && !policies.has(target) && !builtins.has(target)) {
      console.error(`FAIL ${relativePath} references unknown policy group: ${target}`);
      failed = true;
    }
  }
}

function surgeGroupReferences(line) {
  const equals = line.indexOf('=');
  if (equals < 0) return [];
  const fields = line.slice(equals + 1).split(',').map(normalizePolicy);
  const references = [];
  for (const field of fields.slice(1)) {
    const included = field.match(/^include-other-group=(.+)$/);
    if (included) references.push(normalizePolicy(included[1]));
    else if (field && !field.includes('=')) references.push(field);
  }
  return references;
}

function validateSurge(relativePath) {
  const content = fs.readFileSync(`${root}/${relativePath}`, 'utf8');
  const managedUrl = `https://raw.githubusercontent.com/qlingxing/Config/main/${relativePath}`;
  const expectedManagedHeader = `#!MANAGED-CONFIG ${managedUrl} interval=86400 strict=false`;
  if (content.split(/\r?\n/, 1)[0] !== expectedManagedHeader) {
    console.error(`FAIL ${relativePath} must start with its managed configuration URL`);
    failed = true;
  }
  const allNodesGroup = '全部节点';
  const proxyGroup = '代理';
  const groups = new Set();
  const groupReferences = [];
  for (const line of section(content, '[Proxy Group]', '[Rule]').split('\n')) {
    const match = line.match(/^([^#=]+?)\s*=\s*/);
    if (match) {
      groups.add(match[1].trim());
      groupReferences.push(...surgeGroupReferences(line));
    }
  }
  validateReferences(relativePath, groupReferences, groups);
  for (const option of ['internet-test-url', 'proxy-test-url']) {
    const testUrl = content.match(new RegExp(`^${option}\\s*=\\s*(\\S+)`, 'm'))?.[1];
    if (testUrl && !testUrl.startsWith('http://')) {
      console.error(`FAIL ${relativePath} ${option} must use plain HTTP for Surge import compatibility`);
      failed = true;
    }
  }
  const hostSection = section(content, '[Host]', '[MITM]');
  if (!/^sub\.store\s*=\s*127\.0\.0\.1\s*$/m.test(hostSection)) {
    console.error(`FAIL ${relativePath} must keep sub.store mapped to localhost`);
    failed = true;
  }
  const mitmSection = section(content, '[MITM]');
  if (!/^h2\s*=\s*true\s*$/m.test(mitmSection)) {
    console.error(`FAIL ${relativePath} must provide an MITM section for editable copies`);
    failed = true;
  }
  if (/^ca-(?:p12|passphrase)\s*=/m.test(mitmSection)) {
    console.error(`FAIL ${relativePath} must not contain a committed MITM certificate`);
    failed = true;
  }
  const targets = [];
  for (const line of section(content, '[Rule]').split('\n')) {
    if (/^(RULE-SET|DOMAIN|DOMAIN-SUFFIX|IP-CIDR),/.test(line)) targets.push(normalizePolicy(line.split(',')[2]));
    if (/^FINAL,/.test(line)) targets.push(normalizePolicy(line.split(',')[1]));
  }
  for (const target of targets) {
    if (target && !groups.has(target) && !builtins.has(target)) {
      console.error(`FAIL ${relativePath} references unknown policy: ${target}`);
      failed = true;
    }
  }
  if (!groups.has(allNodesGroup)) {
    console.error(`FAIL ${relativePath} is missing ${allNodesGroup}`);
    failed = true;
  }
  if (!groups.has(proxyGroup)) {
    console.error(`FAIL ${relativePath} is missing ${proxyGroup}`);
    failed = true;
  }
  const escapedAllNodesGroup = allNodesGroup.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  if (!(new RegExp(`^${escapedAllNodesGroup}\\s*=\\s*select,\\s*DIRECT(?:,|$)`, 'm')).test(content)) {
    console.error(`FAIL ${relativePath} must keep DIRECT in ${allNodesGroup} for an empty-node import`);
    failed = true;
  }
  if (!/^代理\s*=\s*select,\s*DIRECT(?:,|$)/m.test(content)) {
    console.error(`FAIL ${relativePath} must default 代理 to DIRECT before setup`);
    failed = true;
  }
  if (relativePath === 'Surge/macOS/Surge-5.conf') {
    if (!groups.has('节点来源') || !/^节点来源\s*=\s*select,(?![^\n]*DIRECT)/m.test(content)) {
      console.error(`FAIL ${relativePath} must keep DIRECT out of 节点来源`);
      failed = true;
    }
    if (!/^自动选择\s*=\s*smart,[^\n]*include-other-group=节点来源/m.test(content)) {
      console.error(`FAIL ${relativePath} must build smart selection from 节点来源`);
      failed = true;
    }
    const remoteRuleCount = (content.match(/^RULE-SET,https:\/\//gm) || []).length;
    if (remoteRuleCount < 10) {
      console.error(`FAIL ${relativePath} is missing full service routing`);
      failed = true;
    }
  }
}

function validateLoon() {
  const relativePath = 'Loon/Loon.conf';
  const content = fs.readFileSync(`${root}/${relativePath}`, 'utf8');
  const remoteProxies = section(content, '[Remote Proxy]', '[Proxy Group]');
  if (!/^Sub-Store All\s*=\s*https:\/\/sub\.store\/download\/collection\/All\?target=Loon\s*$/m.test(remoteProxies)) {
    console.error(`FAIL ${relativePath} must use Loon's Name = URL syntax for the Sub-Store remote proxy`);
    failed = true;
  }
  for (const line of remoteProxies.split('\n')) {
    const value = line.trim();
    if (!value || value.startsWith('#')) continue;
    const separator = value.indexOf('=');
    const name = separator < 0 ? '' : value.slice(0, separator).trim();
    const url = separator < 0 ? '' : value.slice(separator + 1).trim();
    if (!name || /^https?:\/\//.test(name) || !/^https?:\/\//.test(url)) {
      console.error(`FAIL ${relativePath} has an invalid Remote Proxy entry: ${value}`);
      failed = true;
    }
  }
  const groups = new Set();
  const groupReferences = [];
  for (const line of section(content, '[Proxy Group]', '[Remote Rule]').split('\n')) {
    const match = line.match(/^([^#=]+?)\s*=\s*/);
    if (match) {
      groups.add(match[1].trim());
      groupReferences.push(...surgeGroupReferences(line));
    }
  }
  validateReferences(relativePath, groupReferences, groups);
  const targets = [];
  for (const line of section(content, '[Remote Rule]', '[Rule]').split('\n')) {
    const match = line.match(/(?:^|,)\s*policy=([^,]+)/);
    if (match) targets.push(match[1].trim());
  }
  const remoteRules = section(content, '[Remote Rule]', '[Plugin]');
  const chinaIndex = remoteRules.indexOf('/China/China.list');
  const proxyIndex = remoteRules.indexOf('/Proxy/Proxy.list');
  if (chinaIndex < 0 || proxyIndex < 0 || chinaIndex > proxyIndex) {
    console.error(`FAIL ${relativePath} must load China before aggregate Proxy rules`);
    failed = true;
  }
  for (const line of section(content, '[Rule]').split('\n')) {
    const fields = line.split(',');
    if (fields[0] === 'FINAL') targets.push(fields[1]);
    if (fields.length >= 3) targets.push(fields[2]);
  }
  for (const target of targets) {
    if (target && !groups.has(target) && !builtins.has(target)) {
      console.error(`FAIL ${relativePath} references unknown policy: ${target}`);
      failed = true;
    }
  }
  if (!groups.has('全部节点') || !groups.has('代理')) {
    console.error(`FAIL ${relativePath} is missing 全部节点 or 代理`);
    failed = true;
  }
  if (!/^全部节点\s*=\s*select,\s*DIRECT(?:,|$)/m.test(content)) {
    console.error(`FAIL ${relativePath} must use DIRECT when no nodes are available`);
    failed = true;
  }
  if (!/^代理\s*=\s*select,\s*DIRECT(?:,|$)/m.test(content)) {
    console.error(`FAIL ${relativePath} must default 代理 to DIRECT before setup`);
    failed = true;
  }
}

function validateQuantumultX() {
  const relativePath = 'QuantumultX/qlingxing.conf';
  const content = fs.readFileSync(`${root}/${relativePath}`, 'utf8');
  const policies = new Set();
  const policyLines = [];
  for (const line of section(content, '[policy]', '[filter_remote]').split('\n')) {
    const match = line.match(/^(?:static|url-latency-benchmark)=([^,]+)/);
    if (match) {
      policies.add(match[1].trim());
      policyLines.push(line);
    }
  }
  const policyReferences = [];
  for (const line of policyLines) {
    const fields = line.slice(line.indexOf('=') + 1).split(',').map(normalizePolicy);
    for (const field of fields.slice(1)) {
      if (field && !field.includes('=')) policyReferences.push(field);
    }
  }
  validateReferences(relativePath, policyReferences, policies);
  const targets = [];
  const remoteFilters = section(content, '[filter_remote]', '[filter_local]');
  for (const line of remoteFilters.split('\n')) {
    const match = line.match(/force-policy=([^,]+)/);
    if (match) targets.push(match[1].trim());
  }
  const mainlandIndex = remoteFilters.indexOf('/China/China.list');
  const advertisingIndex = remoteFilters.indexOf('/AdvertisingLite/AdvertisingLite.list');
  const globalIndex = remoteFilters.indexOf('/Global/Global.list');
  if (mainlandIndex < 0 || advertisingIndex < 0 || globalIndex < 0 ||
      mainlandIndex > globalIndex || advertisingIndex > globalIndex) {
    console.error(`FAIL ${relativePath} must load Mainland and Advertising before Global`);
    failed = true;
  }
  if (/\/Advertising\/Advertising\.list,[^\n]*enabled=true/.test(remoteFilters)) {
    console.error(`FAIL ${relativePath} must not enable the full Advertising list by default`);
    failed = true;
  }
  for (const line of section(content, '[filter_local]', '[http_backend]').split('\n')) {
    const fields = line.split(',').map((value) => value.trim());
    if (fields[0] === 'final') targets.push(fields[1]);
    if (fields.length >= 3) targets.push(fields[2]);
  }
  for (const target of targets) {
    if (target && !policies.has(target) && !builtins.has(target)) {
      console.error(`FAIL ${relativePath} references unknown policy: ${target}`);
      failed = true;
    }
  }
  if (!policies.has('全部节点') || !policies.has('代理')) {
    console.error(`FAIL ${relativePath} is missing 全部节点 or 代理`);
    failed = true;
  }
  if (!/^static=全部节点,\s*direct(?:,|$)/m.test(content)) {
    console.error(`FAIL ${relativePath} must use direct when no nodes are available`);
    failed = true;
  }
  if (!/^static=代理,\s*direct(?:,|$)/m.test(content)) {
    console.error(`FAIL ${relativePath} must default 代理 to direct before setup`);
    failed = true;
  }
  if (!/^static=全部节点,[^\n]*,\s*proxy,[^\n]*resource-tag-regex=\^Sub-Store All\$[^\n]*server-tag-regex=\.\*/m.test(content)) {
    console.error(`FAIL ${relativePath} must combine built-in proxy with Sub-Store All in 全部节点`);
    failed = true;
  }
}

try {
  validateSurge('Surge/macOS/Surge-5.conf');
  validateSurge('Surge/macOS/Surge-6.conf');
  validateSurge('Surge/iOS/Surge-6.conf');
  validateLoon();
  validateQuantumultX();
} catch (error) {
  console.error(`FAIL semantic validation: ${error.message}`);
  failed = true;
}

process.exit(failed ? 1 : 0);
NODE
then
  failed=1
fi

exit "$failed"
