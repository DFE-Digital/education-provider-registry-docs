# Education Provider Registry Taxonomy

This page is generated from `models/education-provider-taxonomy.ttl`.

The taxonomy is a faceted SKOS taxonomy. Facets are represented as top concepts, and taxons sit beneath those facets using skos:broader relationships.

## Taxonomy Tree

The taxonomy tree starts with the facets. Expand a facet to inspect its taxons.

<div class="taxonomy-tree" aria-label="Taxonomy tree">
<ul>
<li>
  <details>
    <summary>Admissions policy <code>epr:AdmissionsPolicy</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Non-selective <code>epr:NonSelectiveAdmissions</code></span></li>
<li><span class="taxonomy-leaf">Not applicable (admissions policy) <code>epr:NotApplicableAdmissionsPolicy</code></span></li>
<li><span class="taxonomy-leaf">Selective <code>epr:SelectiveAdmissions</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Boarding provision <code>epr:BoardingProvision</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Boarding school <code>epr:BoardingSchool</code></span></li>
<li><span class="taxonomy-leaf">Has boarders <code>epr:HasBoarders</code></span></li>
<li><span class="taxonomy-leaf">No boarders <code>epr:NoBoarders</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Education phase <code>epr:EducationPhase</code></summary>
    <ul>
<li><span class="taxonomy-leaf">16 to 19 <code>epr:SixteenToNineteenPhase</code></span></li>
<li><span class="taxonomy-leaf">All-through <code>epr:AllThroughPhase</code></span></li>
<li><span class="taxonomy-leaf">Middle deemed primary <code>epr:MiddlePhase</code></span></li>
<li><span class="taxonomy-leaf">Middle deemed secondary <code>epr:MiddleDeemedSecondaryPhase</code></span></li>
<li><span class="taxonomy-leaf">Not applicable (education phase) <code>epr:NotApplicableEducationPhase</code></span></li>
<li><span class="taxonomy-leaf">Nursery <code>epr:NurseryPhase</code></span></li>
<li><span class="taxonomy-leaf">Primary <code>epr:PrimaryPhase</code></span></li>
<li><span class="taxonomy-leaf">Secondary <code>epr:SecondaryPhase</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Establishment group type <code>epr:EstablishmentGroupType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Children&#39;s centres collaboration <code>epr:ChildrensCentreCollaboration</code></span></li>
<li><span class="taxonomy-leaf">Children&#39;s centres group <code>epr:ChildrensCentreGroup</code></span></li>
<li><span class="taxonomy-leaf">Federation <code>epr:Federation</code></span></li>
<li><span class="taxonomy-leaf">Multi-academy trust <code>epr:MultiAcademyTrust</code></span></li>
<li><span class="taxonomy-leaf">Secure single-academy trust <code>epr:SecureSingleAcademyTrust</code></span></li>
<li><span class="taxonomy-leaf">Single-academy trust <code>epr:SingleAcademyTrust</code></span></li>
<li><span class="taxonomy-leaf">Trust <code>epr:GenericTrust</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Establishment status <code>epr:EstablishmentStatus</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Closed <code>epr:ClosedStatus</code></span></li>
<li><span class="taxonomy-leaf">Open <code>epr:OpenStatus</code></span></li>
<li><span class="taxonomy-leaf">Open, but proposed to close <code>epr:OpenProposedToCloseStatus</code></span></li>
<li><span class="taxonomy-leaf">Proposed to open <code>epr:ProposedToOpenStatus</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Establishment type <code>epr:EstablishmentType</code></summary>
    <ul>
<li>
  <details>
    <summary>Academies <code>epr:EstablishmentTypeGroupAcademies</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Academy 16 to 19 <code>epr:Academy1619</code></span></li>
