# Governance Taxonomy

This page is generated from `models/governance/governance-taxonomy.ttl`.

The taxonomy is a faceted SKOS taxonomy. Facets are represented as top concepts, and taxons sit beneath those facets using skos:broader relationships.

## Taxonomy Tree

The taxonomy tree starts with the facets. Expand a facet to inspect its taxons.

<div class="taxonomy-tree" aria-label="Taxonomy tree">
<ul>
<li>
  <details>
    <summary>Actor and user type <code>gov:ActorAndUserType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Member <code>gov:Member</code></span></li>
<li><span class="taxonomy-leaf">Person <code>est:Person</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Appointing body type <code>gov:AppointingBodyType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Appointing body <code>gov:AppointingBody</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Appointment and term status <code>gov:AppointmentAndTermStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Appointment <code>gov:Appointment</code></span></li>
<li><span class="taxonomy-leaf">Term of office <code>gov:TermOfOffice</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Appointment basis <code>gov:AppointmentBasis</code></summary>
    <ul>
<li>
  <details>
    <summary>Delegated governance appointment <code>gov:DelegatedGovernanceAppointment</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Academy trust member <code>gov:AcademyTrustMember</code></span></li>
<li><span class="taxonomy-leaf">Academy trustee <code>gov:AcademyTrustee</code></span></li>
<li><span class="taxonomy-leaf">Local governing body member <code>gov:LocalGoverningBodyMember</code></span></li>
<li><span class="taxonomy-leaf">Trust member <code>gov:TrustMember</code></span></li>
<li><span class="taxonomy-leaf">Trustee <code>gov:Trustee</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Operational employment role <code>gov:OperationalEmploymentRole</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Accounting officer <code>gov:AccountingOfficer</code></span></li>
<li><span class="taxonomy-leaf">Chief financial officer <code>gov:ChiefFinancialOfficer</code></span></li>
<li><span class="taxonomy-leaf">Principal <code>gov:Principal</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Professional support role <code>gov:ProfessionalSupportRole</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Clerk <code>gov:Clerk</code></span></li>
<li><span class="taxonomy-leaf">Company secretary <code>gov:CompanySecretary</code></span></li>
<li><span class="taxonomy-leaf">Governance professional <code>gov:GovernanceProfessional</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Statutory governance appointment <code>gov:StatutoryGovernanceAppointment</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Associate governor <code>gov:AssociateGovernor</code></span></li>
<li><span class="taxonomy-leaf">Board member <code>gov:BoardMember</code></span></li>
<li><span class="taxonomy-leaf">Chair <code>gov:Chair</code></span></li>
<li><span class="taxonomy-leaf">Co-opted governor <code>gov:CoOptedGovernor</code></span></li>
<li><span class="taxonomy-leaf">Committee chair <code>gov:CommitteeChair</code></span></li>
<li><span class="taxonomy-leaf">Committee vice chair <code>gov:CommitteeViceChair</code></span></li>
<li><span class="taxonomy-leaf">Ex-officio governor <code>gov:ExOfficioGovernor</code></span></li>
<li><span class="taxonomy-leaf">Foundation governor <code>gov:FoundationGovernor</code></span></li>
<li><span class="taxonomy-leaf">Governor <code>gov:Governor</code></span></li>
<li><span class="taxonomy-leaf">Local authority governor <code>gov:LocalAuthorityGovernor</code></span></li>
<li><span class="taxonomy-leaf">Local governor <code>gov:LocalGovernor</code></span></li>
<li><span class="taxonomy-leaf">Parent governor <code>gov:ParentGovernor</code></span></li>
<li><span class="taxonomy-leaf">Partnership governor <code>gov:PartnershipGovernor</code></span></li>
<li><span class="taxonomy-leaf">Staff governor <code>gov:StaffGovernor</code></span></li>
<li><span class="taxonomy-leaf">Vice chair <code>gov:ViceChair</code></span></li>
    </ul>
  </details>
