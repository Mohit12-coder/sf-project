public class TriggerAsignTwentyNine {

    public static void updateContactAddress(List<Account> newAccounts, Map<Id,Account> oldMap){

        Set<Id> accountIds = new Set<Id>();

        for(Account acc : newAccounts){

            Account oldAcc = oldMap.get(acc.Id);

            if(acc.BillingStreet != oldAcc.BillingStreet ||
               acc.BillingCity != oldAcc.BillingCity ||
               acc.BillingState != oldAcc.BillingState ||
               acc.BillingPostalCode != oldAcc.BillingPostalCode ||
               acc.BillingCountry != oldAcc.BillingCountry){

                accountIds.add(acc.Id);
            }

        }

        if(accountIds.isEmpty()){
            return;
        }

        List<Contact> contactsToUpdate = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        Map<Id,Account> accMap = new Map<Id,Account>(newAccounts);

        for(Contact con : contactsToUpdate){

            Account acc = accMap.get(con.AccountId);

            con.MailingStreet = acc.BillingStreet;
            con.MailingCity = acc.BillingCity;
            con.MailingState = acc.BillingState;
            con.MailingPostalCode = acc.BillingPostalCode;
            con.MailingCountry = acc.BillingCountry;

        }

        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }

    }
    
}