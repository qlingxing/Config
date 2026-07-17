# Local Configuration

The files in `source/` are repository-managed inputs. Do not put secrets or
device-specific values there. Keep local changes in the imported client copy,
or store them in ignored `*.private.conf` files as reference material.

## Quantumult X

Append the contents of `QuantumultX/Local/ServerRemote.private.conf.example` to
the imported profile when adding raw or Sub-Store production subscriptions.
Manual nodes belong in `[server_local]`.

## Loon

Append the contents of `Loon/Local/RemoteProxy.private.conf.example` to the
imported profile. Use `[Proxy]` for manual nodes and `[Remote Proxy]` for
subscriptions.

## Surge

In the imported platform profile, add manual nodes in `[Proxy]`. Replace the
inert `Subscription = select, REJECT` group with the `policy-path` line shown
in `Surge/README.md`. The profile collects both sources in `Auto` and the
regional groups.
