public class TriggerAsignFortyEight {

    public static void syncMultiPicklist(List<Opportunity> newList, Map<Id,Opportunity> oldMap){

        Map<Id,String> accountValueMap = new Map<Id,String>();

        for(Opportunity opp : newList){

            Opportunity oldOpp = oldMap.get(opp.Id);

            if(opp.Options__c != oldOpp.Options__c && opp.AccountId != null){
                accountValueMap.put(opp.AccountId, opp.Options__c);
            }
        }

        if(accountValueMap.isEmpty()){
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();

        for(Id accId : accountValueMap.keySet()){

            accountsToUpdate.add(new Account(
                Id = accId,
                Options__c = accountValueMap.get(accId)
            ));
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}