<li><span class="taxonomy-leaf">Academy alternative provision <code>epr:AcademyAlternativeProvision</code></span></li>
<li><span class="taxonomy-leaf">Academy secure 16 to 19 <code>epr:AcademySecure16To19</code></span></li>
<li><span class="taxonomy-leaf">Academy special school <code>epr:AcademySpecial</code></span></li>
<li><span class="taxonomy-leaf">Mainstream academy <code>epr:MainstreamAcademy</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Children&#39;s centres <code>epr:EstablishmentTypeGroupChildrensCentres</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Children&#39;s centre <code>epr:ChildrensCentre</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Colleges <code>epr:EstablishmentTypeGroupColleges</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Further education <code>epr:FurtherEducation</code></span></li>
<li><span class="taxonomy-leaf">Sixth form centre <code>epr:SixthFormCentre</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Free schools (type group) <code>epr:EstablishmentTypeGroupFreeSchools</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Free schools <code>epr:FreeSchool</code></span></li>
<li><span class="taxonomy-leaf">Free schools 16 to 19 <code>epr:FreeSchool16To19</code></span></li>
<li><span class="taxonomy-leaf">Free schools alternative provision <code>epr:FreeSchoolAlternativeProvision</code></span></li>
<li><span class="taxonomy-leaf">Free schools special <code>epr:FreeSchoolSpecial</code></span></li>
<li><span class="taxonomy-leaf">Studio schools <code>epr:StudioSchool</code></span></li>
<li><span class="taxonomy-leaf">University technical college <code>epr:UniversityTechnicalCollege</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Independent schools <code>epr:EstablishmentTypeGroupIndependentSchools</code></summary>
    <ul>
<li><span class="taxonomy-leaf">City technology college <code>epr:CityTechnologyCollege</code></span></li>
<li><span class="taxonomy-leaf">Other independent school <code>epr:OtherIndependentSchool</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Local authority maintained schools <code>epr:EstablishmentTypeGroupLaMaintainedSchools</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Community school <code>epr:CommunitySchool</code></span></li>
<li><span class="taxonomy-leaf">Community special school <code>epr:CommunitySpecialSchool</code></span></li>
<li><span class="taxonomy-leaf">Foundation school <code>epr:FoundationSchool</code></span></li>
<li><span class="taxonomy-leaf">Foundation special school <code>epr:FoundationSpecialSchool</code></span></li>
<li><span class="taxonomy-leaf">Maintained nursery school <code>epr:MaintainedNurserySchool</code></span></li>
<li><span class="taxonomy-leaf">Pupil referral unit <code>epr:PupilReferralUnit</code></span></li>
<li><span class="taxonomy-leaf">Voluntary aided school <code>epr:VoluntaryAidedSchool</code></span></li>
<li><span class="taxonomy-leaf">Voluntary controlled school <code>epr:VoluntaryControlledSchool</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Non-maintained special schools <code>epr:EstablishmentTypeGroupNonMaintainedSpecialSchools</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Non-maintained special school <code>epr:NonMaintainedSpecialSchool</code></span></li>
<li><span class="taxonomy-leaf">Other independent special school <code>epr:OtherIndependentSpecialSchool</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Online providers <code>epr:EstablishmentTypeGroupOnlineProviders</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Online provider <code>epr:OnlineProvider</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Other types <code>epr:EstablishmentTypeGroupOtherTypes</code></summary>
    <ul>
<li><span class="taxonomy-leaf">British schools overseas <code>epr:BritishSchoolsOverseas</code></span></li>
<li><span class="taxonomy-leaf">Institution funded by other government department <code>epr:InstitutionFundedByOtherGovernmentDepartment</code></span></li>
<li><span class="taxonomy-leaf">Miscellaneous <code>epr:MiscellaneousEstablishment</code></span></li>
<li><span class="taxonomy-leaf">Offshore schools <code>epr:OffshoreSchools</code></span></li>
<li><span class="taxonomy-leaf">Secure units <code>epr:SecureUnits</code></span></li>
<li><span class="taxonomy-leaf">Service children&#39;s education <code>epr:ServiceChildrensEducation</code></span></li>
<li><span class="taxonomy-leaf">Special post 16 institution <code>epr:SpecialPost16Institution</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Universities and higher education <code>epr:EstablishmentTypeGroupUniversities</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Higher education institution <code>epr:HigherEducationInstitution</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Welsh establishments <code>epr:EstablishmentTypeGroupWelshEstablishments</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Welsh establishment <code>epr:WelshEstablishment</code></span></li>
    </ul>
  </details>
