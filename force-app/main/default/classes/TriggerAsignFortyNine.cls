public class TriggerAsignFortyNine {

    public static void syncClientContact(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        Map<Id,Id> accToContactMap = new Map<Id,Id>();
        
        for(Opportunity opp : newList){
            
            Opportunity oldOpp = oldMap.get(opp.Id);
            
            if(opp.Client_Contact__c != oldOpp.Client_Contact__c && opp.AccountId != null){
                
               accToContactMap.put(opp.AccountId, opp.Client_Contact__c);
                
            }
            
        }
        
        if(accToContactMap.isEmpty()){
            return;
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Id accId : accToContactMap.keySet()){
            accountsToUpdate.add(new Account( Id=accId, Client_Contact__c = accToContactMap.get(accId)));
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}