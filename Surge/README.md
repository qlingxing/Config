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

1. Install the official Sub-Store module when subscription management is
   required, then import the platform Raw URL with **Download Profile from URL**.
2. The imported base is a read-only managed profile that checks for updates
   every 24 hours while the Surge main app is running. `strict=false` allows the
   existing profile to continue working when GitHub is temporarily unavailable.
3. To add manual nodes, select the managed base in the profile list and choose
   **Create Linked Profile**. Link `[General]`, `[Proxy Group]`, `[Rule]`, and
   `[Host]`, but leave `[Proxy]` and `[MITM]` local. Add manual nodes to the
   local `[Proxy]` section. Generate, install, and trust the MITM certificate
   once in the local `[MITM]` section; managed updates will not replace it.
4. Enable the official Sub-Store module, open `https://sub.store` in Safari,
   and create a collection whose internal name is exactly `All`. Then update
   the `节点订阅` external resource once. A parse warning before this setup is
   expected because the local backend is not ready yet.
5. Add provider subscriptions inside Sub-Store. The public profile contains
   only the local `All` collection product URL, never a provider URL or token.
   Sub-Store nodes and local `[Proxy]` nodes are collected by the same node pool
   and regional groups.
6. Select a default policy from `代理`, then use regional and service groups
   only when a service needs a specific exit region.
7. Open the Modules screen and opt into the modules documented in
   `Modules/README.md`. Install Sub-Store first when subscriptions need
   management or production. Modules requiring MITM need a locally generated
   and trusted Surge certificate.

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
generated files are self-updating managed profiles. Use a linked profile for
local nodes and MITM certificates instead of editing the managed base.