</li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Gender of entry <code>epr:GenderOfEntry</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Boys <code>epr:BoysOnlyGenderEntry</code></span></li>
<li><span class="taxonomy-leaf">Girls <code>epr:GirlsOnlyGenderEntry</code></span></li>
<li><span class="taxonomy-leaf">Mixed <code>epr:MixedGenderEntry</code></span></li>
<li><span class="taxonomy-leaf">Not applicable (gender of entry) <code>epr:NotApplicableGenderOfEntry</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Governance appointing body <code>epr:GovernanceAppointingBody</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Any additional members appointed by the members of the academy trust <code>epr:AdditionalMembersAppointedByMembers</code></span></li>
<li><span class="taxonomy-leaf">Appointed by academy members <code>epr:AppointedByAcademyMembers</code></span></li>
<li><span class="taxonomy-leaf">Appointed by foundation/Trust <code>epr:AppointedByFoundationOrTrust</code></span></li>
<li><span class="taxonomy-leaf">Appointed by GB/board <code>epr:AppointedByGoverningBoard</code></span></li>
<li><span class="taxonomy-leaf">Appointed by LA <code>epr:AppointedByLa</code></span></li>
<li><span class="taxonomy-leaf">Appointed by trustees <code>epr:AppointedByTrustees</code></span></li>
<li><span class="taxonomy-leaf">Elected by parents <code>epr:ElectedByParents</code></span></li>
<li><span class="taxonomy-leaf">Elected by school staff <code>epr:ElectedBySchoolStaff</code></span></li>
<li><span class="taxonomy-leaf">Ex-officio by virtue of office as headteacher/principal <code>epr:ExOfficioHeadteacher</code></span></li>
<li><span class="taxonomy-leaf">Ex-officio foundation governor (appointed by foundation by virtue of the office they hold) <code>epr:ExOfficioFoundationGovernor</code></span></li>
<li><span class="taxonomy-leaf">Foundation/sponsor members <code>epr:FoundationOrSponsorMembers</code></span></li>
<li><span class="taxonomy-leaf">Interim Executive Board <code>epr:InterimExecutiveBoard</code></span></li>
<li><span class="taxonomy-leaf">N/A <code>epr:AppointingBodyNotApplicable</code></span></li>
<li><span class="taxonomy-leaf">Nominated by LA and appointed by GB <code>epr:NominatedByLaAppointedByGb</code></span></li>
<li><span class="taxonomy-leaf">Nominated by other body and appointed by GB <code>epr:NominatedByOtherBodyAppointedByGb</code></span></li>
<li><span class="taxonomy-leaf">Original (signatory) members <code>epr:OriginalSignatoryMembers</code></span></li>
<li><span class="taxonomy-leaf">Parent appointed by GB/board due to no election candidates <code>epr:ParentAppointedByGbDueToNoElection</code></span></li>
<li><span class="taxonomy-leaf">Persons who are appointed by the foundation body or sponsor (if applicable) <code>epr:PersonsAppointedByFoundationOrSponsor</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Governance role type <code>epr:GovernanceRoleType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Accounting officer <code>epr:AccountingOfficerRole</code></span></li>
<li><span class="taxonomy-leaf">Associate member <code>epr:AssociateMemberRole</code></span></li>
<li><span class="taxonomy-leaf">Chair of governors <code>epr:ChairOfGovernorsRole</code></span></li>
<li><span class="taxonomy-leaf">Chair of local governing body <code>epr:ChairOfLocalGoverningBodyRole</code></span></li>
<li><span class="taxonomy-leaf">Chair of trustees <code>epr:ChairOfTrusteesRole</code></span></li>
<li><span class="taxonomy-leaf">Chief financial officer <code>epr:ChiefFinancialOfficerRole</code></span></li>
<li><span class="taxonomy-leaf">Governance professional - federation <code>epr:GovernanceProfessionalFederationRole</code></span></li>
<li><span class="taxonomy-leaf">Governance professional - local authority maintained school <code>epr:GovernanceProfessionalLaMaintainedSchoolRole</code></span></li>
<li><span class="taxonomy-leaf">Governance professional - multi-academy trust (MAT) <code>epr:GovernanceProfessionalMatRole</code></span></li>
<li><span class="taxonomy-leaf">Governance professional - single-academy trust (SAT) <code>epr:GovernanceProfessionalSatRole</code></span></li>
<li><span class="taxonomy-leaf">Governor <code>epr:GovernorRole</code></span></li>
<li><span class="taxonomy-leaf">Headteacher (ex-officio governor) <code>epr:HeadteacherExOfficioGovernorRole</code></span></li>
<li><span class="taxonomy-leaf">Local governance professional - individual academy or free school <code>epr:LocalGovernanceProfessionalIndividualAcademyRole</code></span></li>
<li><span class="taxonomy-leaf">Local governor <code>epr:LocalGovernorRole</code></span></li>
<li><span class="taxonomy-leaf">Member <code>epr:MemberRole</code></span></li>
<li><span class="taxonomy-leaf">Shared chair of local governing body (establishment) <code>epr:SharedChairOfLocalGoverningBodyEstablishmentRole</code></span></li>
<li><span class="taxonomy-leaf">Shared chair of local governing body (group) <code>epr:SharedChairOfLocalGoverningBodyGroupRole</code></span></li>
<li><span class="taxonomy-leaf">Shared governance professional (establishment) <code>epr:SharedGovernanceProfessionalEstablishmentRole</code></span></li>
<li><span class="taxonomy-leaf">Shared governance professional (group) <code>epr:SharedGovernanceProfessionalGroupRole</code></span></li>
<li><span class="taxonomy-leaf">Shared local governor (establishment) <code>epr:SharedLocalGovernorEstablishmentRole</code></span></li>
<li><span class="taxonomy-leaf">Shared local governor (group) <code>epr:SharedLocalGovernorGroupRole</code></span></li>
<li><span class="taxonomy-leaf">Trustee <code>epr:TrusteeRole</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Group relationship type <code>epr:GroupRelationshipType</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Predecessor SAT <code>epr:PredecessorSingleAcademyTrust</code></span></li>
<li><span class="taxonomy-leaf">Successor MAT <code>epr:SuccessorMultiAcademyTrust</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Nursery provision <code>epr:NurseryProvision</code></summary>
    <ul>
