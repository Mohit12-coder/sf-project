public with sharing class ShowAllAccounts {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> showAccounts(){
        try {
            return [SELECT Id, Name, Industry, CreatedDate from Account ORDER BY CreatedDate DESC LIMIT 5 ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}