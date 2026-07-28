# Governance Taxonomy

This page is generated from `models/governance/governance-taxonomy.ttl`.

The taxonomy is a faceted SKOS taxonomy. Facets are represented as top concepts, and taxons sit beneath those facets using skos:broader relationships.

## Taxonomy Tree

The taxonomy tree starts with the facets. Expand a facet to inspect its taxons.

<div class="taxonomy-tree" aria-label="Taxonomy tree">
<ul>
<li>
  <details>
    <summary>Appointing party type <code>gov:AppointingPartyType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Academy trust members <code>gov:AcademyTrustMembersAppointingParty</code></span></li>
<li><span class="taxonomy-leaf">Foundation body <code>gov:FoundationBodyAppointingParty</code></span></li>
<li><span class="taxonomy-leaf">Governing body <code>gov:GoverningBodyAppointingParty</code></span></li>
<li><span class="taxonomy-leaf">Local authority <code>gov:LocalAuthorityAppointingParty</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Appointment status <code>gov:AppointmentStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Current appointment <code>gov:CurrentAppointmentStatus</code></span></li>
<li><span class="taxonomy-leaf">Ended appointment <code>gov:EndedAppointmentStatus</code></span></li>
<li><span class="taxonomy-leaf">Previous appointment <code>gov:PreviousAppointmentStatus</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Assurance record type <code>gov:AssuranceRecordType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Confirmation record <code>gov:ConfirmationRecordType</code></span></li>
<li><span class="taxonomy-leaf">DBS check record <code>gov:DbsCheckRecordType</code></span></li>
<li><span class="taxonomy-leaf">Declaration of interest <code>gov:DeclarationOfInterestRecordType</code></span></li>
<li><span class="taxonomy-leaf">Training attendance <code>gov:TrainingAttendanceRecordType</code></span></li>
<li><span class="taxonomy-leaf">Training booking <code>gov:TrainingBookingRecordType</code></span></li>
<li><span class="taxonomy-leaf">Training certificate <code>gov:TrainingCertificateRecordType</code></span></li>
<li><span class="taxonomy-leaf">Training record <code>gov:TrainingRecordType</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Committee role type <code>gov:CommitteeRoleType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Committee chair <code>gov:CommitteeChairRole</code></span></li>
<li><span class="taxonomy-leaf">Committee vice chair <code>gov:CommitteeViceChairRole</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Confirmation status <code>gov:ConfirmationStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Confirmed <code>gov:ConfirmedConfirmationStatus</code></span></li>
<li><span class="taxonomy-leaf">Expired <code>gov:ExpiredConfirmationStatus</code></span></li>
<li><span class="taxonomy-leaf">Not confirmed <code>gov:NotConfirmedConfirmationStatus</code></span></li>
<li><span class="taxonomy-leaf">Unconfirmed <code>gov:UnconfirmedConfirmationStatus</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Constitution position category <code>gov:ConstitutionPositionCategory</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Co-opted governor position <code>gov:CoOptedGovernorConstitutionPositionCategory</code></span></li>
<li><span class="taxonomy-leaf">Ex-officio governor position <code>gov:ExOfficioGovernorConstitutionPositionCategory</code></span></li>
<li><span class="taxonomy-leaf">Foundation governor position <code>gov:FoundationGovernorConstitutionPositionCategory</code></span></li>
<li><span class="taxonomy-leaf">Local authority governor position <code>gov:LocalAuthorityGovernorConstitutionPositionCategory</code></span></li>
<li><span class="taxonomy-leaf">Parent governor position <code>gov:ParentGovernorConstitutionPositionCategory</code></span></li>
<li><span class="taxonomy-leaf">Staff governor position <code>gov:StaffGovernorConstitutionPositionCategory</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Constitution position occupancy <code>gov:ConstitutionPositionOccupancy</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Filled <code>gov:FilledConstitutionPosition</code></span></li>
<li><span class="taxonomy-leaf">Vacant <code>gov:VacantConstitutionPosition</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Declaration outcome <code>gov:DeclarationOutcome</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Interest declared <code>gov:InterestDeclaredOutcome</code></span></li>
<li><span class="taxonomy-leaf">Nothing to Declare <code>gov:NothingToDeclareOutcome</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Governance appointment type <code>gov:GovernanceAppointmentType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Co-opted governor <code>gov:CoOptedGovernorAppointmentType</code></span></li>
<li><span class="taxonomy-leaf">Ex-officio governor <code>gov:ExOfficioGovernorAppointmentType</code></span></li>
<li><span class="taxonomy-leaf">Foundation governor <code>gov:FoundationGovernorAppointmentType</code></span></li>
<li><span class="taxonomy-leaf">Local authority governor <code>gov:LocalAuthorityGovernorAppointmentType</code></span></li>
<li><span class="taxonomy-leaf">Parent governor <code>gov:ParentGovernorAppointmentType</code></span></li>
<li><span class="taxonomy-leaf">Staff governor <code>gov:StaffGovernorAppointmentType</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Governance body type <code>gov:GovernanceBodyType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Federation governing body <code>gov:FederationGoverningBodyType</code></span></li>
<li><span class="taxonomy-leaf">Governance committee <code>gov:CommitteeGovernanceBodyType</code></span></li>
<li><span class="taxonomy-leaf">Interim Executive Board <code>gov:InterimExecutiveBoardType</code></span></li>
<li><span class="taxonomy-leaf">Local governing body <code>gov:LocalGoverningBodyType</code></span></li>
<li><span class="taxonomy-leaf">Maintained school governing body <code>gov:MaintainedSchoolGoverningBodyType</code></span></li>
<li><span class="taxonomy-leaf">Trust board <code>gov:TrustBoardGovernanceBodyType</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Governance participant capacity <code>gov:GovernanceParticipantCapacity</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Academy trust member <code>gov:AcademyTrustMemberCapacity</code></span></li>
<li><span class="taxonomy-leaf">Academy trustee <code>gov:AcademyTrusteeCapacity</code></span></li>
<li><span class="taxonomy-leaf">Clerk capacity <code>gov:ClerkCapacity</code></span></li>
<li><span class="taxonomy-leaf">Company director <code>gov:CompanyDirectorCapacity</code></span></li>
<li><span class="taxonomy-leaf">Governance professional capacity <code>gov:GovernanceProfessionalCapacity</code></span></li>
<li><span class="taxonomy-leaf">Governor <code>gov:GovernorCapacity</code></span></li>
<li><span class="taxonomy-leaf">Local governor <code>gov:LocalGovernorCapacity</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Governance role type <code>gov:GovernanceRoleType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Accounting officer <code>gov:AccountingOfficerRole</code></span></li>
<li><span class="taxonomy-leaf">Chair <code>gov:ChairRole</code></span></li>
<li><span class="taxonomy-leaf">Clerk role <code>gov:ClerkRole</code></span></li>
<li><span class="taxonomy-leaf">Governance professional role <code>gov:GovernanceProfessionalRole</code></span></li>
<li><span class="taxonomy-leaf">Vice chair <code>gov:ViceChairRole</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Historical record provenance <code>gov:HistoricalRecordProvenance</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Automatically created <code>gov:AutomaticallyCreatedHistoricalRecord</code></span></li>
<li><span class="taxonomy-leaf">Backfilled <code>gov:BackfilledHistoricalRecord</code></span></li>
<li><span class="taxonomy-leaf">Corrected <code>gov:CorrectedHistoricalRecord</code></span></li>
<li><span class="taxonomy-leaf">Manually created <code>gov:ManuallyCreatedHistoricalRecord</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Membership status <code>gov:MembershipStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Current membership <code>gov:CurrentMembershipStatus</code></span></li>
<li><span class="taxonomy-leaf">Ended membership <code>gov:EndedMembershipStatus</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Term status <code>gov:TermStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Current term <code>gov:CurrentTermStatus</code></span></li>
<li><span class="taxonomy-leaf">Ended early <code>gov:EndedEarlyTermStatus</code></span></li>
<li><span class="taxonomy-leaf">Expired term <code>gov:ExpiredTermStatus</code></span></li>
<li><span class="taxonomy-leaf">Future term <code>gov:FutureTermStatus</code></span></li>
    </ul>
  </details>