<li><span class="taxonomy-leaf">No nursery classes <code>epr:NoNurseryClasses</code></span></li>
<li><span class="taxonomy-leaf">Not applicable (nursery provision) <code>epr:NotApplicableNurseryProvision</code></span></li>
<li><span class="taxonomy-leaf">Nursery classes <code>epr:HasNurseryClasses</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Religious character <code>epr:ReligiousCharacter</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Church of England <code>epr:ChurchOfEnglandCharacter</code></span></li>
<li><span class="taxonomy-leaf">Does not apply (religious character) <code>epr:NotApplicableReligiousCharacter</code></span></li>
<li><span class="taxonomy-leaf">Jewish <code>epr:JewishCharacter</code></span></li>
<li><span class="taxonomy-leaf">Muslim <code>epr:MuslimCharacter</code></span></li>
<li><span class="taxonomy-leaf">No religious character <code>epr:NoReligiousCharacter</code></span></li>
<li><span class="taxonomy-leaf">Other religious character <code>epr:OtherReligiousCharacter</code></span></li>
<li><span class="taxonomy-leaf">Roman Catholic <code>epr:RomanCatholicCharacter</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Religious ethos <code>epr:ReligiousEthos</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Christian <code>epr:ChristianEthos</code></span></li>
<li><span class="taxonomy-leaf">Does not apply (religious ethos) <code>epr:NotApplicableReligiousEthos</code></span></li>
<li><span class="taxonomy-leaf">No religious ethos <code>epr:NoReligiousEthos</code></span></li>
<li><span class="taxonomy-leaf">Other religious ethos <code>epr:OtherReligiousEthos</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Sixth-form provision <code>epr:SixthFormProvision</code></summary>
    <ul>
<li><span class="taxonomy-leaf">No sixth form <code>epr:NoSixthForm</code></span></li>
<li><span class="taxonomy-leaf">Not applicable (sixth-form provision) <code>epr:NotApplicableSixthFormProvision</code></span></li>
<li><span class="taxonomy-leaf">Sixth form <code>epr:HasSixthForm</code></span></li>
    </ul>
  </details>
</li>
<li>
  <details>
    <summary>Special-class provision <code>epr:SpecialClassProvision</code></summary>
    <ul>
<li><span class="taxonomy-leaf">Has special classes <code>epr:HasSpecialClasses</code></span></li>
<li><span class="taxonomy-leaf">No special classes <code>epr:NoSpecialClasses</code></span></li>
<li><span class="taxonomy-leaf">Not applicable (special-class provision) <code>epr:NotApplicableSpecialClassProvision</code></span></li>
    </ul>
  </details>
