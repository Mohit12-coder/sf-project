public class TriggerAsignFourteen {

    public static void setOtherPhoneFromAccount(List <Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();
        
        for(Contact con : newContacts){
            if(con.AccountId != null){
                accountIds.add(con.AccountId);
            }
        }
        
        if(accountIds.isEmpty()){
            return;
        }
        
        Map<Id,Account> accountMap = new Map<Id, Account>([SELECT Id, Phone FROM Account WHERE Id IN : accountIds]);
        
        for(Contact con : newContacts){
            if(con.AccountId != null && accountMap.containsKey(con.AccountId)){
                con.OtherPhone = accountMap.get(con.AccountId).Phone;
            }
        }
    }
    
}