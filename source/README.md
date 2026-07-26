# Configuration Sources

This directory contains the maintained inputs rather than client-imported
artifacts.

- `surge/`: common routing and platform-specific General sections used to build
  the Surge Mac 5, Surge Mac 6, and Surge iOS profiles. `macos5.routing.conf`
  intentionally keeps to the established Mac 5 policy-group syntax.
- `quantumultx/` and `loon/`: native source profiles copied to their client
  import paths by the build script.
- `versions.json`: the single release version used by generated Sub-Store
  integrations.
- `regions.json`: shared country-tag expressions rendered into every client.
- `modules.json`: machine-readable module ownership, tier, and MITM scope.
- `remote-resources.txt`: essential remote dependencies checked by the verifier.

Change a source, run `scripts/build-profiles.sh`, then run
`scripts/verify-remote-resources.sh`, `scripts/verify-active-resources.sh`, and
`scripts/validate-profiles.sh` before committing. Do not put subscription URLs,
proxy credentials, certificates, or account tokens in this directory.
