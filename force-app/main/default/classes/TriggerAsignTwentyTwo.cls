public class TriggerAsignTwentyTwo {

    public static void updateSalesRep(List<Account> newAccounts){

        Set<Id> ownerIds = new Set<Id>();

        for(Account acc : newAccounts){
            if(acc.OwnerId != null){
                ownerIds.add(acc.OwnerId);
            }
        }

        if(ownerIds.isEmpty()){
            return;
        }

        Map<Id,User> userMap = new Map<Id,User>(
            [SELECT Id, Name FROM User WHERE Id IN :ownerIds]
        );

        for(Account acc : newAccounts){

            if(acc.OwnerId != null && userMap.containsKey(acc.OwnerId)){
                acc.Sales_Rep__c = userMap.get(acc.OwnerId).Name;
            }

        }

    }
    
}