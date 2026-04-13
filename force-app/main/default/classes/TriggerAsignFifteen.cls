public class TriggerAsignFifteen {

    public static void updateAccountDescription(List<Contact> newList, Map<Id, Contact> oldMap){
        Map<Id,String> accountDescMap = new Map<Id,String>();
        
        for(Contact con : newList){
            Contact oldCon = oldMap.get(con.Id);
            
            if(con.Description != oldCon.Description && con.AccountId != null){
                accountDescMap.put(con.AccountId, con.Description);
            }
        }
        
        if(accountDescMap.isEmpty()){
            return;
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Id accId : accountDescMap.keySet()){
            Account acc = new Account();
            acc.Id = accId;
            acc.Description = accountDescMap.get(accId);
            
            accountsToUpdate.add(acc);
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountstoUpdate;
        }
    }
    
}