# Surge for macOS

Use `Surge-5.conf` with Surge Mac 5.0 or newer. Use `Surge-6.conf` only with
Surge Mac 6.0 or newer. Both profiles enable the Surge web dashboard and use
the same routing and optional module set. The Mac 5 profile uses the `smart`
region-group syntax already verified by the prior Mac 5 profile. Its General
section stays within the syntax verified by the existing Mac 5 configuration.
Its base rules are local only; add remote rulesets or modules from Surge after
the profile is imported. Before Sub-Store produces a node, the profile remains
usable with `DIRECT`. Select a node only in `代理`; all service policies follow
it by default. Select `REJECT` in that group when strict no-direct behavior is
required.

See `../README.md` for manual-node and subscription setup.

Install Sub-Store from Surge's Modules screen before importing the profile. Its
production URL for the `All` collection is already active in `全部节点`. The main
configuration cannot install modules automatically.

| Module | URL |
| --- | --- |
| Sub-Store | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule` |
| Advertising rewrite | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Surge/Advertising/Advertising.sgmodule` |
| Redirect cleanup | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Surge/Redirect/Redirect.sgmodule` |
| YouTube enhancement | `https://raw.githubusercontent.com/qlingxing/Config/refs/heads/main/Surge/Module/YouTube.Enhance.sgmodule` |
| Spotify experimental | `https://raw.githubusercontent.com/qlingxing/Config/refs/heads/main/Surge/Module/spotify.module` |
| BiliBili experimental | `https://raw.githubusercontent.com/qlingxing/Config/refs/heads/main/Surge/Modules/BiliBili-AdBlock.sgmodule` |
| Emby public-service experimental | `https://raw.githubusercontent.com/qlingxing/Config/refs/heads/main/Surge/Modules/Emby-Public-Experimental.sgmodule` |
