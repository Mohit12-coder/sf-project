public class TriggerAsignTwentySeven {

    public static void sendAccountCreationEmail(List <Account> newAccounts){
        
        User adminUser = [SELECT Id, Email FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Account acc : newAccounts){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(new String[]{adminUser.Email});
            mail.setSubject('New Account Created');
            
            mail.setPlainTextBody('An account has been created and the name is "' + acc.Name + '"');
            
            emails.add(mail);
            
        }
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
        
    }
    
}