# T10: Outwood registered office

The existing Outwood legal entity has Companies House number **06995649**.
On 19 October 2026 its [Companies House overview](https://find-and-update.company-information.service.gov.uk/company/06995649)
explicitly published this registered office:

> Potovens Lane, Outwood, Wakefield, West Yorkshire, WF1 2PF

The company-number match and the explicit registered-office label establish
the owner and purpose. The migration adds one current registered-office
association to the existing legal entity and records the observation as a
Companies House source. It stores the source URL, observation date, raw address
text and normalised fields in the checked-in source extract and migration
evidence.

The observation date is not an effective address-use date. Start and end stay
null. The existing BAU administrative association retains its own postal values
and provenance. In particular, its obfuscated third line is not copied into
the Companies House address, and its unknown county is not overwritten.

The [source fixture](../../seed/fixtures/t10-registered-office.json) is replayed
by [the supplementary runner](../../automation/migrate-t10-registered-office.ps1).
Unchanged observations reuse the address, association and evidence. A changed
registered-office address requires review rather than overwriting the current
assertion. [Validation SQL](../../migration/validate-scripts/validate-t10-registered-office.sql)
checks the registered office, provenance and preservation of the BAU address.
