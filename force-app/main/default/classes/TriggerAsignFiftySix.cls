public class TriggerAsignFiftySix {
    public static void validateProductFamily(List<OpportunityLineItem> oliList){

        Set<Id> oppIds = new Set<Id>();
        Set<Id> pbeIds = new Set<Id>();

        // Collect Ids
        for(OpportunityLineItem oli : oliList){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
            if(oli.PricebookEntryId != null){
                pbeIds.add(oli.PricebookEntryId);
            }
        }

        // Get Opportunity Product Type
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
            [SELECT Id, Product_Type__c FROM Opportunity WHERE Id IN :oppIds]
        );

        // Get Product Family via PricebookEntry
        Map<Id, PricebookEntry> pbeMap = new Map<Id, PricebookEntry>(
            [SELECT Id, Product2.Family FROM PricebookEntry WHERE Id IN :pbeIds]
        );

        // Validation Logic
        for(OpportunityLineItem oli : oliList){

            Opportunity opp = oppMap.get(oli.OpportunityId);
            PricebookEntry pbe = pbeMap.get(oli.PricebookEntryId);

            if(opp != null && pbe != null){

                String oppType = opp.Product_Type__c;
                String productFamily = pbe.Product2.Family;

                // Check mismatch
                if(oppType != null && productFamily != null && oppType != productFamily){
                    oli.addError('The Product family does not match.');
                }
            }
        }
    }
}