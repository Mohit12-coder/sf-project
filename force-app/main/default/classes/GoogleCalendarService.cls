public with sharing class GoogleCalendarService {
 
    public static String createEvent(Event e, Contact c) {
        Map<String, Object> googleEvent = new Map<String, Object>{
            'summary'     => e.Subject,
            'description' => e.Description,
            'start'       => new Map<String, Object>{
                'dateTime' => e.StartDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss'),
                'timeZone' => 'Asia/Kolkata'
            },
            'end'         => new Map<String, Object>{
                'dateTime' => e.EndDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss'),
                'timeZone' => 'Asia/Kolkata'
            }
        };
 
        if (c != null && String.isNotBlank(c.Email)) {
            googleEvent.put('attendees', new List<Object>{new Map<String, Object>{'email' => c.Email, 'displayName' => c.Name }});
        }
 
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:GoogleCalendarDemoNamedCredential/calendar/v3/calendars/primary/events');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(googleEvent));
        req.setTimeout(120000);
 
        Http http = new Http();
        HttpResponse res = http.send(req);
 
        if (res.getStatusCode() != 200 && res.getStatusCode() != 201) {
            throw new CalloutException(
                'Google Calendar insert failed. Status: ' + res.getStatus() + ' Body: ' + res.getBody()
            );
        }
 
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        return (String) responseMap.get('id');
    }
 
    public static void sendSalesforceMail(String toEmail, Event e ) {
        String eventLink = URL.getOrgDomainUrl().toExternalForm() + '/lightning/r/Event/' + e.Id + '/view';
 
        String bodyText =
            'Hello,\n\n' +
            'Your event has been created successfully.\n\n' +
            'Event Subject: ' + e.Subject + '\n' +
            'Salesforce Event Link: ' + eventLink + '\n\n' +'Regards,\n' +
            'Salesforce';
 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{ toEmail });
        mail.setSubject('Event Created Successfully');
        mail.setPlainTextBody(bodyText);
 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}