</li>
</ul>
</div>

## Facets

| Facet | Compact identifier | Vocabulary concept | Definition |
| --- | --- | --- | --- |
| Admissions policy | `epr:AdmissionsPolicy` |  | The classification describing how places are allocated. |
| Boarding provision | `epr:BoardingProvision` |  | The classification describing whether boarding places are offered. |
| Education phase | `epr:EducationPhase` |  | The broad stage of education provided by an establishment. |
| Establishment group type | `epr:EstablishmentGroupType` |  | The classification of an establishment group by its type, corresponding to EstablishmentGroupType codes in GIAS. |
| Establishment status | `epr:EstablishmentStatus` |  | The current lifecycle or operating-state classification of an establishment. |
| Establishment type | `epr:EstablishmentType` |  | The legal, operational or policy classification recorded as the establishment's type. |
| Gender of entry | `epr:GenderOfEntry` |  | The classification describing the establishment's gender admission arrangement. |
| Governance appointing body | `epr:GovernanceAppointingBody` |  | The body or mechanism responsible for making the governance appointment. 18 active values derived from the GIAS governance extract. RSC value retired. |
| Governance role type | `epr:GovernanceRoleType` |  | The classification of the governance role held. 22 values: 20 from the GIAS governance extract, plus headteacher ex-officio governor (SI 2012/1034) and associate member (SI 2013/1624). |
| Group relationship type | `epr:GroupRelationshipType` |  | The classification of a group-to-group relationship, distinguishing the role of each group in the relationship. |
| Nursery provision | `epr:NurseryProvision` |  | The classification describing whether the establishment offers nursery classes. |
| Religious character | `epr:ReligiousCharacter` |  | The formal religious-character classification designated for an establishment. |
| Religious ethos | `epr:ReligiousEthos` |  | The recorded religious-ethos classification associated with an establishment. |
| Sixth-form provision | `epr:SixthFormProvision` |  | The classification describing whether the establishment has a sixth form. |
| Special-class provision | `epr:SpecialClassProvision` |  | The classification describing whether the establishment has special classes. |

## Taxons

