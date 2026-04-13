public class FutureDemoOne {
    @future(callout=true)
    public static void sendSMS(String leadId) {

        
        Lead l = [SELECT Id, Name, Phone FROM Lead WHERE Id = :leadId];

      
        Http http = new Http();

        
        HttpRequest req = new HttpRequest();

        
        req.setEndpoint('https://api.smsprovider.com/send');

        req.setMethod('POST');

        
        req.setHeader('Content-Type', 'application/json');

        
        String body = '{"phone":"' + l.Phone + '","message":"Welcome ' + l.Name + '"}';

       
        req.setBody(body);

       
        HttpResponse res = http.send(req);

        
        System.debug(res.getBody());
    }
}