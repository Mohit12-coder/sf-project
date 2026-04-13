public class TriggerAsignEleven {

    public static void createContactsByLocation(List<Account> accountList){
        
        List<Contact> contactsToInsert = new List<Contact>();
        
        try{
            for(Account acc : accountList){
                if(acc.Number_of_Locations__c != null){
                    Integer num = Integer.valueOf(acc.Number_of_Locations__c);
                    
                    for(Integer i=1; i<= num; i++){
                        Contact con = new Contact();
                        con.LastName = acc.Name + 'Contact ' + i;
                        con.AccountId = acc.Id;
                        
                        contactsToInsert.add(con);
                    }
                }
            }
            
            if(!contactsToInsert.isEmpty()){
                insert contactsToInsert;
            }
        }
        catch(DmlException e){
            System.debug('DML Error : ' + e.getMessage());
        }
        
    }
    
}