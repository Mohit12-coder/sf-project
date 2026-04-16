public class EmailService {
    public static void sendEventMail(String toEmail, Id eventId, String subjectText) {
        if (String.isBlank(toEmail) || eventId == null) {
            return;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { toEmail });
        mail.setSubject('Salesforce Event Created: ' + subjectText);

        String eventLink = URL.getOrgDomainUrl().toExternalForm()
            + '/lightning/r/Event/' + String.valueOf(eventId) + '/view';

        mail.setPlainTextBody(
            'Hello,\n\n' +
            'Your Salesforce event has been created successfully.\n\n' +
            'Event Link: ' + eventLink + '\n\n' +
            'Regards,\nSalesforce'
        );

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}