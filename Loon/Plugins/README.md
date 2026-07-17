# Loon Plugins

Install plugins from the Loon Plugins screen. Plugins are independent from the
base profile, so only enable the features you need.

| Tier | Plugin | Source | MITM |
| --- | --- | --- | --- |
| Core | `Sub-Store.plugin` | This repository | `sub.store` only |
| Recommended | Advertising rewrite | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Loon/Advertising/Advertising.plugin` | Required for URL rules |
| Recommended | Redirect cleanup | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Loon/Redirect/Redirect.plugin` | Check upstream hosts |
| Experimental | `YouTube-AdBlock.plugin` | This repository | `youtubei.googleapis.com` |
| Experimental | `BiliBili-Enhance.plugin` | This repository | `app.bilibili.com`, `grpc.biliapi.net` |
| Experimental | `Spotify-Enhance.plugin` | This repository | Spotify client API hosts |
| Legacy experimental | `Emby-Public-Experimental.plugin` | This repository | `mb3admin.com` only |

The base profile already handles domain-level routing. Plugins that alter
service responses, subscriptions, entitlements, or login state are not part of
the recommended set. Spotify only provides partial client-side behavior changes;
it is not an account entitlement. Emby routing is built into `Loon.conf`; the
public Emby response rewrite in the Quantumult X profile applies only to named
upstream service hosts and is not a universal Emby unlock. The local legacy
Emby plugin is only for `mb3admin.com`; do not use it for a self-hosted server.
