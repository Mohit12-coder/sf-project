public class TriggerAsignThirtySix {

    public static void sendContactEmail(List<Contact> newContacts){
        
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Contact_Welcome_Template' LIMIT 1];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : newContacts){
            if(con.Email != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setTargetObjectId(con.id);
                mail.setTemplateId(template.Id);
                mail.setSaveAsActivity(false);
                emails.add(mail);
            }
        }
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
        
    }
    
}