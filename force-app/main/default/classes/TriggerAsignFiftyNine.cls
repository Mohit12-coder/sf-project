public class TriggerAsignFiftyNine {

    public static void automateAssetCreation(List<OpportunityLineItem> oliList){
        
        Set<Id> oppIds = new Set<Id>();
        
        for(OpportunityLineItem oli : oliList){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
        }
        
        if(oppIds.isEmpty()){
            return;
        }
        
        Map<Id,Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, AccountId FROM Opportunity WHERE ID IN :oppIds]);
        
        List<Asset> assetsToInsert = new List<Asset>();
        
        For(OpportunityLineItem oli : oliList){
            Opportunity opp = oppMap.get(oli.OpportunityId);
            
            if(opp != null && opp.AccountId != null){
                Asset ast = new Asset();
                ast.AccountId = opp.AccountId;
                ast.Product2Id= oli.Id;
                ast.Quantity = oli.Quantity;
                ast.Price = oli.UnitPrice;
                
                assetsToInsert.add(ast);
            }
        }
        
        if(!assetsToInsert.isEmpty()){
            insert assetsToInsert;
        }
        
    }
    
}