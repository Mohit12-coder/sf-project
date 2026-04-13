public class TriggerAsignFifty {

    public static void createAsset(List<OpportunityLineItem> newItems){
        Set<Id> oppIds = new Set<Id>();
        Set<Id> pbeIds = new Set<Id>();
        
        for(OpportunityLineItem oli : newItems){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
            if(oli.PricebookEntryId != null){
                pbeIds.add(oli.PricebookEntryId);
            }
        }
        
        if(oppIds.isEmpty() || pbeIds.isEmpty()){
            return;
        }
        
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds]);
        
        Map<Id, PricebookEntry> pbeMap = new Map<Id, PricebookEntry>([SELECT Id, Product2Id FROM PricebookEntry WHERE Id IN :pbeIds]);
        
        List<Asset> assetsToInsert = new List<Asset>();
        
        for(OpportunityLineItem oli : newItems){
            Opportunity opp = oppMap.get(oli.OpportunityId);
            PricebookEntry pbe = pbeMap.get(oli.PricebookEntryId);
            
            if(opp != null && opp.AccountId !=null && pbe !=null){
                Asset ast = new Asset();
                ast.Name  = 'Asset for ' + oli.Id;
                ast.AccountId = opp.AccountId;
                ast.Product2Id = pbe.Product2Id;
                ast.Quantity = oli.Quantity;
                
                assetsToInsert.add(ast);
            }
        }
        if(!assetsToInsert.isEmpty()){
            insert assetsToInsert;
        }
    }
    
}