public class TriggerAsignFiftyOne {

    public static void updateAccountOpportunityAmount(List<Contact> newList, Map<Id,Contact> oldMap){

        Set<Id> accountIds = new Set<Id>();

        // Step 1: Collect Account IDs
        for(Contact con : newList){
            if(con.AccountId != null){
                accountIds.add(con.AccountId);
            }
        }

        if(accountIds.isEmpty()){
            return;
        }

        // Step 2: Aggregate total Opportunity Amount
        Map<Id, Decimal> amountMap = new Map<Id, Decimal>();

        for(AggregateResult ar : [
            SELECT AccountId accId, SUM(Amount) totalAmt
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]){
            amountMap.put((Id)ar.get('accId'), (Decimal)ar.get('totalAmt'));
        }

        // Step 3: Update Accounts
        List<Account> accountsToUpdate = new List<Account>();

        for(Id accId : accountIds){

            Decimal total = amountMap.containsKey(accId)
                            ? amountMap.get(accId)
                            : 0;

            accountsToUpdate.add(new Account(
                Id = accId,
                Total_Opportunity_Amount__c = total
            ));
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}