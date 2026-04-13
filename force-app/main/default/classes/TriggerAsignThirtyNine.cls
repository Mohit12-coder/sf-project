public class TriggerAsignThirtyNine {

    public static void sendEmailToRelatedContacts(List<Account> newAccounts, Map<Id,Account> oldMap){
        Set<Id> accountIds = new Set<Id>();
        
        for(Account acc : newAccounts){
            Account oldAcc = oldMap.get(acc.Id);
            
            if(acc.Type != oldAcc.Type){
                accountIds.add(acc.Id );
            }
        }
        
        if(accountIds.isEmpty()){
            return;
        }
        
        List<Contact> contacts = [SELECT Id, Email, AccountId FROM Contact WHERE AccountId IN : accountIds AND Email != null];
        
        Map<Id,Account> accMap = new Map<Id,Account>(newAccounts);
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : contacts){
            Account acc = accMap.get(con.AccountId);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(new String[]{con.Email});
            mail.setSubject('Account Update Info');
            
            mail.setPlaintextBody(
                'Your account info has been updated successfully.\n' + 
                'Account Name : ' + acc.Name
            );
            emails.add(mail);
        }
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
    }
    
}