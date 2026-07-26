# Surge Profiles

## Supported Baseline

| Platform | Profile | Supported baseline |
| --- | --- | --- |
| macOS | `macOS/Surge-5.conf` | Surge Mac 5.0+ |
| macOS | `macOS/Surge-6.conf` | Surge Mac 6.0+ |
| iOS/iPadOS | `iOS/Surge-6.conf` | Current Surge iOS |

Surge 4 is not a supported target. `macOS/Surge-5.conf` avoids the Mac 6-only
settings while keeping the same routing and module model as the newer profile.
The previous files under `Conf/` are frozen legacy configurations.

## Import

1. Import the profile for the device platform as a normal profile.
2. Add manual nodes in `[Proxy]` or in Surge's Proxies screen. They appear in
   `All Nodes`, `Auto`, and every regional policy group.
3. To add a subscription, append the local URL to the node group. On Surge Mac
   5, edit `全部节点`; on Surge Mac 6 and iOS, replace the inert
   `Subscription` group:

   ```ini
   全部节点 = select, DIRECT, include-all-proxies=true, policy-path=https://example.com/subscription, update-interval=86400
   ```

   For Mac 6 and iOS, use
   `Subscription = select, policy-path=https://example.com/subscription, update-interval=86400, hidden=true`.
   Subscription nodes and manual nodes are collected together by `All Nodes`,
   `Auto`, and the regional groups. Keep the actual URL only in your local copy.
4. Select a default policy from `Proxy`, then use regional and service groups
   only when a service needs a specific exit region.
5. Open the Modules screen and opt into the modules documented in
   `Modules/README.md`. Install Sub-Store first when subscriptions need
   management or production. Modules requiring MITM need a locally generated
   and trusted Surge certificate.

The Mac 6 and iOS profiles include an `Emby` policy group and routing rules.
The Mac 5 profile retains the compatible selector but starts with local-only
rules. Response modules for Spotify and BiliBili remain experimental opt-ins
because they alter application responses and require MITM.

`macOS/Surge-5.conf` deliberately starts without URL-backed rulesets because
some Mac 5 builds fail generic profile parsing while loading them. Add a remote
ruleset from Surge after importing the profile if service-specific routing is
required.

## Compatibility Model

The platform profiles are generated from `../source/surge/`. Run
`scripts/build-surge-profiles.sh` after changing the shared routing source. The
generated files are standalone and can be imported directly from a local file
or URL. Keep local node and subscription changes only in the imported copy.
