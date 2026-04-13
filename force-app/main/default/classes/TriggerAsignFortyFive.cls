public class TriggerAsignFortyFive {

    public static void handleInactiveAccounts(List<Account> newList, Map<Id,Account> oldMap){
        Set<Id> accountIds = new Set<Id> ();
        
        for(Account acc : newList){
            Account oldAcc = oldMap.get(acc.Id);
            
            if(acc.Status__c == 'Inactive' && oldAcc.Status__c == 'Active'){
                accountIds.add(acc.Id);
            }
        }
        
        if(accountIds.isEmpty()){
            return;
        }
        
        List<Opportunity> oppsToDelete = [SELECT Id FROM Opportunity WHERE AccountId IN : accountIds];
        
        if(!oppsToDelete.isEmpty()){
            delete oppsToDelete;
        }
        
        List<Contact> contactsToUpdate = [SELECT Id, Do_Not_Contact__c FROM Contact WHERE AccountId IN : accountIds];
        
        for(Contact con : contactsToUpdate){
            con.Do_Not_Contact__c = true;
        }
        
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }
    
}