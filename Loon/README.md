# Loon Profile

`Loon.conf` is an iOS/iPadOS profile. Loon is not the macOS profile in this
repository; use `../Surge/macOS/Surge-6.conf` on a Mac with Surge 6.

The profile supports two node inputs at once:

1. Add or paste individual nodes in Loon's Proxy screen. They are stored in
   `[Proxy]` and are included by `All Nodes`, `Auto`, and the regional groups.
2. Add a provider subscription in Loon's Remote Proxy screen, or replace the
   commented `[Remote Proxy]` sample with a local subscription URL.

Both sources are collected by the same policy groups. `All Nodes` is the
fallback selector when a node does not use a country tag. Keep subscription
URLs, node credentials, and account tokens out of Git. MITM and rewrite modules
are kept out of the base profile. Install Sub-Store and optional rewrite plugins
from `Plugins/README.md` after creating and trusting Loon's local MITM
certificate.

The base profile downloads a Sub-Store compatibility wrapper directly, which is
visible immediately after importing `Loon.conf` on networks that can reach
GitHub. Its scripts use Sub-Store's official `release` branch to avoid GitHub
Release download redirects. The parser plugin is listed but disabled by default
because it requires Loon 3.5.0 (969) or newer. Generate and trust Loon's MITM
certificate, then open `https://sub.store` to manage subscriptions and
production. The official plugin routes the frontend through Loon's standard
`PROXY` policy. The profile also lists advertising, redirect, Spotify, YouTube,
BiliBili, and legacy Emby plugins as disabled opt-ins; enable one at a time
after checking the affected app.

`sub.store` is a local rewrite endpoint rather than a public Sub-Store website.
Keep the Sub-Store plugin enabled before opening that URL.

If the page reports that its server did not respond, open
`https://sub.store/api/utils/env`. It must return environment/version data. If
only `http://sub.store/api/utils/env` works, regenerate and trust Loon's MITM
certificate. If neither works, update the plugin, confirm scripts and rewrites
are enabled, then check whether another plugin replaces `hostname=sub.store`.
