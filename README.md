# Proxy Configurations

Personal routing configurations for Quantumult X, Surge, and Loon.

| Client | Entry | Platform | Support status |
| --- | --- | --- | --- |
| Surge | `Surge/macOS/Surge-5.conf` | macOS | Maintained: Surge Mac 5.7+ |
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

The three Surge URLs are managed source profiles and check for updates every 24
hours while the main app is running. Keep the managed source in the profile
list, then create an editable copy for the active configuration. The copy holds
manual nodes and the locally generated MITM CA; it does not follow later source
profile changes, so create a new copy only when the managed source itself has
actually changed. Rulesets, Sub-Store products, and modules update independently
inside the active copy.

These profiles contain an active local Sub-Store `All` product URL but no
provider URL or node credential. Create the editable Surge copy, generate and
trust its local CA, then enable the official Sub-Store module. Loon and QX load
their official integration during profile import. Add provider subscriptions
and manual nodes locally; see `local/README.md`.

## Design

- Base profiles accept both manual nodes and subscription nodes. Surge and Loon
  collect both node sources in `全部节点`; QX exposes its client built-in
  current-node policy for manual nodes while `全部节点` provides direct
  Sub-Store node selection.
  URLs and node credentials are added locally and never committed here.
- MITM, rewrites, and service-specific tweaks are platform-specific. QX enables
  its recommended rewrite set; Surge and Loon expose optional remote modules or
  plugins. Sub-Store is the recommended subscription-management integration for
  every supported client.
- Surge 6 has dedicated macOS and iOS entry points. The routing model stays
  aligned; platform-specific settings are kept in the appropriate profile.

Sub-Store product targets and official client integrations are listed in
`docs/SUBSTORE.md`.

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
generated profiles and maintained modules; the fourth validates rendered
templates, official Sub-Store integration presence, country-tag regression
cases, and policy-group references. DNS, health-check, and CORS endpoint URLs
are checked by their clients at runtime and are excluded from HTTP resource
download validation.

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
