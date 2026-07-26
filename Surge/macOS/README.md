# Surge for macOS

Use `Surge-5.conf` with Surge Mac 5.0 or newer. Use `Surge-6.conf` only with
Surge Mac 6.0 or newer. Both profiles enable the Surge web dashboard and use
the same routing and optional module set. The Mac 5 profile uses static
selectors instead of dynamic node-name filtering; choose the desired node from
each selector after adding nodes or a subscription. Its General section stays
within the syntax verified by the existing Mac 5 configuration. Its base rules
are local only; add remote rulesets or modules from Surge after the profile is
imported.

See `../README.md` for manual-node and subscription setup.

If Surge reports a generic parsing error for `Surge-5.conf`, import
`Surge-5-Diagnostic.conf` first. It contains only Mac 5 baseline syntax and no
remote resources; do not use it as a daily profile.

If that file imports successfully but `Surge-5.conf` does not, import these two
diagnostic files in order: `Surge-5-General-Diagnostic.conf`, then
`Surge-5-Group-Diagnostic.conf`. This isolates the General settings from the
static policy-group definitions.
