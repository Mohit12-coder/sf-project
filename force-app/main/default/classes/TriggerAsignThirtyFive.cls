public class TriggerAsignThirtyFive {

    public static void createAccountforContact(List<Contact> newContacts){
        List<Account> accountsToInsert = new List<Account>();
        Map<Integer, Account> contactAccountMap = new Map<Integer, Account>();
        
        Integer index = 0;
        
        for(Contact con : newContacts){
            if(con.AccountId == null){
                Account acc = new Account();
                acc.Name = con.LastName + ' Account';
                
                accountsToInsert.add(acc);
                contactAccountMap.put(index, acc);
            }
            index++;
        }
        
        if(!accountstoInsert.isEmpty()){
            insert accountsToInsert;
        }
        index = 0;
        for(Contact con : newContacts){
            if(con.AccountId == null && contactAccountMap.containsKey(index)){
                con.AccountId = contactAccountMap.get(index).Id;
            }
            
            index++;
        }
    }
    
}