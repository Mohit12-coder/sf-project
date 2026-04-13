public class TriggerAsignFiftyThree {

    public static void updateAccountRating(List<Opportunity> newList, List<Opportunity> oldList){

        Set<Id> accountIds = new Set<Id>();

        // Collect Account IDs
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

        // Aggregate total Opportunity Amount
        Map<Id, Decimal> amountMap = new Map<Id, Decimal>();

        for(AggregateResult ar : [ SELECT AccountId accId, SUM(Amount) totalAmt  FROM Opportunity WHERE AccountId IN :accountIds GROUP BY AccountId]){
            amountMap.put((Id)ar.get('accId'), (Decimal)ar.get('totalAmt'));
        }

        List<Account> accountsToUpdate = new List<Account>();

        for(Id accId : accountIds){

            Decimal total = amountMap.containsKey(accId) ? amountMap.get(accId) : 0;

            String rating;

            if(total <= 50000){
                rating = 'Cold';
            }
            else if(total <= 100000){
                rating = 'Warm';
            }
            else{
                rating = 'Hot';
            }

            accountsToUpdate.add(new Account(
                Id = accId,
                Rating = rating
            ));
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}