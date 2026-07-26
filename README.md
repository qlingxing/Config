# Proxy Configurations

Personal routing configurations for Quantumult X, Surge, and Loon.

| Client | Entry | Platform | Support status |
| --- | --- | --- | --- |
| Surge | `Surge/macOS/Surge-5.conf` | macOS | Maintained: Surge Mac 5.0+ |
| Surge | `Surge/macOS/Surge-6.conf` | macOS | Maintained: Surge Mac 6.0+ |
| Surge | `Surge/iOS/Surge-6.conf` | iOS, iPadOS | Maintained: current Surge iOS |
| Loon | `Loon/Loon.conf` | iOS, iPadOS | Maintained base profile |
| Quantumult X | `QuantumultX/qlingxing.conf` | iOS, iPadOS | Existing personal profile |
| Surge legacy | `Surge/Conf/Surge.conf` | macOS, iOS | Frozen; do not extend |

## Direct Import Links

After this repository is committed and pushed to `main`, import these raw URLs
directly in the corresponding client:

| Client | Direct import URL |
| --- | --- |
| Surge for macOS 5 | `https://raw.githubusercontent.com/qlingxing/Config/main/Surge/macOS/Surge-5.conf` |
| Surge for macOS 6+ | `https://raw.githubusercontent.com/qlingxing/Config/main/Surge/macOS/Surge-6.conf` |
| Surge for iOS/iPadOS | `https://raw.githubusercontent.com/qlingxing/Config/main/Surge/iOS/Surge-6.conf` |
| Loon | `https://raw.githubusercontent.com/qlingxing/Config/main/Loon/Loon.conf` |
| Quantumult X | `https://raw.githubusercontent.com/qlingxing/Config/main/QuantumultX/qlingxing.conf` |

These base profiles intentionally contain no provider URL or node credential.
Add subscriptions and manual nodes locally after import; see `local/README.md`.

## Design

- Base profiles accept both manual nodes and subscription nodes. Each client has
  an `All Nodes` group for direct selection without relying on a country tag.
  URLs and node credentials are added locally and never committed here.
- MITM, rewrites, and service-specific tweaks are optional modules. Read the
  client module documentation before enabling them. Sub-Store is the recommended
  subscription-management module for every supported client.
- Surge 6 has dedicated macOS and iOS entry points. The routing model stays
  aligned; platform-specific settings are kept in the appropriate profile.

## Maintenance

The maintained architecture is documented in `docs/ARCHITECTURE.md`.

```sh
scripts/build-profiles.sh
scripts/verify-remote-resources.sh
scripts/verify-active-resources.sh
scripts/validate-profiles.sh
```

The first command regenerates Surge macOS/iOS profiles and copies the native
Quantumult X/Loon sources to their client import paths.
The second verifies the core remote module and ruleset dependencies listed in
`source/remote-resources.txt`; the third verifies every active URL in the
generated profiles and core modules; the fourth validates rendered templates,
Sub-Store version consistency, country-tag regression cases, and policy-group
references. DNS, health-check, and CORS endpoint URLs are checked by their
clients at runtime and are excluded from HTTP resource download validation.

GitHub Actions runs build and semantic validation on every push or pull request.
Remote-resource health checks run daily and can also be started manually from
the Actions tab, keeping transient third-party network failures out of normal
configuration changes.

## Security

The Quantumult X profile no longer contains an MITM certificate or passphrase.
Generate and trust that certificate locally. An old certificate existed in Git
history, so it must be regenerated before the profile is used again; removing a
working-tree value does not revoke a previously exposed certificate.

Use `.private.conf` or `.secrets.conf` files for local credentials. Those files,
as well as common private-key formats, are ignored by Git.
