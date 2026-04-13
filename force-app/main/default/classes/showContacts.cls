public with sharing class showContacts {
    
    @AuraEnabled(cacheable = true)
    public static List<Contact> sendContacts(Id recordId){
        List<Contact> conList = new List<Contact>();
        
            conList = [SELECT Id , Name FROM Contacts WHERE AccountId = : recordId];

            if(!conList.isEmpty()){
                return conList;
            }
        
    }

}