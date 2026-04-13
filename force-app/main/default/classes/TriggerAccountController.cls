public with sharing class AccountController {
    @AuraEnabled(cacheable = true)
    public static List<Account> getHighRevenueAccountRecords(Integer count){
        try{
            return [SELECT Id, Name, AnnualRevenue FROM Account ORDER BY AnnualRevenue DESC NULLS LAST LIMIT : count ];
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}



// global class FutureCalloutExample{

//     @future(callout=true)
//     public static void doCalloutInFuture(String acc){
//          // Perform a callout to an external service
//     }

// }



// public class AccountProcessor implements Queueable {
    
//     private List<Id> accountIds;

//     // Constructor
//     public AccountProcessor(List<Id> accountIds) {
//         this.accountIds = accountIds;
//     }

//     public void execute(QueueableContext context) {
//         List<Account> accList = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        
//         for (Account acc : accList) {
//             acc.Name = acc.Name + ' - Processed';
//         }

//         update accList;
//     }
// }







// public class MyBatchClass implements Database.Batchable<sObject> {

//     // 1. Start method (defines scope)
//     public Database.QueryLocator start(Database.BatchableContext bc) {
//         return Database.getQueryLocator('SELECT Id, Name FROM Account');
//     }

//     // 2. Execute method (runs for each batch)
//     public void execute(Database.BatchableContext bc, List<Account> scope) {
//         for (Account acc : scope) {
//             acc.Name = acc.Name + ' - Updated';
//         }
//         update scope;
//     }

//     // 3. Finish method (after all batches complete)
//     public void finish(Database.BatchableContext bc) {
//         System.debug('Batch job completed');
//     }
// }