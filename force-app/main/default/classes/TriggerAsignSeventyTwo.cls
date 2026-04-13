public class TriggerAsignSeventyTwo {

    public static void updateNeedIntel(List<Contact> newList, List<Contact> oldList){
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
        
        Map<Id, Integer> totalMap = new Map<Id,Integer>();
        
        for(AggregateResult ar : [SELECT AccountId accId, COUNT(Id) cnt FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId]){
            totalMap.put((Id) ar.get('accId'), (Integer) ar.get('cnt'));
        }
        
        Map<Id,Integer> deadMap = new Map<Id,Integer>();
        
        for(AggregateResult ar : [SELECT AccountId accId, COUNT(Id) cnt FROM Contact WHERE AccountId IN : accIds AND Dead__c = true GROUP BY AccountId]){
            deadMap.put( (Id) ar.get('accId'), (Integer) ar.get('cnt'));
        }
        
        List<Account> accToUpdate = new List<Account>();
        
        for(Id accId : accIds){
            Integer total = totalMap.containsKey(accId) ? totalMap.get(accId) : 0;
            Integer dead  = deadMap.containsKey(accId) ? deadMap.get(accId) : 0;
            
            Boolean flag = false;
            
            if(total>0){
                Double percentage = (dead * 100)/total;
                
                if(percentage >= 70){
                    flag = true;
                }
            }
            
            accToUpdate.add(new Account(Id=accId, need_intel__c = flag));
            
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
    
}