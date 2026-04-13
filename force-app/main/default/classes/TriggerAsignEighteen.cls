public class TriggerAsignEighteen {

    public static void preventMoreThanTwoContacts(List<Contact> newContacts){

        Set<Id> accountIds = new Set<Id>();

        for(Contact con : newContacts){
            if(con.AccountId != null){
                accountIds.add(con.AccountId);
            }
        }

        if(accountIds.isEmpty()){
            return;
        }

        Map<Id,Integer> contactCountMap = new Map<Id,Integer>();

        for(AggregateResult ar : [ SELECT AccountId accId, COUNT(Id) total FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId]){
            contactCountMap.put((Id)ar.get('accId'), (Integer)ar.get('total'));
        }

        for(Contact con : newContacts){

            if(con.AccountId != null && contactCountMap.containsKey(con.AccountId)){

                if(contactCountMap.get(con.AccountId) >= 2){
                    con.addError('Only two Contacts are allowed for this Account.');
                }

            }

        }

    }
    
}