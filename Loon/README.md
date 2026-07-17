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

The base profile includes an `Emby` policy group and routing rules. Optional
Spotify, YouTube, and BiliBili response plugins are listed in
`Plugins/README.md`; enable them one at a time after trusting Loon's MITM
certificate and checking the affected app.
