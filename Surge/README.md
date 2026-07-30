# Surge Profiles

## Supported Baseline

| Platform | Profile | Supported baseline |
| --- | --- | --- |
| macOS | `macOS/Surge-5.conf` | Surge Mac 5.7+ |
| macOS | `macOS/Surge-6.conf` | Surge Mac 6.0+ |
| iOS/iPadOS | `iOS/Surge-6.conf` | Current Surge iOS |

Surge 4 and Surge Mac 5.0-5.6 are not supported targets. Update Surge Mac 5 to
5.7 or newer before importing. `macOS/Surge-5.conf` avoids the Mac 6-only
settings while keeping the same routing and module model as the newer profile.
The previous files under `Conf/` are frozen legacy configurations.

## Import

1. Import the platform Raw URL with **Download Profile from URL**.
2. Keep this read-only managed profile as the update source. Create a normal
   editable copy and activate that copy for daily use.
3. In the editable copy, generate, install, and trust the MITM certificate, then
   add manual nodes in `[Proxy]` or Surge's proxy editor. They are collected by
   the same node pool and regional groups as Sub-Store products. When replacing
   an older copy, transfer its local CA reference/material and `[Proxy]` content
   only on the device; never commit or share those secrets.
4. Install and enable the official Sub-Store module, then open
   `https://sub.store` in Safari and create a collection whose internal name is
   exactly `All`. Update the `节点订阅` external resource once. A parse warning
   before this setup is expected because the local backend is not ready yet.
5. Add provider subscriptions inside Sub-Store. The public profile contains
   only the local `All` collection product URL, never a provider URL or token.
   Sub-Store nodes and local `[Proxy]` nodes are collected by the same node pool
   and regional groups.
6. Select a default policy from `代理`, then use regional and service groups
   only when a service needs a specific exit region.
7. Open the Modules screen and opt into the remaining modules documented in
   `Modules/README.md`. Modules requiring MITM need the locally generated and
   trusted Surge certificate in the editable copy.

The Mac 6 and iOS profiles include an `Emby` policy group and routing rules.
The Mac 5 profile includes the same service routing categories using syntax
available in Surge Mac 5.7 and newer. Response modules remain separate opt-ins
because they alter application responses and require MITM.

All profiles are usable immediately: without a usable node, `全部节点` and
`代理` default to `DIRECT`. The service policies still inherit `代理`; select
`自动选择` or a region there after adding nodes. `REJECT` remains available when
strict no-direct behavior is required.

`macOS/Surge-5.conf` uses the known-good compact General section and restores
URL-backed service routing. Its `smart` groups require Surge Mac 5.7 or newer.

## Compatibility Model

The platform profiles are generated from `../source/surge/`. Run
`scripts/build-surge-profiles.sh` after changing the shared routing source. The
generated files are read-only managed source profiles. Their editable copies
hold local nodes and certificates. Rulesets, the Sub-Store product, and modules
update independently in the active copy; a new copy is needed only after the
managed source profile itself changes. Surge cannot write a profile-local MITM
CA directly into the read-only source.
