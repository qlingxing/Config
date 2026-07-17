# Surge Profiles

## Supported Baseline

| Platform | Profile | Supported baseline |
| --- | --- | --- |
| macOS | `macOS/Surge-6.conf` | Surge Mac 6.0+ |
| iOS/iPadOS | `iOS/Surge-6.conf` | Current Surge iOS |

Surge 4 and old Surge 5 builds are not supported targets.

The previous file at `Conf/Surge.conf` is retained as a frozen legacy Surge 5
profile. Do not add features to it; migrate to the platform-specific Surge 6
profile instead.

## Import

1. Import the profile for the device platform as a normal profile.
2. Add manual nodes in `[Proxy]` or in Surge's Proxies screen. They appear in
   `All Nodes`, `Auto`, and every regional policy group.
3. To add a subscription, replace this inert line in `[Proxy Group]`:

   ```ini
   Subscription = select, REJECT
   ```

   with your local subscription URL:

   ```ini
   Subscription = select, policy-path=https://example.com/subscription, update-interval=86400, hidden=true
   ```

   Subscription nodes and manual nodes are collected together by `All Nodes`,
   `Auto`, and the regional groups. Keep the actual URL only in your local
   copy.
4. Select a default policy from `Proxy`, then use regional and service groups
   only when a service needs a specific exit region.
5. Open the Modules screen and opt into the modules documented in
   `Modules/README.md`. Install Sub-Store first when subscriptions need
   management or production. Modules requiring MITM need a locally generated
   and trusted Surge certificate.

The base profile includes an `Emby` policy group and routing rules. Response
modules for Spotify and BiliBili remain experimental opt-ins because they alter
application responses and require MITM.

## Compatibility Model

The platform profiles are generated from `../source/surge/`. Run
`scripts/build-surge-profiles.sh` after changing the shared routing source. The
generated files are standalone and can be imported directly from a local file
or URL. Keep local node and subscription changes only in the imported copy.
