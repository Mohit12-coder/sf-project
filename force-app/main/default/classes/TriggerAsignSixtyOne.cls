public class TriggerAsignSixtyOne {
    
    public static void createDefaultContact(List<Account> accList){
        
        List<Contact> contactsToInsert = new List<Contact>();
        List<Account> accToUpdate = new List<Account>();
        
        for(Account acc : accList){
            
            contactsToInsert.add( new Contact( FirstName = 'Info', LastName = 'Default', Email = 'info@websitedomain.tld', AccountId = acc.Id));
            
            accToUpdate.add(new Account( Id=acc.Id, Only_Default_Contact__c = true));
            
        }
        
        if(!contactsToInsert.isEmpty()){
            insert contactsToInsert;
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
        
        
        
    }
    
    public static void updateAccountFlag(List<Contact> newList, List<Contact> oldList){
        
        Set<Id> accIds = new Set<Id>();
        
        if(newList != null){
            for(Contact c : newList){
                if(c.AccountId != null){
                    accIds.add(c.AccountId);
                }
            }
        }
        
        if(oldList != null){
            for(Contact c : oldList){
                if(c.AccountId != null){
                    accIds.add(c.AccountId);
                }
            }
        }
        
        if(accIds.isEmpty()){
            return;
        }
        
        Map<Id, Integer> countMap = new Map<Id, Integer>();
        
        for(AggregateResult ar : [SELECT AccountId accId, COUNT(Id) cnt FROM Contact WHERE AccountId IN : accIds GROUP BY AccountId]){
            countMap.put((Id)ar.get('accId'), (Integer)ar.get('cnt'));
        }
        
        List<Account> accToUpdate = new List<Account>();
        
        for( Id accID : accIds){
            Integer count = countMap.containsKey(accId) ? countMap.get(accId) : 0;
            
            Boolean flag = (count == 1);
            
            accToUpdate.add(new Account( Id=accId, Only_Default_Contact__c = flag));
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
        
    }
    
}