public class TriggerAsignTwelve {
    
    public static void handleClosedWon(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        try{
            for(Opportunity opp : newList){
                Opportunity oldOpp = oldMap.get(opp.Id);
                
                if(opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won'){
                    opp.CloseDate = System.today();
                    opp.Type = 'New Customer';
                }
            }
        }
        catch(Exception e){
            System.debug('Error : ' + e.getMessage());
        }
    }
}