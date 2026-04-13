public class TriggerAsignSix {
    
    public static void sendDeleteEmail(List<Account> oldAccounts){
        
        try{
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            String userEmail = UserInfo.getUserEmail();
            
            for(Account acc : oldAccounts){
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(new String[]{userEmail});
                mail.setSubject('Account Deleted Confirmation');
                
                mail.setPlainTextBody(' The Account " ' + acc.Name + ' " has been deleted successfully.');
                
                emails.add(mail);
                
            }
            
            if(!emails.isEmpty()){
                Messaging.sendEmail(emails);
            }
            
        }
        catch(EmailException e){
            System.debug('Email Error : ' + e.getMessage());
        }
        
    }
    
}