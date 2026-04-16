public class SFIntegrationController {

    @future(callout=true)
    public static void getDetails(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SalesforceConnectedAppNamedCredential/services/apexrest/Account');
        req.setHeader('content-type','application/json;charset=UTF-8');
        req.setHeader('Accept','application/json');
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Response Code : ' + res.getStatusCode());
        System.debug('Response Body : ' + res.getBody());
    } 
    
}