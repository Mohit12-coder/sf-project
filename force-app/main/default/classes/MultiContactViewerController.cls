public with sharing class MultiContactViewerController {

    public class ContactWrapper {

        @AuraEnabled public Id contactId;
        @AuraEnabled public String contactName;
        @AuraEnabled public String mobilePhone;

        public ContactWrapper(Contact con) {
            contactId = con.Id;
            contactName = con.Name;
            mobilePhone = con.MobilePhone;
        }
    }

    public class TaskWrapper {

        @AuraEnabled public Id taskId;
        @AuraEnabled public String subject;
        @AuraEnabled public Date activityDate;
        @AuraEnabled public Datetime createdDate;
        @AuraEnabled public String whoName;

        public TaskWrapper(Task t) {
            taskId = t.Id;
            subject = t.Subject;
            activityDate = t.ActivityDate;
            createdDate = t.CreatedDate;

            if(t.Who != null) {
                whoName = t.Who.Name;
            }
        }
    }

    public class ContactGroupedWrapper {

        @AuraEnabled public Id contactId;
        @AuraEnabled public String contactName;
        @AuraEnabled public List<Case> casesList;
        @AuraEnabled public List<TaskWrapper> tasksList;

        public ContactGroupedWrapper() {
            casesList = new List<Case>();
            tasksList = new List<TaskWrapper>();
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ContactWrapper> searchContacts(String searchKey) {

        List<ContactWrapper> wrapperList = new List<ContactWrapper>();

        if(String.isBlank(searchKey)) {
            return wrapperList;
        }


        String keyword ='%' + searchKey + '%';

        List<Contact> contacts = [ SELECT Id,Name, MobilePhone FROM Contact WHERE Name LIKE :keyword OR MobilePhone LIKE :keyword ORDER BY Name LIMIT 10];

        for(Contact con : contacts) {
            wrapperList.add( new ContactWrapper(con));
        }

        return wrapperList;
    }

    @AuraEnabled(cacheable=true)
    public static List<ContactGroupedWrapper> getRelatedRecords(List<Id> contactIds) {

        List<ContactGroupedWrapper> finalList = new List<ContactGroupedWrapper>();

        if(contactIds == null || contactIds.isEmpty()) {
            return finalList;
        }

        Map<Id, ContactGroupedWrapper> contactMap = new Map<Id, ContactGroupedWrapper>();

        List<Contact> contactList = [ SELECT Id, Name FROM Contact WHERE Id IN :contactIds];

        for(Contact con : contactList) {
            ContactGroupedWrapper wrapper = new ContactGroupedWrapper();
            wrapper.contactId = con.Id;
            wrapper.contactName = con.Name;
            contactMap.put(con.Id, wrapper);
        }

        List<Case> caseList = [SELECT Id,CaseNumber,Subject,Status,Priority, CreatedDate,ContactId FROM Case WHERE ContactId IN :contactIds ORDER BY CreatedDate DESC];

        for(Case cs : caseList) {
            if(contactMap.containsKey(cs.ContactId)) {
                contactMap.get(cs.ContactId).casesList.add(cs);
            }
        }

        List<Task> taskList = [SELECT Id,Subject,ActivityDate,CreatedDate,WhoId,Who.Name FROM Task WHERE WhoId IN :contactIds ORDER BY CreatedDate DESC];

        for(Task t : taskList) {
            if(contactMap.containsKey(t.WhoId)) {
                contactMap.get(t.WhoId).tasksList.add( new TaskWrapper(t));
            }
        }

        finalList.addAll( contactMap.values() );

        return finalList;
    }
}