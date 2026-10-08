@IsTest
private class OpportunityControllerTest {

    @TestSetup
    static void setup() {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 3; i++) {
            opps.add(new Opportunity(
                Name = 'Test Deal ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(10 + i),
                Amount = 1000
            ));
        }
        insert opps;
    }

    @IsTest
    static void searchReturnsMatchingOpenOpportunities() {
        List<Opportunity> results = OpportunityController.getOpenOpportunities('Test Deal');
        System.assertEquals(3, results.size());
        System.assertEquals(0, OpportunityController.getOpenOpportunities('No Match').size());
    }

    @IsTest
    static void pipelineTotalIsConvertedToInr() {
        Test.setMock(HttpCalloutMock.class, new CurrencyServiceTest.MockRates());
        Test.startTest();
        Decimal totalInr = OpportunityController.getPipelineTotalInr();
        Test.stopTest();
        System.assertEquals(3000 * 80.5, totalInr);
    }
}
