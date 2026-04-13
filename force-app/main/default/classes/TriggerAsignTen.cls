public class TriggerAsignTen {
    
    public static void createContact(List<Account> accList){
        try{
            List<Contact> conList = new List<Contact>();
            for(Account acc : accList){
                if(acc.Industry == 'Banking'){
                    Contact con = new Contact();
                    con.lastName = acc.Name;
                    con.Phone = acc.Phone;
                    con.AccountId=acc.Id;
                    
                    conList.add(con);
                }
            }
            
            if(!conList.isEmpty()){
                insert conList;
            }
        }
        catch(DmlException e){
            system.debug('DML Exception Error : ' + e.getMessage());
        }
        
        
    }
    
}