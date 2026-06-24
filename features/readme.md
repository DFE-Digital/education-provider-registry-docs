# Feature Files

This folder contains agreed behaviour for the Education Provider Registry.

The `.feature` files are the source of truth for behaviour that the team has chosen to describe using Gherkin.

Use one feature file per agreed feature. Add scenarios inside that file to describe the important examples and rules for the feature.

Jira is used to schedule and track development work. It should reference the agreed feature file when a delivery item implements all or part of the behaviour, but Jira is not the source of truth for the behaviour itself.

## How We Use Feature Files

Feature files help product, delivery, QA and engineering agree what the service should do before it is implemented.

They should describe observable behaviour in business language:

- `Given` describes the relevant context.
- `When` describes the action.
- `Then` describes the expected outcome.

They should avoid implementation details such as selectors, URLs, database tables, API response paths or test framework wording unless those details are the behaviour being agreed.

## Workflow

1. Create or update a feature file on a branch.
2. Review and refine the behaviour with the relevant people.
3. Open a pull request.
4. Merge the pull request to the default branch when the behaviour is agreed.
5. Use Jira to schedule and track development work against the agreed behaviour.
6. Developers implement the agreed behaviour.
7. If agreed behaviour changes later, update the feature file through another pull request.

GitHub provides the change history, review trail and persistent link for the agreed behaviour.

## Naming

Use a slugged file name:

```text
search-establishment-by-establishment-name.feature
```

Use a stable behaviour name rather than a Jira ticket number in the file name.

This keeps links readable and allows the flat folder to group naturally by the first word, such as:

- `search-...`
- `view-...`
- `change-...`
- `download-...`

## Scenario Tags

Use scenario-level tags when a scenario needs a stable identifier.

Prefer readable tags that describe the behaviour:

```gherkin
@search-name-lowercase
Scenario: Lower-case search returns establishments containing the search term
```

Do not number scenarios in the title. Numbers become fragile when scenarios are added, removed or reordered.

Stable scenario tags can be used by test tooling, reports, pull requests or Jira delivery items when they need to reference one specific scenario.

## Trial Status

This approach is being trialled before adoption. Keep the first feature files small, readable and easy to review.
