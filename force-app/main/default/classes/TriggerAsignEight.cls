public class TriggerAsignEight {

    public static void updateContactPhones(List<Account> newAccounts, Map<Id,Account> oldMap){
        
        Set<Id> accountIds = new Set<Id >();
        
        try{
            
            for(Account acc : newAccounts){
                
                if(acc.Phone != oldMap.get(acc.Id).Phone){
                    accountIds.add(acc.Id);
                }
                
            }
            
            if(accountIds.isEmpty())
                return;
            
            List<Contact> contactsToUpdate = [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN :accountIds];
            
            Map<Id,Account> accountMap = new Map<Id, Account>(newAccounts);
            
            for(Contact con : contactsToUpdate){
                con.Phone = accountMap.get(con.AccountId).Phone;
            }
            
            if(!contactsToUpdate.isEmpty()){
                update contactsToUpdate;
            }
            
        }
        catch(Exception e){
            system.debug('DML Error : ' + e.getMessage());
        }
    }
    
}