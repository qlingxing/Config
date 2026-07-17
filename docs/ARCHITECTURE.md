# Configuration Architecture

## Layers

1. Base profiles provide DNS, network defaults, manual nodes, subscription
   inputs, policy groups, and traffic routing.
2. Modules add optional functionality. `source/modules.json` classifies every
   maintained module as core, recommended, experimental, or legacy.
3. Local client copies hold subscription URLs, nodes, certificates, and other
   device-specific values. They must never be committed.

## Platform Outputs

`source/surge/routing.conf` is shared by both Surge platforms. The macOS and
iOS General sections are separate because their runtime capabilities differ.
The build script produces the importable files under `Surge/macOS/` and
`Surge/iOS/`. `source/quantumultx/` and `source/loon/` are the native source
profiles for their respective clients.

Quantumult X and Loon remain native sources because their task, plugin, and
rewrite syntaxes are not interchangeable with Surge. Their module ownership is
still recorded in the shared catalog and their imported files are built from
their native source profiles.

## Network Defaults

All maintained profiles default to IPv4. This avoids policy bypasses and CDN
differences when a provider or local network has incomplete IPv6 support. Turn
on IPv6 only after validating the local network, subscription nodes, DNS, and
streaming services on that device.

Domestic resolvers are the default across profiles. Routing rules, rather than
an unbounded global DoH list, determine which traffic uses a proxy. Keep DNS
changes platform-specific and test them against the actual ISP environment.
See `NETWORK-PRESETS.md` before changing DNS or IPv6 defaults.

## Apple Services

Apple traffic currently has one policy group and a stable aggregate ruleset.
Do not split Apple API, CDN, and account traffic without a concrete account
region and CDN requirement: those categories behave differently for China and
non-China Apple IDs. When that requirement exists, add separate groups and
rules in `source/surge/routing.conf` and apply matching native changes to QX
and Loon in the same change.

## Resource Lifecycle

Use release artifacts for rules and rewrites whenever the upstream provides
them. `master` is reserved only for dependencies without a release channel.
Sub-Store's release version is maintained once in `source/versions.json` and
rendered into all clients. Run both resource verifiers and
`scripts/validate-profiles.sh` before publishing. The manifest verifier checks
the named core dependencies in `source/remote-resources.txt`; the active-resource
verifier scans every enabled URL in generated profiles and core modules.
