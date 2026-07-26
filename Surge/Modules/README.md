# Surge Modules

Modules are optional patches, not part of the base routing profile. Enable only
the functionality you need in Surge's Modules screen. Sub-Store is the
recommended exception: it manages subscription inputs while manual nodes remain
available in the main profile.

| Tier | Module | Platform | MITM | Purpose |
| --- | --- | --- | --- |
| Core | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule` | iOS, macOS | `sub.store` only | Official Sub-Store subscription management |
| Recommended | `AdBlock.sgmodule` | iOS, macOS | Optional | Domain rules work without MITM; URL rules need it |
| Recommended | `../Module/YouTube.Enhance.sgmodule` | iOS, macOS | Yes | YouTube interface enhancement |
| Recommended | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Surge/Advertising/Advertising.sgmodule` | iOS, macOS | Required for URL rules | Advertising rewrite |
| Recommended | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Surge/Redirect/Redirect.sgmodule` | iOS, macOS | Check upstream hosts | Redirect cleanup |
| Scenario | `Mac-Console-NAT.sgmodule` | macOS | No | Console NAT and real-IP support when the Mac routes LAN devices |
| Experimental | `BiliBili-AdBlock.sgmodule` | iOS, macOS | BiliBili API hosts | Selected splash, feed, and recommendation cleanup |
| Experimental | `../Module/spotify.module` | iOS, macOS | Spotify client API hosts | Partial playback behavior changes |
| Legacy experimental | `Emby-Public-Experimental.sgmodule` | iOS, macOS | `mb3admin.com` only | Public-service-specific playback response rewrite |

`../ad.sgmodule` is retained as a legacy iOS rewrite collection. It was last
updated in 2024 and has a broad MITM hostname list, so it is intentionally not
recommended as a default module. Spotify modifies account-facing responses and
must remain an opt-in experimental module; it does not grant an account
entitlement. Emby routing is included in the base profile, but no generic Emby
unlock module is shipped because service-side behavior is server-specific. The
legacy Emby experimental module applies only to `mb3admin.com`, never to a
self-hosted server.

The repository copy at `../Module/Surge.sgmodule` is retained for release
validation. For normal installation, use the official Sub-Store URL above.
