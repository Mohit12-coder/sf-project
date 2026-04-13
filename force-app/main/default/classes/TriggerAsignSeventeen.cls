public class TriggerAsignSeventeen {

    public static void preventDeleteIfContactsExist(List<Account> oldAccounts){

        Set<Id> accountIds = new Set<Id>();

        for(Account acc : oldAccounts){
            accountIds.add(acc.Id);
        }

        Map<Id,Integer> contactCountMap = new Map<Id,Integer>();

        for(AggregateResult ar : [
            SELECT AccountId accId, COUNT(Id) total
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]){
            contactCountMap.put((Id)ar.get('accId'), (Integer)ar.get('total'));
        }

        for(Account acc : oldAccounts){

            if(contactCountMap.containsKey(acc.Id) && contactCountMap.get(acc.Id) > 0){
                acc.addError('Account cannot be deleted');
            }

        }

    }
    
}