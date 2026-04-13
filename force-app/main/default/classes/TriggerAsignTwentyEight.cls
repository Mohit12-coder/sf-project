public class TriggerAsignTwentyEight {

    public static void updateTotalOpportunityAmount(List<Opportunity> newList, List<Opportunity> oldList){
        Set<Id> accountIds = new Set<Id>();
        
        if(newList != null){
            for(Opportunity opp : newList){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                }
            }
        }
        
        if(oldList != null){
            for(Opportunity opp : oldList){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                }
            }
        }
        
        if(accountIds.isEmpty()){
            return;
        }
        
        Map<Id,Decimal> amountMap = new Map<Id,Decimal>();
        
        for(AggregateResult ar : [SELECT AccountId accId, SUM(Amount) totalAmount FROM Opportunity WHERE AccountId IN : accountIds GROUP BY AccountId]){
            amountMap.put((Id) ar.get('accId'), (Decimal)ar.get('totalAmount'));
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Id accId : accountIds){
            Account acc = new Account();
            acc.Id =accId;
            
            acc.Total_Opportunity_Amount__c = amountMap.containsKey(accId) ? amountMap.get(accId) : 0;
            
            accountsToUpdate.add(acc);
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}