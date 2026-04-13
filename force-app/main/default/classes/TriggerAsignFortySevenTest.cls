@isTest public class TriggerAsignFortySevenTest {

    @isTest
    static void testUpdateContactCity(){

        Account acc = new Account(
            Name = 'Test Account',
            BillingCity = 'Delhi',
            Status__c = 'Active'
        );
        insert acc;

        Contact c1 = new Contact(
            LastName = 'Test1',
            AccountId = acc.Id,
            MailingCity = 'OldCity'
        );

        Contact c2 = new Contact(
            LastName = 'Test2',
            AccountId = acc.Id,
            MailingCity = 'OldCity'
        );

        insert new List<Contact>{c1, c2};

        acc.BillingCity = 'Mumbai';

        Test.startTest();
        update acc;
        Test.stopTest();

        List<Contact> updatedContacts = [
            SELECT Id, MailingCity
            FROM Contact
            WHERE AccountId = :acc.Id
        ];

        for(Contact con : updatedContacts){
            System.assertEquals('Mumbai', con.MailingCity);
        }
    }
    
}