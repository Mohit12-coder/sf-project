public class TriggerAsignThirtyTwo {

    public static void setSerialNumber(List<OpportunityLineItem> newItems){
        Set<Id> oppIds = new Set<Id>();
        
        for(OpportunityLineItem oli : newItems){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
        }
        
        if(OppIds.isEmpty()){
            return;
        }
        
        Map<Id,Integer> maxSerialMap = new Map<Id, Integer>();
        
        for(AggregateResult ar : [SELECT OpportunityId oppId, MAX(Serial_No__c) maxSerial FROM OpportunityLineItem WHERE OpportunityId IN : oppIds GROUP BY OpportunityId]){
            Integer maxSerial = 0;
            if(ar.get('maxSerial') != null){
                maxSerial = Integer.valueOf((String)ar.get('maxSerial'));
            }
            maxSerialMap.put((Id)ar.get('oppId'), maxSerial);
        }
        
        for(OpportunityLineItem oli : newItems){
            Integer currentMax = maxSerialMap.containsKey(oli.OpportunityId) ? maxSerialMap.get(oli.OpportunityId) : 0;
            currentMax++;
            
            oli.Serial_No__c = String.valueOf(currentMax);
            
            maxSerialMap.put(oli.OpportunityId, currentMax);
        }
        
    }
    
}