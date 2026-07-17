# Loon Plugins

The base profile downloads Sub-Store's official Loon plugin directly. It is
visible in Loon's Plugins screen immediately after importing `Loon.conf` on
networks that can reach GitHub. The other entries are disabled opt-ins. Generate
and trust Loon's MITM certificate before enabling a rewrite or response plugin.

| Tier | Plugin | Source | MITM |
| --- | --- | --- | --- |
| Core | Sub-Store | Official `config/Loon.plugin` | `sub.store` only |
| Recommended | Advertising rewrite | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Loon/Advertising/Advertising.plugin` | Required for URL rules |
| Recommended | Redirect cleanup | `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rewrite/Loon/Redirect/Redirect.plugin` | Check upstream hosts |
The base profile already handles domain-level routing. Plugins that alter
service responses, subscriptions, entitlements, or login state are not part of
the base configuration. Add only a directly maintained upstream plugin after
reviewing its source and MITM hostname list.
