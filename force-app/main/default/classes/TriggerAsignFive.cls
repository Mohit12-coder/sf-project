public class TriggerAsignFive {
    
    public static void createContact(List<Account> accountList){
        
        if(accountList == null || accountList.isEmpty()){
            return;
        }
        
        List<Contact> contactsToInsert = new List<Contact>();
        
        try{
            
            for(Account acc : accountList){
                
                if(acc.Create_Contact__c == true){
                    Contact con = new Contact();
                    con.LastName = acc.Name;
                    con.Phone = acc.Phone;
                    con.AccountId = acc.Id;
                    
                    contactsToInsert.add(con);
                }
                
            }
            
            if(!contactsToInsert.isEmpty()){
                insert contactsToInsert;
            }
            
        }
        catch(DmlException e){
            System.debug('DML Exception : ' + e.getMessage());
        }
        
    }
    
}