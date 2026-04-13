public class TriggerAsignForty {

    public static void deleteOpportunity(List<OpportunityLineItem> oldItems){

        Set<Id> oppIds = new Set<Id>();

        for(OpportunityLineItem oli : oldItems){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
        }

        if(oppIds.isEmpty()){
            return;
        }

        List<Opportunity> oppsToDelete = [
            SELECT Id
            FROM Opportunity
            WHERE Id IN :oppIds
        ];

        if(!oppsToDelete.isEmpty()){
            delete oppsToDelete;
        }

    }
    
}