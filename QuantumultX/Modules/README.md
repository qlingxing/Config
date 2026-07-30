# Quantumult X Modules

The base profile keeps subscription management and the recommended rewrite set
enabled. Generate and trust the Quantumult X MITM certificate locally before
using any rewrite that requires it.

| Tier | Module | State | Notes |
| --- | --- | --- | --- |
| Core | Sub-Store | Enabled named remote module | Direct official `config/QX.snippet` resource |
| Core | Resource Parser | Enabled | Local fallback for subscription conversion |
| Recommended | YouTube advertising rewrite | Enabled | Requires the upstream rewrite's MITM hosts |
| Recommended | Advertising rewrite | Enabled | App and web advertising cleanup; some URL rules need MITM |
| Recommended | Redirect rewrite | Enabled | Web redirection cleanup |
| Optional | Advertising Lite domain rules | Disabled | Enable only when rewrite-based blocking is insufficient |
| Diagnostic | Streaming availability task | Enabled | Runs only when manually opened |
| Experimental | Spotify enhancement | Disabled | Partial client-side behavior changes; requires Spotify MITM hosts |
| Experimental | BiliBili enhancement | Disabled | Alters selected app responses; requires BiliBili MITM hosts |
| Experimental | Emby response rewrite | Disabled | Only for the upstream's named public-service hosts; not a universal unlock |

Use the client UI to enable an experimental item only after reviewing its
upstream source and MITM hostname list. Do not add certificate material,
subscription URLs, or account tokens to this repository.

After importing the base profile, generate and trust the QX MITM certificate,
then open `https://sub.store` while QX is running. Add provider subscriptions
inside Sub-Store or add raw subscriptions under `[server_remote]` in the local
copy of the profile. Create the `All` collection, then manually update the
`Sub-Store All` server resource once; an initial update attempted during import
can fail before the local integration is ready.

If the Sub-Store page reports that its server did not respond, open
`https://sub.store/api/utils/env`. It must return environment/version data. If
only `http://sub.store/api/utils/env` works, the MITM certificate is not trusted
for HTTPS. If neither works, ensure the named Sub-Store rewrite is enabled,
scripts are enabled in QX, and no other rewrite resource replaces
`hostname=sub.store`.
