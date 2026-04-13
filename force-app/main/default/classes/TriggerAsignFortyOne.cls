public class TriggerAsignFortyOne {

    public static void createQuote(List<OpportunityLineItem> newItems){

        Set<Id> oppIds = new Set<Id>();

        for(OpportunityLineItem oli : newItems){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
        }

        if(oppIds.isEmpty()){
            return;
        }

        // Check existing Quotes to avoid duplicates
        Set<Id> oppWithQuotes = new Set<Id>();

        for(Quote q : [
            SELECT Id, OpportunityId
            FROM Quote
            WHERE OpportunityId IN :oppIds
        ]){
            oppWithQuotes.add(q.OpportunityId);
        }

        List<Quote> quotesToInsert = new List<Quote>();

        for(Id oppId : oppIds){

            if(!oppWithQuotes.contains(oppId)){

                Quote q = new Quote();
                q.Name = 'Auto Quote';
                q.OpportunityId = oppId;
                q.Status = 'Draft';

                quotesToInsert.add(q);
            }

        }

        if(!quotesToInsert.isEmpty()){
            insert quotesToInsert;
        }

    }
    
}