public class TriggerAsignOne {
    
    public static void setDefaultValues(List<Case> caseList){
        
        if(caseList == null  || caselist.isEmpty()){
            return;
        }
        
        for(Case c : caseList){
            
            try{
                
                if(c.Origin == 'Email'){
                    c.Status ='New';
                    c.Priority = 'Medium';
                }
                
            }
            
            catch(NullPointerException e){
                
                System.debug('Null Pointer Exception : ' + e.getMessage());
                
            }
            
        }
        
    }
    
}