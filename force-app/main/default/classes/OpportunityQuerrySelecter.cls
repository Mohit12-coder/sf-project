public with sharing class OpportunityQuerrySelecter {
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getAllOpportunities(){
        List<Opportunity> oppList = [SELECT Id,Name, StageName,Amount, CloseDate FROM Opportunity];

        if(!oppList.isEmpty()){
            return oppList;
        }
    }

}