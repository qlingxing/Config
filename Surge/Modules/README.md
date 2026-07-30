# Surge Modules

Modules are optional patches, not part of the base routing profile. Enable only
the functionality you need in Surge's Modules screen. Sub-Store is the
recommended exception: it manages subscription inputs while manual nodes remain
available in the main profile.

| Tier | Module | Platform | MITM | Purpose |
| --- | --- | --- | --- |
| Core | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule` | iOS, macOS | `sub.store` only | Official Sub-Store subscription management |
| Recommended | `AdBlock.sgmodule` | iOS, macOS | Optional | Domain rules work without MITM; URL rules need it |
| Recommended | `https://raw.githubusercontent.com/Maasea/sgmodule/master/YouTube.Enhance.sgmodule` | iOS, macOS | Yes | Official upstream YouTube interface enhancement |
| Recommended | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rewrite/Surge/Advertising/Advertising.sgmodule` | iOS, macOS | Required for URL rules | Advertising rewrite |
| Recommended | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rewrite/Surge/Redirect/Redirect.sgmodule` | iOS, macOS | Check upstream hosts | Redirect cleanup |
| Scenario | `Mac-Console-NAT.sgmodule` | macOS | No | Console NAT and real-IP support when the Mac routes LAN devices |
| Experimental | `https://raw.githubusercontent.com/app2smile/rules/master/module/spotify.module` | iOS 15+ | Spotify API hosts | Direct upstream Spotify response modification; partial functionality only |
| Experimental | `https://raw.githubusercontent.com/app2smile/rules/master/module/bilibili.sgmodule` | iOS, macOS | BiliBili API hosts | Direct upstream BiliBili response cleanup |

`../ad.sgmodule` is retained as a legacy iOS rewrite collection. It was last
updated in 2024 and has a broad MITM hostname list, so it is intentionally not
recommended as a default module. The Spotify module is maintained by app2smile
and declares iOS 15 or newer; it is not presented as compatible with the macOS
Spotify client. It cannot guarantee account entitlements or ultra-high audio.
Emby routing is included in the base profile, but no generic Emby unlock module
is shipped because service-side behavior is server-specific.

Install remote modules directly from the upstream URLs in this table. The
repository does not mirror or pin Sub-Store and service-response modules.
