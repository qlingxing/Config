# Network Presets

The committed profiles use a China-oriented default: IPv4, domestic DNS
resolvers, and a mainland-reachable direct connectivity probe. This is the most
predictable default for the routing rules in this repository.

## China Default

Keep the generated configuration unchanged when the device normally uses a
mainland ISP. Proxy health checks still use `www.gstatic.com/generate_204`, so
they test the selected proxy rather than the direct network.

## Global Use

When the device normally operates outside mainland China, change DNS only in
the imported local copy. Use a resolver reachable before the proxy starts, or
configure the client-specific bootstrap and proxy policy required by that
resolver. Do not blindly add a public global DoH endpoint to every client:
bootstrap behavior and DNS routing differ among Surge, Loon, and Quantumult X.

After changing DNS or IPv6, verify domestic sites, overseas sites, streaming,
and the selected subscription nodes on that device. Keep the repository base
profile unchanged unless the new behavior is safe for both network presets.