</li>
</ul>
</div>

## Facets

| Facet | Compact identifier | Vocabulary concept | Definition |
| --- | --- | --- | --- |
| Appointing party type | `gov:AppointingPartyType` |  | The classification of the party that appoints or nominates a person to a governance appointment. |
| Appointment status | `gov:AppointmentStatus` |  | The lifecycle classification of a governance appointment. |
| Assurance record type | `gov:AssuranceRecordType` |  | The classification of evidence or activity records used to support governance assurance. |
| Committee role type | `gov:CommitteeRoleType` |  | A named office or responsibility held within the scope of a governance committee. |
| Confirmation status | `gov:ConfirmationStatus` |  | The validity or reversal state of a declaration or assurance confirmation. |
| Constitution position category | `gov:ConstitutionPositionCategory` |  | The category of a position required or permitted by a governance body's constitution. |
| Constitution position occupancy | `gov:ConstitutionPositionOccupancy` |  | Whether a Constitution position is currently filled by a qualifying appointment. |
| Declaration outcome | `gov:DeclarationOutcome` |  | The substantive outcome recorded for a declaration of interests. |
| Governance appointment type | `gov:GovernanceAppointmentType` |  | The category or route through which a person holds a governance appointment. |
| Governance body type | `gov:GovernanceBodyType` |  | The classification of a body through which collective governance responsibilities are exercised. |
| Governance participant capacity | `gov:GovernanceParticipantCapacity` |  | The legal or governance capacity in which a person participates in a governance arrangement. |
| Governance role type | `gov:GovernanceRoleType` |  | A named office or responsibility assigned independently from a person's governance appointment type. |
| Historical record provenance | `gov:HistoricalRecordProvenance` |  | The origin or subsequent correction provenance of a retained historical governance representation. |
| Membership status | `gov:MembershipStatus` |  | The lifecycle classification of a person's membership of a governance body. |
| Term status | `gov:TermStatus` |  | The lifecycle classification of a term of office. |

