public with sharing class OpportunityTriggerHandler {

    // BEFORE UPDATE: block "Closed Won" when Amount is missing or zero
    public static void validateClosedWon(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            Boolean becameClosedWon = opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won';
            if (becameClosedWon && (opp.Amount == null || opp.Amount <= 0)) {
                opp.addError('Amount is required before an Opportunity can be Closed Won.');
            }
        }
    }

    // AFTER UPDATE: create one follow-up Task per newly Closed Won Opportunity (bulk-safe)
    public static void createFollowUpTasks(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        List<Task> tasks = new List<Task>();
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                tasks.add(new Task(
                    Subject = 'Send onboarding email to customer',
                    WhatId = opp.Id,
                    OwnerId = opp.OwnerId,
                    ActivityDate = Date.today().addDays(3),
                    Priority = 'High',
                    Status = 'Not Started'
                ));
            }
        }
        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }
}
