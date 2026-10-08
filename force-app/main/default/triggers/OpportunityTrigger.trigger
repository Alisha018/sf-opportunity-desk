trigger OpportunityTrigger on Opportunity (before update, after update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHandler.validateClosedWon(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.createFollowUpTasks(Trigger.new, Trigger.oldMap);
    }
}
