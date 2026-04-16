public class CurrencyConverterClass {

    public static Decimal convertCurrencyToINR(Decimal eur){
        
        Decimal inr = 0.0;
        
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        
        req.setEndpoint('https://api.exchangeratesapi.io/latest');
        req.setMethod('GET');
        
        HTTPResponse res = h.send(req);
        
        Map<String,Object> jsonBody = (Map<String,Object>)Json.deserializeUntyped(res.getBody());
        
        System.debug(jsonBody);
        
        return 0.0;
        
    }
    
}