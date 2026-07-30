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

Import the platform Raw URL as a managed profile. For manual nodes, use **Create
Linked Profile**, link `[General]`, `[Proxy Group]`, `[Rule]`, and `[Host]`, and
leave `[Proxy]` and `[MITM]` local. Add nodes only to `[Proxy]`; generate and
trust the certificate once in `[MITM]`. Keep provider URLs and tokens inside
Sub-Store; the managed profile already references its local `All` collection
and collects both Sub-Store and manual nodes in the regional groups.
