public with sharing class CurrencyService {

    // Calls a free public exchange-rate API and returns the rate from -> to
    public static Decimal getRate(String fromCurrency, String toCurrency) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://open.er-api.com/v6/latest/' + fromCurrency);
        req.setMethod('GET');
        req.setTimeout(10000);

        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() != 200) {
            throw new CalloutException('Exchange rate service returned status ' + res.getStatusCode());
        }

        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Map<String, Object> rates = (Map<String, Object>) body.get('rates');
        return Decimal.valueOf(String.valueOf(rates.get(toCurrency)));
    }

    public static Decimal convert(Decimal amount, String fromCurrency, String toCurrency) {
        Decimal safeAmount = (amount == null) ? 0 : amount;
        return safeAmount * getRate(fromCurrency, toCurrency);
    }
}