</li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Appointment type <code>gov:AppointmentType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Appointment <code>gov:Appointment</code></span></li>
<li><span class="taxonomy-leaf">Board membership <code>gov:BoardMembership</code></span></li>
<li><span class="taxonomy-leaf">Committee membership <code>gov:CommitteeMembership</code></span></li>
<li><span class="taxonomy-leaf">Membership <code>gov:Membership</code></span></li>
<li><span class="taxonomy-leaf">Role assignment <code>gov:RoleAssignment</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Collaboration and document type <code>gov:CollaborationAndDocumentType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Attendance <code>gov:Attendance</code></span></li>
<li><span class="taxonomy-leaf">Meeting <code>gov:Meeting</code></span></li>
<li><span class="taxonomy-leaf">Noticeboard <code>gov:Noticeboard</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Committee responsibility <code>gov:CommitteeResponsibility</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Committee <code>gov:Committee</code></span></li>
<li><span class="taxonomy-leaf">Committee chair <code>gov:CommitteeChair</code></span></li>
<li><span class="taxonomy-leaf">Committee membership <code>gov:CommitteeMembership</code></span></li>
<li><span class="taxonomy-leaf">Committee vice chair <code>gov:CommitteeViceChair</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Compliance and declaration status <code>gov:ComplianceAndDeclarationStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Confirmation <code>gov:Confirmation</code></span></li>
<li><span class="taxonomy-leaf">Declaration <code>gov:Declaration</code></span></li>
<li><span class="taxonomy-leaf">Declaration of interest <code>gov:DeclarationOfInterest</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Constitution position type <code>gov:ConstitutionPositionType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Constitution <code>gov:Constitution</code></span></li>
<li><span class="taxonomy-leaf">Constitution position <code>gov:ConstitutionPosition</code></span></li>
<li><span class="taxonomy-leaf">Vacancy <code>gov:Vacancy</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Governance participant type <code>gov:GovernanceParticipantType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Academy trust member <code>gov:AcademyTrustMember</code></span></li>
<li><span class="taxonomy-leaf">Academy trustee <code>gov:AcademyTrustee</code></span></li>
<li><span class="taxonomy-leaf">Associate governor <code>gov:AssociateGovernor</code></span></li>
<li><span class="taxonomy-leaf">Board member <code>gov:BoardMember</code></span></li>
<li><span class="taxonomy-leaf">Charity trustee <code>gov:CharityTrustee</code></span></li>
<li><span class="taxonomy-leaf">Clerk <code>gov:Clerk</code></span></li>
<li><span class="taxonomy-leaf">Co-opted governor <code>gov:CoOptedGovernor</code></span></li>
<li><span class="taxonomy-leaf">Company director <code>gov:CompanyDirector</code></span></li>
<li><span class="taxonomy-leaf">Director <code>gov:Director</code></span></li>
<li><span class="taxonomy-leaf">Ex-officio governor <code>gov:ExOfficioGovernor</code></span></li>
<li><span class="taxonomy-leaf">Foundation governor <code>gov:FoundationGovernor</code></span></li>
<li><span class="taxonomy-leaf">Governance professional <code>gov:GovernanceProfessional</code></span></li>
<li><span class="taxonomy-leaf">Governor <code>gov:Governor</code></span></li>
<li><span class="taxonomy-leaf">Governor type <code>gov:GovernorType</code></span></li>
<li><span class="taxonomy-leaf">Local authority governor <code>gov:LocalAuthorityGovernor</code></span></li>
<li><span class="taxonomy-leaf">Local governing body member <code>gov:LocalGoverningBodyMember</code></span></li>
<li><span class="taxonomy-leaf">Local governor <code>gov:LocalGovernor</code></span></li>
<li><span class="taxonomy-leaf">Parent governor <code>gov:ParentGovernor</code></span></li>
<li><span class="taxonomy-leaf">Partnership governor <code>gov:PartnershipGovernor</code></span></li>
<li><span class="taxonomy-leaf">Principal <code>gov:Principal</code></span></li>
<li><span class="taxonomy-leaf">Staff governor <code>gov:StaffGovernor</code></span></li>
<li><span class="taxonomy-leaf">Trust member <code>gov:TrustMember</code></span></li>
<li><span class="taxonomy-leaf">Trustee <code>gov:Trustee</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Historical record status <code>gov:HistoricalRecordStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Change history <code>gov:ChangeHistory</code></span></li>
<li><span class="taxonomy-leaf">Historical appointment <code>gov:HistoricalAppointment</code></span></li>
<li><span class="taxonomy-leaf">Historical member <code>gov:HistoricalMember</code></span></li>
<li><span class="taxonomy-leaf">Historical record <code>gov:HistoricalRecord</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Organisation and board scope <code>gov:OrganisationAndBoardScope</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Academy <code>est:Academy</code></span></li>
<li><span class="taxonomy-leaf">Board <code>gov:Board</code></span></li>
<li><span class="taxonomy-leaf">Board of directors <code>gov:BoardOfDirectors</code></span></li>
<li><span class="taxonomy-leaf">Companies House legal entity <code>gov:CompaniesHouseLegalEntity</code></span></li>
<li><span class="taxonomy-leaf">Establishment <code>est:Establishment</code></span></li>
<li><span class="taxonomy-leaf">Federation <code>est:Federation</code></span></li>
<li><span class="taxonomy-leaf">Governing board <code>gov:GoverningBoard</code></span></li>
<li><span class="taxonomy-leaf">Governing body <code>gov:GoverningBody</code></span></li>
<li><span class="taxonomy-leaf">Interim Executive Board <code>gov:InterimExecutiveBoard</code></span></li>
<li><span class="taxonomy-leaf">Legal entity <code>est:LegalEntity</code></span></li>
<li><span class="taxonomy-leaf">Local authority <code>est:LocalAuthority</code></span></li>
<li><span class="taxonomy-leaf">Local governing body <code>gov:LocalGoverningBody</code></span></li>
<li><span class="taxonomy-leaf">School <code>gov:School</code></span></li>
<li><span class="taxonomy-leaf">Trust board <code>gov:TrustBoard</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Role and office-holder responsibility <code>gov:RoleAndOfficeResponsibility</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Accounting officer <code>gov:AccountingOfficer</code></span></li>
<li><span class="taxonomy-leaf">Chair <code>gov:Chair</code></span></li>
<li><span class="taxonomy-leaf">Chief financial officer <code>gov:ChiefFinancialOfficer</code></span></li>
<li><span class="taxonomy-leaf">Committee chair <code>gov:CommitteeChair</code></span></li>
<li><span class="taxonomy-leaf">Committee vice chair <code>gov:CommitteeViceChair</code></span></li>
<li><span class="taxonomy-leaf">Company secretary <code>gov:CompanySecretary</code></span></li>
<li><span class="taxonomy-leaf">Office-holder <code>gov:OfficeHolder</code></span></li>
<li><span class="taxonomy-leaf">Role <code>gov:Role</code></span></li>
<li><span class="taxonomy-leaf">Specialist responsibility <code>gov:SpecialistResponsibility</code></span></li>
<li><span class="taxonomy-leaf">Vice chair <code>gov:ViceChair</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Training and assurance record type <code>gov:TrainingAndAssuranceRecordType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Training <code>gov:Training</code></span></li>
<li><span class="taxonomy-leaf">Training record <code>gov:TrainingRecord</code></span></li>
    </ul>
  </details>
