# Sub-Store Products

Sub-Store stores provider subscriptions and generated products on the device.
The `sub.store` URLs below are local module endpoints, not public subscription
URLs. Install and enable the official Sub-Store integration before adding the
matching URL in the client.

| Client | Official integration | Product URL |
| --- | --- | --- |
| Surge macOS | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule` | `https://sub.store/download/collection/All?target=SurgeMac` |
| Surge iOS | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule` | `https://sub.store/download/collection/All?target=Surge` |
| Loon | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Loon.plugin` | `https://sub.store/download/collection/All?target=Loon` |
| Quantumult X | `https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/QX.snippet` | `https://sub.store/download/collection/All?target=QX` |

`All` is the collection name. Replace it with the name configured in Sub-Store
when a different collection is used. Keep provider URLs and account credentials
inside Sub-Store; do not put them in this repository or a public Raw profile.
