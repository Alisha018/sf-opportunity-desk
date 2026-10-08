public with sharing class OpportunityController {

    // Used by the LWC with @wire (cacheable, read-only)
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpenOpportunities(String searchKey) {
        String key = '%' + (searchKey == null ? '' : searchKey) + '%';
        return [
            SELECT Id, Name, StageName, Amount, CloseDate
            FROM Opportunity
            WHERE IsClosed = false AND Name LIKE :key
            WITH USER_MODE
            ORDER BY CloseDate ASC
            LIMIT 50
        ];
    }

    // Not cacheable because it makes a callout. Assumes opportunity amounts are in USD.
    @AuraEnabled
    public static Decimal getPipelineTotalInr() {
        AggregateResult[] results = [
            SELECT SUM(Amount) total FROM Opportunity WHERE IsClosed = false WITH USER_MODE
        ];
        Decimal total = (Decimal) results[0].get('total');
        return CurrencyService.convert(total, 'USD', 'INR');
    }
}
