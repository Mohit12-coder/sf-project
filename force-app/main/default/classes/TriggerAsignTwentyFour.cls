public class TriggerAsignTwentyFour {

    public static void updateOpportunityStage(List<Account> updatedAccounts){

        Set<Id> accountIds = new Set<Id>();

        for(Account acc : updatedAccounts){
            accountIds.add(acc.Id);
        }

        if(accountIds.isEmpty()){
            return;
        }

        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        Date limitDate = System.today().addDays(-30);

        List<Opportunity> oppList = [
            SELECT Id, StageName, CreatedDate, AccountId
            FROM Opportunity
            WHERE AccountId IN :accountIds
        ];

        for(Opportunity opp : oppList){

            if(opp.CreatedDate.date() < limitDate && opp.StageName != 'Closed Won'){

                opp.StageName = 'Closed Lost';
                oppsToUpdate.add(opp);

            }

        }

        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }

    }
    
}