public class TriggerAsignNinetySix {
    
    public static void preventAccountDeletion(List<Account> oldList){

        Set<Id> accIds = new Set<Id>();

        for(Account acc : oldList){
            accIds.add(acc.Id);
        }

        // Find active Opportunities
        Map<Id, Integer> oppCountMap = new Map<Id, Integer>();

        for(AggregateResult ar : [
            SELECT AccountId accId, COUNT(Id) cnt
            FROM Opportunity
            WHERE AccountId IN :accIds
            AND IsClosed = false
            GROUP BY AccountId
        ]){
            oppCountMap.put((Id)ar.get('accId'), (Integer)ar.get('cnt'));
        }

        // Prevent deletion
        for(Account acc : oldList){
            if(oppCountMap.containsKey(acc.Id)){
                acc.addError('Account cannot be deleted as it has active Opportunities');
            }
        }
    }
    
}