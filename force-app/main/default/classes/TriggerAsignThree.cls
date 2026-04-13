public class TriggerAsignThree {
    
    public static void createContact(List<Account> accountList){
        
        if(accountList == null || accountList.isEmpty()){
            return;
        }
        
        List<Contact> contactList = new List<Contact>();
        
        try{
            
            for(Account acc : accountList){
                
                Contact con = new Contact();
                con.LastName = acc.Name;
                con.AccountId = acc.Id;
                
                contactList.add(con);
                
            }
            
            if(!contactList.isEmpty()){
                
                insert contactList;
                
            }
            
        }
        catch(DmlException e){
            System.debug('Error inserting contacts: ' + e.getMessage());
        }
        
    }
    
}