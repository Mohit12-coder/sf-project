public class TriggerAsignTwentySix {

    public static void updateOldOpportunities(List<Account> updatedAccounts){
        Set<Id> accountIds = new Set<Id>();
        
        for(Account acc : updatedAccounts){
            accountIds.add(acc.Id);
        }
        
        if(accountIds.isEmpty()){
            return;
        }
        
        Date limitDate = System.today().addDays(-30);
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
        List<Opportunity> oppList = [SELECT Id,StageName, CreatedDate, AccountId FROM Opportunity WHERE AccountId IN : accountIds];
        
        for(Opportunity opp : oppList){
            if(opp.CreatedDate.date() < limitDate && opp.StageName != 'Closed Won'){
                opp.StageName = 'Closed Lost';
                oppToUpdate.add(opp);
            }
        }
        
        if(!oppToUpdate.isEmpty()){
            update oppToUpdate;
        }
    }
    
}