| Taxon | Compact identifier | Vocabulary concept | Broader concept | Status |
| --- | --- | --- | --- | --- |
| 16 to 19 | `epr:SixteenToNineteenPhase` |  | Education phase | Provisional |
| Academies | `epr:EstablishmentTypeGroupAcademies` |  | Establishment type | Provisional |
| Academy 16 to 19 | `epr:Academy1619` |  | Academies | Preferred |
| Academy alternative provision | `epr:AcademyAlternativeProvision` |  | Academies | Preferred |
| Academy secure 16 to 19 | `epr:AcademySecure16To19` |  | Academies | Provisional |
| Academy special school | `epr:AcademySpecial` |  | Academies | Preferred |
| Accounting officer | `epr:AccountingOfficerRole` |  | Governance role type | Provisional |
| All-through | `epr:AllThroughPhase` |  | Education phase | Provisional |
| Any additional members appointed by the members of the academy trust | `epr:AdditionalMembersAppointedByMembers` |  | Governance appointing body | Provisional |
| Appointed by academy members | `epr:AppointedByAcademyMembers` |  | Governance appointing body | Provisional |
| Appointed by foundation/Trust | `epr:AppointedByFoundationOrTrust` |  | Governance appointing body | Provisional |
| Appointed by GB/board | `epr:AppointedByGoverningBoard` |  | Governance appointing body | Provisional |
| Appointed by LA | `epr:AppointedByLa` |  | Governance appointing body | Provisional |
| Appointed by trustees | `epr:AppointedByTrustees` |  | Governance appointing body | Provisional |
| Associate member | `epr:AssociateMemberRole` |  | Governance role type | Provisional |
| Boarding school | `epr:BoardingSchool` |  | Boarding provision | Provisional |
| Boys | `epr:BoysOnlyGenderEntry` |  | Gender of entry | Provisional |
| British schools overseas | `epr:BritishSchoolsOverseas` |  | Other types | Provisional |
| Chair of governors | `epr:ChairOfGovernorsRole` |  | Governance role type | Provisional |
| Chair of local governing body | `epr:ChairOfLocalGoverningBodyRole` |  | Governance role type | Provisional |
| Chair of trustees | `epr:ChairOfTrusteesRole` |  | Governance role type | Provisional |
| Chief financial officer | `epr:ChiefFinancialOfficerRole` |  | Governance role type | Provisional |
| Children's centre | `epr:ChildrensCentre` |  | Children's centres | Provisional |
| Children's centre linked site | `epr:ChildrensCentreLinkedSite` |  |  | Legacy |
| Children's centres | `epr:EstablishmentTypeGroupChildrensCentres` |  | Establishment type | Provisional |
| Children's centres collaboration | `epr:ChildrensCentreCollaboration` |  | Establishment group type | Provisional |
| Children's centres group | `epr:ChildrensCentreGroup` |  | Establishment group type | Provisional |
| Christian | `epr:ChristianEthos` |  | Religious ethos | Provisional |
| Church of England | `epr:ChurchOfEnglandCharacter` |  | Religious character | Provisional |
| City technology college | `epr:CityTechnologyCollege` |  | Independent schools | Provisional |
| Closed | `epr:ClosedStatus` |  | Establishment status | Provisional |
| Colleges | `epr:EstablishmentTypeGroupColleges` |  | Establishment type | Provisional |
| Community school | `epr:CommunitySchool` |  | Local authority maintained schools | Provisional |
| Community special school | `epr:CommunitySpecialSchool` |  | Local authority maintained schools | Provisional |
| Does not apply (religious character) | `epr:NotApplicableReligiousCharacter` |  | Religious character | Provisional |
| Does not apply (religious ethos) | `epr:NotApplicableReligiousEthos` |  | Religious ethos | Provisional |
| Elected by parents | `epr:ElectedByParents` |  | Governance appointing body | Provisional |
| Elected by school staff | `epr:ElectedBySchoolStaff` |  | Governance appointing body | Provisional |
| establishmentDetailsTaxonomy | `epr:establishmentDetailsTaxonomy` |  |  | Provisional |
| Ex-officio by virtue of office as headteacher/principal | `epr:ExOfficioHeadteacher` |  | Governance appointing body | Provisional |
| Ex-officio foundation governor (appointed by foundation by virtue of the office they hold) | `epr:ExOfficioFoundationGovernor` |  | Governance appointing body | Provisional |
| Federation | `epr:Federation` |  | Establishment group type | Provisional |
| Foundation school | `epr:FoundationSchool` |  | Local authority maintained schools | Provisional |
| Foundation special school | `epr:FoundationSpecialSchool` |  | Local authority maintained schools | Provisional |
| Foundation/sponsor members | `epr:FoundationOrSponsorMembers` |  | Governance appointing body | Provisional |
| Free schools | `epr:FreeSchool` |  | Free schools (type group) | Provisional |
| Free schools (type group) | `epr:EstablishmentTypeGroupFreeSchools` |  | Establishment type | Provisional |
| Free schools 16 to 19 | `epr:FreeSchool16To19` |  | Free schools (type group) | Provisional |
| Free schools alternative provision | `epr:FreeSchoolAlternativeProvision` |  | Free schools (type group) | Provisional |
| Free schools special | `epr:FreeSchoolSpecial` |  | Free schools (type group) | Provisional |
| Further education | `epr:FurtherEducation` |  | Colleges | Provisional |
| Girls | `epr:GirlsOnlyGenderEntry` |  | Gender of entry | Provisional |
| Governance professional - federation | `epr:GovernanceProfessionalFederationRole` |  | Governance role type | Provisional |
| Governance professional - local authority maintained school | `epr:GovernanceProfessionalLaMaintainedSchoolRole` |  | Governance role type | Provisional |
| Governance professional - multi-academy trust (MAT) | `epr:GovernanceProfessionalMatRole` |  | Governance role type | Provisional |
| Governance professional - single-academy trust (SAT) | `epr:GovernanceProfessionalSatRole` |  | Governance role type | Provisional |
| Governor | `epr:GovernorRole` |  | Governance role type | Provisional |
| Has boarders | `epr:HasBoarders` |  | Boarding provision | Provisional |
| Has special classes | `epr:HasSpecialClasses` |  | Special-class provision | Provisional |
| Headteacher (ex-officio governor) | `epr:HeadteacherExOfficioGovernorRole` |  | Governance role type | Provisional |
| Higher education institution | `epr:HigherEducationInstitution` |  | Universities and higher education | Provisional |
| Independent schools | `epr:EstablishmentTypeGroupIndependentSchools` |  | Establishment type | Provisional |
| Institution funded by other government department | `epr:InstitutionFundedByOtherGovernmentDepartment` |  | Other types | Provisional |
| Interim Executive Board | `epr:InterimExecutiveBoard` |  | Governance appointing body | Provisional |
| Jewish | `epr:JewishCharacter` |  | Religious character | Provisional |
| Local authority maintained schools | `epr:EstablishmentTypeGroupLaMaintainedSchools` |  | Establishment type | Provisional |
| Local governance professional - individual academy or free school | `epr:LocalGovernanceProfessionalIndividualAcademyRole` |  | Governance role type | Provisional |
| Local governor | `epr:LocalGovernorRole` |  | Governance role type | Provisional |
| Mainstream academy | `epr:MainstreamAcademy` |  | Academies | Preferred |
| Maintained nursery school | `epr:MaintainedNurserySchool` |  | Local authority maintained schools | Provisional |
| Member | `epr:MemberRole` |  | Governance role type | Provisional |
| Middle deemed primary | `epr:MiddlePhase` |  | Education phase | Provisional |
| Middle deemed secondary | `epr:MiddleDeemedSecondaryPhase` |  | Education phase | Provisional |
| Miscellaneous | `epr:MiscellaneousEstablishment` |  | Other types | Provisional |
| Mixed | `epr:MixedGenderEntry` |  | Gender of entry | Provisional |
| Multi-academy trust | `epr:MultiAcademyTrust` |  | Establishment group type | Provisional |
| Muslim | `epr:MuslimCharacter` |  | Religious character | Provisional |
| N/A | `epr:AppointingBodyNotApplicable` |  | Governance appointing body | Provisional |
| No boarders | `epr:NoBoarders` |  | Boarding provision | Provisional |
| No nursery classes | `epr:NoNurseryClasses` |  | Nursery provision | Provisional |
| No religious character | `epr:NoReligiousCharacter` |  | Religious character | Provisional |
| No religious ethos | `epr:NoReligiousEthos` |  | Religious ethos | Provisional |
| No sixth form | `epr:NoSixthForm` |  | Sixth-form provision | Provisional |
| No special classes | `epr:NoSpecialClasses` |  | Special-class provision | Provisional |
| Nominated by LA and appointed by GB | `epr:NominatedByLaAppointedByGb` |  | Governance appointing body | Provisional |
| Nominated by other body and appointed by GB | `epr:NominatedByOtherBodyAppointedByGb` |  | Governance appointing body | Provisional |
| Non-maintained special school | `epr:NonMaintainedSpecialSchool` |  | Non-maintained special schools | Provisional |
| Non-maintained special schools | `epr:EstablishmentTypeGroupNonMaintainedSpecialSchools` |  | Establishment type | Provisional |
| Non-selective | `epr:NonSelectiveAdmissions` |  | Admissions policy | Provisional |
| Not applicable (admissions policy) | `epr:NotApplicableAdmissionsPolicy` |  | Admissions policy | Provisional |
| Not applicable (education phase) | `epr:NotApplicableEducationPhase` |  | Education phase | Provisional |
| Not applicable (gender of entry) | `epr:NotApplicableGenderOfEntry` |  | Gender of entry | Provisional |
| Not applicable (nursery provision) | `epr:NotApplicableNurseryProvision` |  | Nursery provision | Provisional |
| Not applicable (sixth-form provision) | `epr:NotApplicableSixthFormProvision` |  | Sixth-form provision | Provisional |
| Not applicable (special-class provision) | `epr:NotApplicableSpecialClassProvision` |  | Special-class provision | Provisional |
| Nursery | `epr:NurseryPhase` |  | Education phase | Provisional |
| Nursery classes | `epr:HasNurseryClasses` |  | Nursery provision | Provisional |
| Offshore schools | `epr:OffshoreSchools` |  | Other types | Provisional |
| Online provider | `epr:OnlineProvider` |  | Online providers | Provisional |
| Online providers | `epr:EstablishmentTypeGroupOnlineProviders` |  | Establishment type | Provisional |
| Open | `epr:OpenStatus` |  | Establishment status | Provisional |
| Open, but proposed to close | `epr:OpenProposedToCloseStatus` |  | Establishment status | Provisional |
| Original (signatory) members | `epr:OriginalSignatoryMembers` |  | Governance appointing body | Provisional |
| Other independent school | `epr:OtherIndependentSchool` |  | Independent schools | Provisional |
| Other independent special school | `epr:OtherIndependentSpecialSchool` |  | Non-maintained special schools | Provisional |
| Other religious character | `epr:OtherReligiousCharacter` |  | Religious character | Provisional |
| Other religious ethos | `epr:OtherReligiousEthos` |  | Religious ethos | Provisional |
| Other types | `epr:EstablishmentTypeGroupOtherTypes` |  | Establishment type | Provisional |
| Parent appointed by GB/board due to no election candidates | `epr:ParentAppointedByGbDueToNoElection` |  | Governance appointing body | Provisional |
| Persons who are appointed by the foundation body or sponsor (if applicable) | `epr:PersonsAppointedByFoundationOrSponsor` |  | Governance appointing body | Provisional |
| Predecessor SAT | `epr:PredecessorSingleAcademyTrust` |  | Group relationship type | Provisional |
| Primary | `epr:PrimaryPhase` |  | Education phase | Provisional |
| Proposed to open | `epr:ProposedToOpenStatus` |  | Establishment status | Provisional |
| Pupil referral unit | `epr:PupilReferralUnit` |  | Local authority maintained schools | Provisional |
| Roman Catholic | `epr:RomanCatholicCharacter` |  | Religious character | Provisional |
| School sponsor | `epr:SchoolSponsor` |  |  | Legacy |
| Secondary | `epr:SecondaryPhase` |  | Education phase | Provisional |
| Secure single-academy trust | `epr:SecureSingleAcademyTrust` |  | Establishment group type | Provisional |
| Secure units | `epr:SecureUnits` |  | Other types | Provisional |
| Selective | `epr:SelectiveAdmissions` |  | Admissions policy | Provisional |
| Service children's education | `epr:ServiceChildrensEducation` |  | Other types | Provisional |
| Shared chair of local governing body (establishment) | `epr:SharedChairOfLocalGoverningBodyEstablishmentRole` |  | Governance role type | Provisional |
| Shared chair of local governing body (group) | `epr:SharedChairOfLocalGoverningBodyGroupRole` |  | Governance role type | Provisional |
| Shared governance professional (establishment) | `epr:SharedGovernanceProfessionalEstablishmentRole` |  | Governance role type | Provisional |
| Shared governance professional (group) | `epr:SharedGovernanceProfessionalGroupRole` |  | Governance role type | Provisional |
| Shared local governor (establishment) | `epr:SharedLocalGovernorEstablishmentRole` |  | Governance role type | Provisional |
| Shared local governor (group) | `epr:SharedLocalGovernorGroupRole` |  | Governance role type | Provisional |
| Single-academy trust | `epr:SingleAcademyTrust` |  | Establishment group type | Provisional |
| Sixth form | `epr:HasSixthForm` |  | Sixth-form provision | Provisional |
| Sixth form centre | `epr:SixthFormCentre` |  | Colleges | Provisional |
| Special post 16 institution | `epr:SpecialPost16Institution` |  | Other types | Provisional |
| Studio schools | `epr:StudioSchool` |  | Free schools (type group) | Provisional |
| Successor MAT | `epr:SuccessorMultiAcademyTrust` |  | Group relationship type | Provisional |
| Trust | `epr:GenericTrust` |  | Establishment group type | Provisional |
| Trustee | `epr:TrusteeRole` |  | Governance role type | Provisional |
| Universities and higher education | `epr:EstablishmentTypeGroupUniversities` |  | Establishment type | Provisional |
| University technical college | `epr:UniversityTechnicalCollege` |  | Free schools (type group) | Provisional |
| Voluntary aided school | `epr:VoluntaryAidedSchool` |  | Local authority maintained schools | Provisional |
| Voluntary controlled school | `epr:VoluntaryControlledSchool` |  | Local authority maintained schools | Provisional |
| Welsh establishment | `epr:WelshEstablishment` |  | Welsh establishments | Provisional |
| Welsh establishments | `epr:EstablishmentTypeGroupWelshEstablishments` |  | Establishment type | Provisional |
