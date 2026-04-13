public with sharing class AccountRelatedContactHandler {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accId){
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :accId];
    }
}