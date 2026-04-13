public class TriggerAsignFortyFour {

    public static void closeOpportunities(List<Account> newList, Map<Id,Account> oldMap){

        Set<Id> accountIds = new Set<Id>();

        // Step 1: Find Accounts where checkbox changed to TRUE
        for(Account acc : newList){

            Account oldAcc = oldMap.get(acc.Id);

            if(acc.Close_All_Opportunities__c == true &&
               (oldAcc.Close_All_Opportunities__c == false || oldAcc.Close_All_Opportunities__c == null)){

                accountIds.add(acc.Id);
            }
        }

        if(accountIds.isEmpty()){
            return;
        }

        // Step 2: Fetch Opportunities with Probability > 70%
        List<Opportunity> oppsToUpdate = [
            SELECT Id, StageName, Probability, CloseDate
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND Probability > 70
            AND StageName != 'Closed Won'
        ];

        // Step 3: Update Opportunities
        for(Opportunity opp : oppsToUpdate){

            opp.StageName = 'Closed Won';
            opp.CloseDate = Date.today(); // optional but recommended
        }

        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }
    
}