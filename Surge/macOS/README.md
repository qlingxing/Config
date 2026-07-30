# Surge for macOS

Use `Surge-5.conf` with Surge Mac 5.7 or newer. Use `Surge-6.conf` only with
Surge Mac 6.0 or newer. Both use the same routing and optional module set; the
Mac 6 profile also enables the web dashboard. Both Raw entries are managed
profiles. Create a linked profile and keep `[Proxy]` local when adding manual
nodes; keep `[MITM]` local as well so managed updates preserve the certificate.
Before Sub-Store produces a node, the profile remains usable with `DIRECT`.
Select a node only in `代理`; all service policies follow it by default. Select
`REJECT` in that group when strict no-direct behavior is required.

See `../README.md` for manual-node and subscription setup.

Install Sub-Store from Surge's Modules screen before importing the profile. Its
production URL for the `All` collection is already active in the corresponding
node-source group. The main configuration cannot install modules automatically.

| Module | URL |
| --- | --- |
| Sub-Store | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule` |
| Advertising rewrite | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rewrite/Surge/Advertising/Advertising.sgmodule` |
| Redirect cleanup | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rewrite/Surge/Redirect/Redirect.sgmodule` |
| YouTube enhancement | `https://raw.githubusercontent.com/Maasea/sgmodule/master/YouTube.Enhance.sgmodule` |
| BiliBili experimental | `https://raw.githubusercontent.com/app2smile/rules/master/module/bilibili.sgmodule` |
