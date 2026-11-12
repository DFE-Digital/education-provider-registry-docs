# Reference-data key rules

The establishment model uses the following identities.

| Kind | Internal key | BAU value |
| --- | --- | --- |
| Bounded list with a plain-integer BAU code | The BAU integer is the primary key. | The primary-key value. |
| Bounded list with a text or leading-zero BAU code | Integer primary key. | Separate text `code`. |
| Unbounded external dataset | UUID primary key. | Separate `code` where the source provides one. |

The bounded plain-integer lists are establishment type category, establishment status, education phase, gender of entry, admissions policy and boarding provision. Establishment type and opening/closure reason retain integer keys with their leading-zero text codes. Diocese is an unbounded external dataset and has a UUID `diocese_id` with a text code.

Relationship and migration-evidence tables use a UUID internal primary key, while their natural business identifiers remain unique constraints.
