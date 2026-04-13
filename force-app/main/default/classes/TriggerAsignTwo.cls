public class TriggerAsignTwo {

    public static void setLeadRating(List<Lead> leadList){
        
        if(leadList == null || leadList.isEmpty()){
            return;
        }
        
        for(Lead ld : leadList){
            
            try{
                
                if(ld.LeadSource != null && ld.LeadSource == 'Web'){
                    ld.Rating='Cold';
                }
                else{
                    ld.Rating ='Hot';
                }
                
            }
            catch(NullPointerException e){
                System.debug('Null Pointer Exception : ' + e.getMessage());
            }
            
        }
        
    }
    
}