</li>
</ul>
</div>

## Facets

| Facet | Compact identifier | Vocabulary concept | Definition |
| --- | --- | --- | --- |
| Actor and user type | `gov:ActorAndUserType` |  | The kind of person or actor participating in or administering governance. |
| Appointing body type | `gov:AppointingBodyType` |  | The body or mechanism that appointed, nominated or elected a governance participant, kept independent of the appointment's type and of any role subsequently assigned to the participant. |
| Appointment and term status | `gov:AppointmentAndTermStatus` |  | The time-bound appointment information used to describe a governance position. |
| Appointment basis | `gov:AppointmentBasis` |  | The basis on which a governance participant holds their position: a statutory governance appointment, an Academy Trust delegated/constitutional appointment, a paid operational employment role, or a role whose employment arrangement varies. This is an orthogonal classification, applied alongside a concept's primary facet, and is only assigned where the evidence in academy-trust-governance-real-world-rules.md and the Academy Trust Handbook supports it - it is not applied to organisation, record, process or legal-capacity concepts, or to concepts with no direct evidence either way. |
| Appointment type | `gov:AppointmentType` |  | The type of governance appointment or membership arrangement held by a participant. |
| Collaboration and document type | `gov:CollaborationAndDocumentType` |  | Governance activities and shared communication artefacts. |
| Committee responsibility | `gov:CommitteeResponsibility` |  | A committee and the membership or chairing responsibilities associated with it. |
| Compliance and declaration status | `gov:ComplianceAndDeclarationStatus` |  | Declarations and confirmations supporting governance assurance and compliance. |
| Constitution position type | `gov:ConstitutionPositionType` |  | A constitution-defined position, including whether the position is occupied or vacant. |
| Governance participant type | `gov:GovernanceParticipantType` |  | The participant capacity in which a person contributes to governance. |
| Historical record status | `gov:HistoricalRecordStatus` |  | A classification for governance records retained after a membership, appointment or state has ended. |
| Organisation and board scope | `gov:OrganisationAndBoardScope` |  | The organisation, establishment or governing body to which governance data relates. |
| Role and office-holder responsibility | `gov:RoleAndOfficeResponsibility` |  | A named responsibility or office held by a governance participant. |
| Training and assurance record type | `gov:TrainingAndAssuranceRecordType` |  | Learning and evidence records used to support governance capability and assurance. |

