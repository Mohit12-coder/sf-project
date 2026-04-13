public with sharing class OpportunityDashboardController {

    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchText) {
        String txt = '%' + searchText + '%';
        return [ SELECT Id, Name FROM Account WHERE Name LIKE :txt ORDER BY Name LIMIT 50 ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getRecentAccounts() {
        return [ SELECT Id, Name FROM Account ORDER BY LastModifiedDate DESC LIMIT 10 ];
    }

    @AuraEnabled
    public static void updateOpportunityAccount(Id opportunityId, Id accountId) {
        Opportunity opp = new Opportunity( Id = opportunityId, AccountId = accountId);
        update opp;
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getAllOpportunityList() {
        List<Opportunity> oppList = [ SELECT Id, Name, AccountId, Account.Name, OwnerId, Owner.Name, CreatedById, CreatedBy.Name, LastModifiedById, LastModifiedBy.Name, RecordTypeId, StageName, Type, LeadSource, Amount, Probability, ExpectedRevenue, TotalOpportunityQuantity, CloseDate, NextStep, ForecastCategory, ForecastCategoryName, IsClosed, IsWon, Pricebook2Id, CampaignId, ContractId,   LastActivityDate, LastReferencedDate, LastViewedDate, CreatedDate, LastModifiedDate, SystemModstamp, PushCount, HasOpenActivity, HasOverdueTask, ContactId FROM Opportunity ORDER BY LastModifiedDate DESC ];
        try {  
            return oppList;   
        } catch (Exception e) {
            throw new AuraHandledException('Error while loading opportunities.');
        }
    }

    @AuraEnabled
    public static void updateOpportunityRecords(List<Opportunity> oppList) {
        try {
            if (oppList == null || oppList.isEmpty()) {
                return;
            }
            update oppList;
        } catch (Exception e) {
            throw new AuraHandledException('Error while saving opportunities.');
        }
    }
}