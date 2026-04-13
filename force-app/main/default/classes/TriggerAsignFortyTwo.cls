public class TriggerAsignFortyTwo {

    public static void updateAccountNameWithMaxOpp(List<Opportunity> newList, List<Opportunity> oldList){

        Set<Id> accountIds = new Set<Id>();

        // From new records
        if(newList != null){
            for(Opportunity opp : newList){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                }
            }
        }

        // From old records (delete case)
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

        // Query Opportunities sorted by highest Amount
        List<Opportunity> oppList = [
            SELECT Id, Name, Amount, AccountId
            FROM Opportunity
            WHERE AccountId IN :accountIds
            ORDER BY AccountId, Amount DESC NULLS LAST
        ];

        Map<Id, Opportunity> maxOppMap = new Map<Id, Opportunity>();

        for(Opportunity opp : oppList){
            if(!maxOppMap.containsKey(opp.AccountId)){
                maxOppMap.put(opp.AccountId, opp);
            }
        }

        List<Account> accountsToUpdate = new List<Account>();

        for(Id accId : maxOppMap.keySet()){
            Opportunity maxOpp = maxOppMap.get(accId);

            accountsToUpdate.add(new Account(
                Id = accId,
                Name = maxOpp.Name
            ));
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}