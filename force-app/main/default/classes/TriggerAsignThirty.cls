public class TriggerAsignThirty {

    // Prevent deletion if Active = true
    public static void preventActiveEmployeeDeletion(List<Employee__c> oldEmployees){

        for(Employee__c emp : oldEmployees){

            if(emp.Active__c == true){
                emp.addError('Active Employee cannot be deleted.');
            }

        }

    }


    // Update Deleted Employee Count on Account
    public static void updateDeletedEmployeeCount(List<Employee__c> oldEmployees){

        Set<Id> accountIds = new Set<Id>();

        for(Employee__c emp : oldEmployees){
            if(emp.Account__c != null){
                accountIds.add(emp.Account__c);
            }
        }

        if(accountIds.isEmpty()){
            return;
        }

        Map<Id,Integer> countMap = new Map<Id,Integer>();

        for(AggregateResult ar : [SELECT Account__c accId, COUNT(Id) total FROM Employee__c WHERE Account__c IN :accountIds GROUP BY Account__c ]){
            countMap.put((Id)ar.get('accId'), (Integer)ar.get('total'));
        }

        List<Account> accountsToUpdate = new List<Account>();

        for(Id accId : accountIds){

            Account acc = new Account();
            acc.Id = accId;

            Integer remainingEmployees = countMap.containsKey(accId) ? countMap.get(accId) : 0;

            acc.Deleted_Employee_Count__c = acc.Deleted_Employee_Count__c + 1;

            accountsToUpdate.add(acc);

        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }

    }
    
}