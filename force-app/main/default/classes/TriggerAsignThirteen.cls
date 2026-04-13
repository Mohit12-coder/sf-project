public class TriggerAsignThirteen {

    public static void updateContactCount(List<Contact> newList, List<Contact> oldList){
        
        Set<Id> accountIds = new Set<Id>();
        
        if(newList != null){
            for(Contact c : newList){
                if(c.AccountId != null){
                    accountIds.add(c.AccountId);
                }
            }
        }
        
        if(oldList != null){
            for(Contact c : oldList){
                if(c.AccountId != null){
                    accountIds.add(c.AccountId);
                }
            }
        }
        
        if(accountIds.isEmpty()){
            return;
        }
        
        Map<Id,Integer> countMap = new Map<Id, Integer>();
        
        for(AggregateResult ar : [SELECT AccountId acccId, COUNT(Id) total FROM Contact WHERE AccountId IN : accountIds GROUP BY AccountId]){
            countMap.put((Id)ar.get('accId'), (Integer)ar.get('total'));
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Id accId : accountIds){
            Account acc = new Account();
            acc.Id = accId;
            acc.Contact_Count__c = countMap.containsKey(accId) ? countMap.get(accId) : 0;
            
            accountsToUpdate.add(acc);
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
        
    }
    
}