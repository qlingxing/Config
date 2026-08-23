# Loon Profile

`Loon.conf` is an iOS/iPadOS profile. Loon is not the macOS profile in this
repository; use `../Surge/macOS/Surge-6.conf` on a Mac with Surge 6.

The profile supports two node inputs at once:

1. Add or paste individual nodes in Loon's Proxy screen. They are stored in
   `[Proxy]`; choose Loon's built-in `PROXY` entry under `代理` or `全部节点` to
   use the local manual node.
2. Add a provider subscription in Loon's Remote Proxy screen, or replace the
   commented `[Remote Proxy]` sample using Loon's `Name = URL` syntax.

`Sub-Store All` is expanded into `全部节点`, `自动选择`, and the regional groups.
Loon does not dynamically enumerate arbitrary local `[Proxy]` names in a
managed group. For more than one named manual choice, append those names to a
`select` group in the editable local profile. Select the desired node once in
`代理`; service policies inherit it by default, while retaining regional
overrides. `全部节点` and `代理` default to `DIRECT` until nodes are configured;
select `REJECT` in `代理` when strict no-direct behavior is needed. Keep
subscription URLs, node credentials, and account tokens out of Git. MITM and
rewrite modules are kept out of the base profile. Install Sub-Store and optional
rewrite plugins from `Plugins/README.md` after creating and trusting Loon's
local MITM certificate.

The base profile downloads Sub-Store's official Loon plugin directly, which is
visible immediately after importing `Loon.conf` on networks that can reach
GitHub. Generate and trust Loon's MITM certificate, then open
`https://sub.store` to manage subscriptions and production. The official
plugin routes the frontend according to the plugin mapping in the profile. The
profile also lists advertising, redirect, Spotify, and BiliBili plugins as
disabled opt-ins; enable one at a time after checking the affected app. No
generic Emby unlock or directly maintained YouTube Loon plugin is advertised.

On the first import, `Sub-Store All` can update before the plugin and local
certificate are ready. After trusting the certificate and creating the `All`
collection, update that remote proxy once from Loon's Remote Proxy screen.
The profile entry must remain
`Sub-Store All = https://sub.store/download/collection/All?target=Loon` so the
query-string `=` is parsed as part of the URL rather than as the field separator.

`sub.store` is a local rewrite endpoint rather than a public Sub-Store website.
Keep the Sub-Store plugin enabled before opening that URL.

If the page reports that its server did not respond, open
`https://sub.store/api/utils/env`. It must return environment/version data. If
only `http://sub.store/api/utils/env` works, regenerate and trust Loon's MITM
certificate. If neither works, update the plugin, confirm scripts and rewrites
are enabled, then check whether another plugin replaces `hostname=sub.store`.
