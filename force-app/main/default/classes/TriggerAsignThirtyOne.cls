public class TriggerAsignThirtyOne {
    public static void handleEmployeeUndelete(List<Employee__c> newEmployees){

        Set<Id> accountIds = new Set<Id>();
        List<Employee__c> employeesToUpdate = new List<Employee__c>();

        for(Employee__c emp : newEmployees){

            emp.Active__c = true;
            employeesToUpdate.add(emp);

            if(emp.Account__c != null){
                accountIds.add(emp.Account__c);
            }

        }

        if(!employeesToUpdate.isEmpty()){
            update employeesToUpdate;
        }

        if(accountIds.isEmpty()){
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();

        for(Account acc : [
            SELECT Id, Deleted_Employee_Count__c
            FROM Account
            WHERE Id IN :accountIds
        ]){

            if(acc.Deleted_Employee_Count__c > 0){
                acc.Deleted_Employee_Count__c = acc.Deleted_Employee_Count__c - 1;
            }

            accountsToUpdate.add(acc);
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }

    }
}