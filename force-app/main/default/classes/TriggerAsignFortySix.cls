public class TriggerAsignFortySix {

    public static void updateAccountRating(List<Case> newList, List<Case> oldList){
        Set<Id> accountIds = new Set<Id>();
        
        if(newList != null){
            for(Case cs : newList){
                if(cs.AccountId != null){
                    accountIds.add(cs.AccountId);
                }
            }
        }
        
        if(OldList != null){
            for(Case cs : oldList){
                if(cs.AccountId != null){
                    accountIds.add(cs.AccountId);
                }
            }
        }
        
        if(AccountIds.isEmpty()){
            return;
        }
        
        Map<Id, Integer> caseCountMap = new Map<Id, Integer>();
        
        for(AggregateResult ar : [SELECT AccountId accId, COUNT(Id) total FROM Case WHERE AccountId IN : accountIds AND Status ='Closed' GROUP BY AccountId]){
            caseCountMap.put((Id)ar.get('accId'),(Integer)ar.get('total'));
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Id accId : accountIds){
            Integer countCases = caseCountMap.containsKey(accId) ? caseCountMap.get(accId) : 0;
            
            String giveRating;
            
            if(countCases < 2)
                giveRating = 'Cold';
            else if(countCases <=5)
                giveRating ='Warm';
            else
                giveRating='Hot';
            
            accountsToUpdate.add(new Account(Id=accId, Rating = giveRating));
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
        
    }
    
}