public class TriggerAsignFortySeven {
    
    public static void updateContactCity(List<Account> newList, Map<Id,Account> oldMap){

        Set<Id> accountIds = new Set<Id>();

        for(Account acc : newList){

            Account oldAcc = oldMap.get(acc.Id);

            if(acc.BillingCity != oldAcc.BillingCity){
                accountIds.add(acc.Id);
            }
        }

        if(accountIds.isEmpty()){
            return;
        }

        List<Contact> contactsToUpdate = [
            SELECT Id, AccountId, MailingCity
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        Map<Id, Account> accMap = new Map<Id,Account>(newList);

        for(Contact con : contactsToUpdate){

            Account acc = accMap.get(con.AccountId);
            con.MailingCity = acc.BillingCity;
        }

        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }
    
}