## Taxons

| Taxon | Compact identifier | Vocabulary concept | Broader concept | Status |
| --- | --- | --- | --- | --- |
| Academy trust member | `gov:AcademyTrustMemberCapacity` |  | Governance participant capacity | Provisional |
| Academy trust members | `gov:AcademyTrustMembersAppointingParty` |  | Appointing party type | Provisional |
| Academy trustee | `gov:AcademyTrusteeCapacity` |  | Governance participant capacity | Provisional |
| Accounting officer | `gov:AccountingOfficerRole` |  | Governance role type | Provisional |
| Automatically created | `gov:AutomaticallyCreatedHistoricalRecord` |  | Historical record provenance | Provisional |
| Backfilled | `gov:BackfilledHistoricalRecord` |  | Historical record provenance | Provisional |
| Chair | `gov:ChairRole` |  | Governance role type | Provisional |
| Clerk capacity | `gov:ClerkCapacity` |  | Governance participant capacity | Provisional |
| Clerk role | `gov:ClerkRole` |  | Governance role type | Provisional |
| Committee chair | `gov:CommitteeChairRole` |  | Committee role type | Provisional |
| Committee vice chair | `gov:CommitteeViceChairRole` |  | Committee role type | Provisional |
| Company director | `gov:CompanyDirectorCapacity` |  | Governance participant capacity | Provisional |
| Confirmation record | `gov:ConfirmationRecordType` |  | Assurance record type | Provisional |
| Confirmed | `gov:ConfirmedConfirmationStatus` |  | Confirmation status | Provisional |
| Co-opted governor | `gov:CoOptedGovernorAppointmentType` |  | Governance appointment type | Provisional |
| Co-opted governor position | `gov:CoOptedGovernorConstitutionPositionCategory` |  | Constitution position category | Provisional |
| Corrected | `gov:CorrectedHistoricalRecord` |  | Historical record provenance | Provisional |
| Current appointment | `gov:CurrentAppointmentStatus` |  | Appointment status | Provisional |
| Current membership | `gov:CurrentMembershipStatus` |  | Membership status | Provisional |
| Current term | `gov:CurrentTermStatus` |  | Term status | Provisional |
| DBS check record | `gov:DbsCheckRecordType` |  | Assurance record type | Provisional |
| Declaration of interest | `gov:DeclarationOfInterestRecordType` |  | Assurance record type | Provisional |
| Ended appointment | `gov:EndedAppointmentStatus` |  | Appointment status | Provisional |
| Ended early | `gov:EndedEarlyTermStatus` |  | Term status | Provisional |
| Ended membership | `gov:EndedMembershipStatus` |  | Membership status | Provisional |
| Ex-officio governor | `gov:ExOfficioGovernorAppointmentType` |  | Governance appointment type | Provisional |
| Ex-officio governor position | `gov:ExOfficioGovernorConstitutionPositionCategory` |  | Constitution position category | Provisional |
| Expired | `gov:ExpiredConfirmationStatus` |  | Confirmation status | Provisional |
| Expired term | `gov:ExpiredTermStatus` |  | Term status | Provisional |
| Federation governing body | `gov:FederationGoverningBodyType` |  | Governance body type | Provisional |
| Filled | `gov:FilledConstitutionPosition` |  | Constitution position occupancy | Provisional |
| Foundation body | `gov:FoundationBodyAppointingParty` |  | Appointing party type | Provisional |
| Foundation governor | `gov:FoundationGovernorAppointmentType` |  | Governance appointment type | Provisional |
| Foundation governor position | `gov:FoundationGovernorConstitutionPositionCategory` |  | Constitution position category | Provisional |
| Future term | `gov:FutureTermStatus` |  | Term status | Provisional |
| Governance committee | `gov:CommitteeGovernanceBodyType` |  | Governance body type | Provisional |
| Governance professional capacity | `gov:GovernanceProfessionalCapacity` |  | Governance participant capacity | Provisional |
| Governance professional role | `gov:GovernanceProfessionalRole` |  | Governance role type | Provisional |
| governanceTaxonomy | `gov:governanceTaxonomy` |  |  | Provisional |
| Governing body | `gov:GoverningBodyAppointingParty` |  | Appointing party type | Provisional |
| Governor | `gov:GovernorCapacity` |  | Governance participant capacity | Provisional |
| Interest declared | `gov:InterestDeclaredOutcome` |  | Declaration outcome | Provisional |
| Interim Executive Board | `gov:InterimExecutiveBoardType` |  | Governance body type | Provisional |
| Local authority | `gov:LocalAuthorityAppointingParty` |  | Appointing party type | Provisional |
| Local authority governor | `gov:LocalAuthorityGovernorAppointmentType` |  | Governance appointment type | Provisional |
| Local authority governor position | `gov:LocalAuthorityGovernorConstitutionPositionCategory` |  | Constitution position category | Provisional |
| Local governing body | `gov:LocalGoverningBodyType` |  | Governance body type | Provisional |
| Local governor | `gov:LocalGovernorCapacity` |  | Governance participant capacity | Provisional |
| Maintained school governing body | `gov:MaintainedSchoolGoverningBodyType` |  | Governance body type | Provisional |
| Manually created | `gov:ManuallyCreatedHistoricalRecord` |  | Historical record provenance | Provisional |
| Not confirmed | `gov:NotConfirmedConfirmationStatus` |  | Confirmation status | Provisional |
| Nothing to Declare | `gov:NothingToDeclareOutcome` |  | Declaration outcome | Provisional |
| Parent governor | `gov:ParentGovernorAppointmentType` |  | Governance appointment type | Provisional |
| Parent governor position | `gov:ParentGovernorConstitutionPositionCategory` |  | Constitution position category | Provisional |
| Previous appointment | `gov:PreviousAppointmentStatus` |  | Appointment status | Provisional |
| Staff governor | `gov:StaffGovernorAppointmentType` |  | Governance appointment type | Provisional |
| Staff governor position | `gov:StaffGovernorConstitutionPositionCategory` |  | Constitution position category | Provisional |
| Training attendance | `gov:TrainingAttendanceRecordType` |  | Assurance record type | Provisional |
| Training booking | `gov:TrainingBookingRecordType` |  | Assurance record type | Provisional |
| Training certificate | `gov:TrainingCertificateRecordType` |  | Assurance record type | Provisional |
| Training record | `gov:TrainingRecordType` |  | Assurance record type | Provisional |
| Trust board | `gov:TrustBoardGovernanceBodyType` |  | Governance body type | Provisional |
| Unconfirmed | `gov:UnconfirmedConfirmationStatus` |  | Confirmation status | Provisional |
| Vacant | `gov:VacantConstitutionPosition` |  | Constitution position occupancy | Provisional |
| Vice chair | `gov:ViceChairRole` |  | Governance role type | Provisional |
