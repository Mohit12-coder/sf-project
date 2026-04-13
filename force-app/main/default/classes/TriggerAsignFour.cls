public class TriggerAsignFour {

    public static void updateLatestCase(List<Case> caseList){
        
        if(caseList == null || caseList.isEmpty()){
            return;
        }
        
        Map<Id, String> accountCaseMap = new Map<Id, String>();
        
        try{
            
            for(Case cs : caseList){
                
                accountCaseMap.put(cs.AccountId, cs.CaseNumber);
                
            }
            
            List<Account> accountsToUpdate = new List<Account>();
            
            for(Id accId : accountCaseMap.keySet()){
                
                Account acc = new Account();
                acc.Id = accId;
                acc.Latest_Case_Inserted__c = accountCaseMap.get(accId);
                
                accountsToUpdate.add(acc);
                
            }
            
            if(!accountsToUpdate.isEmpty()){
                update accountsToUpdate;
            }
            
        }
        catch(DmlException e){
            System.debug('DML Exception : ' + e.getMessage());
        }
        
    }
    
}