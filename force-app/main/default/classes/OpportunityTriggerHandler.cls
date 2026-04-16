public class OpportunityTriggerHandler {

    public static void updateAccountOpportunityNames(Set<Id> accountIds) {

        Map<Id, Opportunity> maxMap = new Map<Id, Opportunity>();
        Map<Id, Opportunity> minMap = new Map<Id, Opportunity>();

        List<Opportunity> oppList = [SELECT Id, Name, Amount, AccountId FROM Opportunity WHERE AccountId IN :accountIds AND Amount != null];

        for (Opportunity opp : oppList) {

            if (!maxMap.containsKey(opp.AccountId)) {
                maxMap.put(opp.AccountId, opp);
                minMap.put(opp.AccountId, opp);
            } 
            else {

                if (opp.Amount > maxMap.get(opp.AccountId).Amount) {
                    maxMap.put(opp.AccountId, opp);
                }

                if (opp.Amount < minMap.get(opp.AccountId).Amount) {
                    minMap.put(opp.AccountId, opp);
                }
            }
        }

        List<Account> accList = new List<Account>();

        for (Id accId : accountIds) {

            Account acc = new Account();
            acc.Id = accId;

            if (maxMap.containsKey(accId)) {
                acc.Max_Opportunity_Name__c = maxMap.get(accId).Name;
                acc.Min_Opportunity_Name__c = minMap.get(accId).Name;
            } 
            else {
                acc.Max_Opportunity_Name__c = null;
                acc.Min_Opportunity_Name__c = null;
            }

            accList.add(acc);
        }

        if (!accList.isEmpty()) {
            update accList;
        }
    }
}