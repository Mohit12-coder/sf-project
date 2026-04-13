public class TriggerAsignFiftySeven {

    public static void createClientContact(List<Account> newAccounts){

        List<Contact> contactsToInsert = new List<Contact>();

        //Create Contacts
        for(Account acc : newAccounts){

            Contact con = new Contact();
            con.LastName = acc.Name;  
            con.AccountId = acc.Id;

            contactsToInsert.add(con);
        }

        if(contactsToInsert.isEmpty()){
            return;
        }

        insert contactsToInsert;

        //Update Account with Contact Id
        List<Account> accountsToUpdate = new List<Account>();

        for(Integer i = 0; i < newAccounts.size(); i++){

            accountsToUpdate.add(new Account(
                Id = newAccounts[i].Id,
                Client_Contact__c = contactsToInsert[i].Id
            ));
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
    
}