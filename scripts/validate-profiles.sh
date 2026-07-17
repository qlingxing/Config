#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
VERSION_FILE="$ROOT/source/versions.json"
REGION_FILE="$ROOT/source/regions.json"
VERSION=$(jq -er '.subStore' "$VERSION_FILE")

generated_files='
  QuantumultX/qlingxing.conf
  Surge/macOS/Surge-6.conf
  Surge/iOS/Surge-6.conf
  Surge/Module/Surge.sgmodule
  Loon/Loon.conf
'

failed=0

for relative_path in $generated_files; do
  file="$ROOT/$relative_path"
  if rg -n '\{\{(SUB_STORE_VERSION|REGION_[A-Z_]+)\}\}' "$file" >/dev/null; then
    printf 'FAIL unresolved template variable in %s\n' "$relative_path" >&2
    failed=1
  fi
done

for relative_path in \
  source/surge/Sub-Store.sgmodule \
  source/remote-resources.txt; do
  if ! rg -q '\{\{SUB_STORE_VERSION\}\}' "$ROOT/$relative_path"; then
    printf 'FAIL missing Sub-Store version template in %s\n' "$relative_path" >&2
    failed=1
  fi
done

if ! rg -q 'sub-store-org/Sub-Store/master/config/QX\.snippet,tag=Sub-Store' "$ROOT/QuantumultX/qlingxing.conf"; then
  printf 'FAIL Quantumult X is missing its official named Sub-Store module entry\n' >&2
  failed=1
fi

versions=$(rg -o 'releases/download/[0-9]+\.[0-9]+\.[0-9]+' \
  "$ROOT/Surge/Module/Surge.sgmodule" |
  sed 's#.*releases/download/##' |
  sort -u)

if [ "$versions" != "$VERSION" ]; then
  printf 'FAIL Sub-Store versions must be %s, found: %s\n' "$VERSION" "${versions:-none}" >&2
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

function section(content, start, end) {
  const startIndex = content.indexOf(start);
  if (startIndex < 0) throw new Error(`missing section ${start}`);
  const remaining = content.slice(startIndex + start.length);
  const endIndex = end ? remaining.indexOf(end) : -1;
  return endIndex < 0 ? remaining : remaining.slice(0, endIndex);
}

function validateSurge(relativePath) {
  const content = fs.readFileSync(`${root}/${relativePath}`, 'utf8');
  const groups = new Set();
  for (const line of section(content, '[Proxy Group]', '[Rule]').split('\n')) {
    const match = line.match(/^([^#=]+?)\s*=\s*/);
    if (match) groups.add(match[1].trim());
  }
  const targets = [];
  for (const line of section(content, '[Rule]').split('\n')) {
    if (/^(RULE-SET|DOMAIN|DOMAIN-SUFFIX|IP-CIDR),/.test(line)) targets.push(line.split(',')[2]);
    if (/^FINAL,/.test(line)) targets.push(line.split(',')[1]);
  }
  for (const target of targets) {
    if (target && !groups.has(target) && !builtins.has(target)) {
      console.error(`FAIL ${relativePath} references unknown policy: ${target}`);
      failed = true;
    }
  }
  if (!groups.has('All Nodes')) {
    console.error(`FAIL ${relativePath} is missing All Nodes`);
    failed = true;
  }
}

function validateLoon() {
  const relativePath = 'Loon/Loon.conf';
  const content = fs.readFileSync(`${root}/${relativePath}`, 'utf8');
  const groups = new Set();
  for (const line of section(content, '[Proxy Group]', '[Remote Rule]').split('\n')) {
    const match = line.match(/^([^#=]+?)\s*=\s*/);
    if (match) groups.add(match[1].trim());
  }
  const targets = [];
  for (const line of section(content, '[Remote Rule]', '[Rule]').split('\n')) {
    const match = line.match(/(?:^|,)\s*policy=([^,]+)/);
    if (match) targets.push(match[1].trim());
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
  if (!groups.has('All Nodes')) {
    console.error(`FAIL ${relativePath} is missing All Nodes`);
    failed = true;
  }
}

function validateQuantumultX() {
  const relativePath = 'QuantumultX/qlingxing.conf';
  const content = fs.readFileSync(`${root}/${relativePath}`, 'utf8');
  const policies = new Set();
  for (const line of section(content, '[policy]', '[filter_remote]').split('\n')) {
    const match = line.match(/^(?:static|url-latency-benchmark)=([^,]+)/);
    if (match) policies.add(match[1].trim());
  }
  const targets = [];
  for (const line of section(content, '[filter_remote]', '[filter_local]').split('\n')) {
    const match = line.match(/force-policy=([^,]+)/);
    if (match) targets.push(match[1].trim());
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
  if (!policies.has('All Nodes')) {
    console.error(`FAIL ${relativePath} is missing All Nodes`);
    failed = true;
  }
}

try {
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
