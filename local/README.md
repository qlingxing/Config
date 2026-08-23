# Local Configuration

The files in `source/` are repository-managed inputs. Do not put secrets or
device-specific values there. Keep local changes in the imported client copy,
or store them in ignored `*.private.conf` files as reference material.

## Quantumult X

Append the contents of `QuantumultX/Local/ServerRemote.private.conf.example` to
the imported profile when adding raw or Sub-Store production subscriptions.
Manual nodes belong in `[server_local]` in the same active profile; use
`QuantumultX/Local/ServerLocal.private.conf.example` as the local template. The QX
`全部节点` explicitly merges QX's `已保存` resource with `Sub-Store All`, then
selects every node from both resources. Nodes added under another resource tag
must be added to the resource expression before they can appear in this policy.

## Loon

Append the contents of `Loon/Local/RemoteProxy.private.conf.example` to the
imported profile. Use `[Proxy]` for manual nodes and `[Remote Proxy]` for
subscriptions.

## Surge

Import the platform Raw URL as the managed source, then create an editable copy
for daily use. Add manual nodes only to `[Proxy]`, and generate and trust the
certificate in `[MITM]` in that copy. Keep provider URLs and tokens inside
Sub-Store. Rulesets, the Sub-Store product, and modules update independently in
the copy; create another copy only after the managed source profile itself has
changed.
