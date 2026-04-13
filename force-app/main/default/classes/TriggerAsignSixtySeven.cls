public class TriggerAsignSixtySeven {

    public static void preventDeleteWithContacts(List<Account> oldList){

        Set<Id> accIds = new Set<Id>();

        for(Account acc : oldList){
            accIds.add(acc.Id);
        }

        // Step 1: Check related Contacts
        Map<Id, Integer> contactMap = new Map<Id, Integer>();

        for(AggregateResult ar : [
            SELECT AccountId accId, COUNT(Id) cnt
            FROM Contact
            WHERE AccountId IN :accIds
            GROUP BY AccountId
        ]){
            contactMap.put((Id)ar.get('accId'), (Integer)ar.get('cnt'));
        }

        // Step 2: Prevent deletion
        for(Account acc : oldList){
            if(contactMap.containsKey(acc.Id)){
                acc.addError('Cannot delete Account because related Contacts exist.');
            }
        }
    }
    
}