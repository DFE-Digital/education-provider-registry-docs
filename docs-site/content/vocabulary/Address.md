# Address

[Back to vocabulary index](../)

| Property | Value |
| --- | --- |
| Canonical URI | <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/Address/> |
| Compact identifier | `epr:Address` |
| Preferred label | Address |
| Alternative labels |  |
| Legacy GIAS label |  |
| Status | Provisional |
| Broader concepts | [Establishment location and contact](../EstablishmentLocationAndContact/) |
| Related concepts |  |
| Defined by |  |
| Legislation |  |
| References |  |

## Definition

A postal or correspondence address. An independent concept from epr:Site — an address locates an establishment, site, or group for administrative and correspondence purposes. An establishment may have a registered address that differs from its principal teaching site. A trust or group carries a registered address and optionally a separate contact address as a legal entity.

## Scope Notes

- For establishments, the registered address is mapped from GIAS Establishment.Street, Locality, Address3, Town, Postcode and County. For groups and trusts, the registered address is mapped from EstablishmentGroup.GroupStreet etc. and the contact address from GroupContactStreet etc. Address is not the same as a site — UPRN belongs on the site, not the address.

## Source

Source TTL: [models/education-provider-vocabulary.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-vocabulary.ttl)
