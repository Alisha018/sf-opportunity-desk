@IsTest
public class CurrencyServiceTest {

    // Reusable mock: other test classes can use CurrencyServiceTest.MockRates too
    public class MockRates implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"result":"success","rates":{"INR":80.5,"USD":1}}');
            return res;
        }
    }

    @IsTest
    static void convertsAmountUsingMockedRate() {
        Test.setMock(HttpCalloutMock.class, new MockRates());
        Test.startTest();
        Decimal result = CurrencyService.convert(100, 'USD', 'INR');
        Test.stopTest();
        System.assertEquals(8050.0, result);
    }
}
