public class TriggerAsignSeventyEight {

    public static void handleUndelete(List<Contact> conList){

        // Step 1: Get a default Account (example logic)
        Account acc = [SELECT Id FROM Account LIMIT 1];

        List<Contact> contactsToUpdate = new List<Contact>();

        // Step 2: Assign Account to Contacts
        for(Contact con : conList){

            if(con.AccountId == null){
                contactsToUpdate.add(new Contact(
                    Id = con.Id,
                    AccountId = acc.Id
                ));
            }
        }

        // Step 3: Update Contacts
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }
    
}