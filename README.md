# Opportunity Desk (Salesforce Developer Project)

A small project that uses only standard objects, so it deploys to any free Developer Org.

## What it covers
| Skill | Where |
|---|---|
| Apex trigger + handler pattern (before/after, bulk-safe) | `OpportunityTrigger`, `OpportunityTriggerHandler` |
| Validation with `addError`, Task creation on stage change | `OpportunityTriggerHandler` |
| SOQL, `WITH USER_MODE`, aggregate query | `OpportunityController` |
| REST callout, Remote Site Setting, JSON parsing | `CurrencyService` |
| Test classes, bulk tests, `HttpCalloutMock` | `*Test` classes |
| LWC: `@wire`, imperative Apex, debounce, datatable | `openOpportunities` |

## Deploy
```bash
# 1. Install Salesforce CLI, then log in to your Developer Org
sf org login web --alias mydevorg

# 2. Deploy
sf project deploy start --source-dir force-app --target-org mydevorg

# 3. Run tests
sf apex run test --test-level RunLocalTests --target-org mydevorg --result-format human --wait 10
```

## Use it
1. In the org: Setup > Lightning App Builder > edit the Home page > drag the **Open Opportunities** component on > Save and Activate.
2. Create a few Opportunities. Try moving one to **Closed Won** with no Amount (blocked), then with an Amount (a follow-up Task is created).
3. Click **Show pipeline total in INR** on the component (needs internet access from the org).

## Ideas to extend it
- Add a custom metadata type for the default follow-up task subject.
- Move the callout to a Named Credential.
- Add a Scheduled Apex job that flags opportunities with no activity for 14 days.
