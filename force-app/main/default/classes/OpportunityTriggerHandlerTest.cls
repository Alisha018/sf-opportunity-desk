@IsTest
private class OpportunityTriggerHandlerTest {

    private static Opportunity makeOpp(String name, Decimal amount) {
        Account acc = new Account(Name = name + ' Account');
        insert acc;
        Opportunity opp = new Opportunity(
            Name = name,
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = amount
        );
        insert opp;
        return opp;
    }

    @IsTest
    static void closedWonCreatesFollowUpTask() {
        Opportunity opp = makeOpp('Deal A', 5000);
        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id];
        System.assertEquals(1, tasks.size(), 'One follow-up task should be created');
    }

    @IsTest
    static void closedWonWithoutAmountIsBlocked() {
        Opportunity opp = makeOpp('Deal B', null);
        opp.StageName = 'Closed Won';
        Database.SaveResult result = Database.update(opp, false);

        System.assert(!result.isSuccess(), 'Update should fail without an Amount');
        System.assert(result.getErrors()[0].getMessage().contains('Amount is required'));
    }

    @IsTest
    static void bulkUpdateCreatesTaskPerOpportunity() {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 20; i++) {
            opps.add(makeOpp('Bulk ' + i, 1000 + i));
        }
        for (Opportunity o : opps) {
            o.StageName = 'Closed Won';
        }
        Test.startTest();
        update opps;
        Test.stopTest();

        System.assertEquals(20, [SELECT COUNT() FROM Task WHERE WhatId IN :opps]);
    }
}
