@isTest public class TriggerAsignFortyNineTest {

    @isTest static void testClientContactSync(){
        Account acc = new Account(Name='Test Account',Status__c ='Active');
        insert acc;
        
        Contact c1 = new Contact(LastName = 'Contact1');
        Contact c2 = new Contact(LastName = 'Contact2');
        insert new List<Contact>{c1,c2};
            
        Opportunity opp = new Opportunity( Name='Test Opp', StageName='Prospecting', CloseDate = Date.today().addDays(10), AccountId = acc.Id,Client_Contact__c = c1.Id);
        insert opp;
        
        opp.Client_Contact__c = c2.Id;
        
        Test.startTest();
        update opp;
        Test.stopTest();
        
        Account updatedAcc = [SELECT Id, Client_Contact__c FROM Account WHERE Id = :acc.Id];
        
        System.assertEquals(c2.Id, updatedAcc.Client_Contact__c);
    }
    
}