## Taxons

| Taxon | Compact identifier | Vocabulary concept | Broader concept | Status |
| --- | --- | --- | --- | --- |
| Academy | `est:Academy` |  | Organisation and board scope |  |
| Academy trust member | `gov:AcademyTrustMember` |  | Governance participant type<br>Delegated governance appointment | Provisional |
| Academy trustee | `gov:AcademyTrustee` |  | Governance participant type<br>Delegated governance appointment | Provisional |
| Accounting officer | `gov:AccountingOfficer` |  | Role and office-holder responsibility<br>Operational employment role | Provisional |
| Appointing body | `gov:AppointingBody` |  | Appointing body type | Provisional |
| Appointment | `gov:Appointment` |  | Appointment type<br>Appointment and term status | Provisional |
| Associate governor | `gov:AssociateGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Attendance | `gov:Attendance` |  | Collaboration and document type | Provisional |
| Board | `gov:Board` |  | Organisation and board scope | Provisional |
| Board member | `gov:BoardMember` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Board membership | `gov:BoardMembership` |  | Appointment type | Provisional |
| Board of directors | `gov:BoardOfDirectors` |  | Organisation and board scope | Provisional |
| Chair | `gov:Chair` |  | Role and office-holder responsibility<br>Statutory governance appointment | Provisional |
| Change history | `gov:ChangeHistory` |  | Historical record status | Provisional |
| Charity trustee | `gov:CharityTrustee` |  | Governance participant type | Provisional |
| Chief financial officer | `gov:ChiefFinancialOfficer` |  | Role and office-holder responsibility<br>Operational employment role | Provisional |
| Clerk | `gov:Clerk` |  | Governance participant type<br>Professional support role | Provisional |
| Co-opted governor | `gov:CoOptedGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Committee | `gov:Committee` |  | Committee responsibility | Provisional |
| Committee chair | `gov:CommitteeChair` |  | Role and office-holder responsibility<br>Committee responsibility<br>Statutory governance appointment | Provisional |
| Committee membership | `gov:CommitteeMembership` |  | Appointment type<br>Committee responsibility | Provisional |
| Committee vice chair | `gov:CommitteeViceChair` |  | Role and office-holder responsibility<br>Committee responsibility<br>Statutory governance appointment | Provisional |
| Companies House legal entity | `gov:CompaniesHouseLegalEntity` |  | Organisation and board scope | Provisional |
| Company director | `gov:CompanyDirector` |  | Governance participant type | Provisional |
| Company secretary | `gov:CompanySecretary` |  | Role and office-holder responsibility<br>Professional support role | Provisional |
| Confirmation | `gov:Confirmation` |  | Compliance and declaration status | Provisional |
| Constitution | `gov:Constitution` |  | Constitution position type | Provisional |
| Constitution position | `gov:ConstitutionPosition` |  | Constitution position type | Provisional |
| Declaration | `gov:Declaration` |  | Compliance and declaration status | Provisional |
| Declaration of interest | `gov:DeclarationOfInterest` |  | Compliance and declaration status | Provisional |
| Delegated governance appointment | `gov:DelegatedGovernanceAppointment` |  | Appointment basis | Provisional |
| Director | `gov:Director` |  | Governance participant type | Provisional |
| Establishment | `est:Establishment` |  | Organisation and board scope |  |
| Ex-officio governor | `gov:ExOfficioGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Federation | `est:Federation` |  | Organisation and board scope |  |
| Foundation governor | `gov:FoundationGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Governance professional | `gov:GovernanceProfessional` |  | Governance participant type<br>Professional support role | Provisional |
| governanceTaxonomy | `gov:governanceTaxonomy` |  |  | Provisional |
| Governing board | `gov:GoverningBoard` |  | Organisation and board scope | Provisional |
| Governing body | `gov:GoverningBody` |  | Organisation and board scope | Provisional |
| Governor | `gov:Governor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Governor type | `gov:GovernorType` |  | Governance participant type | Provisional |
| Historical appointment | `gov:HistoricalAppointment` |  | Historical record status | Provisional |
| Historical member | `gov:HistoricalMember` |  | Historical record status | Provisional |
| Historical record | `gov:HistoricalRecord` |  | Historical record status | Provisional |
| Interim Executive Board | `gov:InterimExecutiveBoard` |  | Organisation and board scope | Provisional |
| Legal entity | `est:LegalEntity` |  | Organisation and board scope |  |
| Local authority | `est:LocalAuthority` |  | Organisation and board scope |  |
| Local authority governor | `gov:LocalAuthorityGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Local governing body | `gov:LocalGoverningBody` |  | Organisation and board scope | Provisional |
| Local governing body member | `gov:LocalGoverningBodyMember` |  | Governance participant type<br>Delegated governance appointment | Provisional |
| Local governor | `gov:LocalGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Meeting | `gov:Meeting` |  | Collaboration and document type | Provisional |
| Member | `gov:Member` |  | Actor and user type | Provisional |
| Membership | `gov:Membership` |  | Appointment type | Provisional |
| Noticeboard | `gov:Noticeboard` |  | Collaboration and document type | Provisional |
| Office-holder | `gov:OfficeHolder` |  | Role and office-holder responsibility | Provisional |
| Operational employment role | `gov:OperationalEmploymentRole` |  | Appointment basis | Provisional |
| Parent governor | `gov:ParentGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Partnership governor | `gov:PartnershipGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Person | `est:Person` |  | Actor and user type |  |
| Principal | `gov:Principal` |  | Governance participant type<br>Operational employment role | Provisional |
| Professional support role | `gov:ProfessionalSupportRole` |  | Appointment basis | Provisional |
| Role | `gov:Role` |  | Role and office-holder responsibility | Provisional |
| Role assignment | `gov:RoleAssignment` |  | Appointment type | Provisional |
| School | `gov:School` |  | Organisation and board scope | Provisional |
| Specialist responsibility | `gov:SpecialistResponsibility` |  | Role and office-holder responsibility | Provisional |
| Staff governor | `gov:StaffGovernor` |  | Governance participant type<br>Statutory governance appointment | Provisional |
| Statutory governance appointment | `gov:StatutoryGovernanceAppointment` |  | Appointment basis | Provisional |
| Term of office | `gov:TermOfOffice` |  | Appointment and term status | Provisional |
| Training | `gov:Training` |  | Training and assurance record type | Provisional |
| Training record | `gov:TrainingRecord` |  | Training and assurance record type | Provisional |
| Trust board | `gov:TrustBoard` |  | Organisation and board scope | Provisional |
| Trust member | `gov:TrustMember` |  | Governance participant type<br>Delegated governance appointment | Provisional |
| Trustee | `gov:Trustee` |  | Governance participant type<br>Delegated governance appointment | Provisional |
| Vacancy | `gov:Vacancy` |  | Constitution position type | Provisional |
| Vice chair | `gov:ViceChair` |  | Role and office-holder responsibility<br>Statutory governance appointment | Provisional |
