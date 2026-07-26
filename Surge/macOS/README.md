# Surge for macOS

Use `Surge-5.conf` with Surge Mac 5.0 or newer. Use `Surge-6.conf` only with
Surge Mac 6.0 or newer. Both profiles enable the Surge web dashboard and use
the same routing and optional module set; the Mac 5 profile excludes Mac 6-only
general settings and uses conservative policy-group syntax for older 5.x builds.

See `../README.md` for manual-node and subscription setup.

If Surge reports a generic parsing error for `Surge-5.conf`, import
`Surge-5-Diagnostic.conf` first. It contains only Mac 5 baseline syntax and no
remote resources; do not use it as a daily profile.
