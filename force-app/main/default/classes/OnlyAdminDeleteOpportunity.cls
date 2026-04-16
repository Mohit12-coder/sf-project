public class OnlyAdminDeleteOpportunity {

    public static void preventOpportunity( List<Opportunity> oppList){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        for(Opportunity opp : oppList){
            if(opp.StageName =='Closed Won' || opp.StageName == 'Closed Lost'){
                if(userInfo.getProfileId() != p.Id){
                    opp.addError('Only system admin can delete it');
                }
            }
        }
    }
    
}