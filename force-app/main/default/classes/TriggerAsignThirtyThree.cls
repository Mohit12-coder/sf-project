public class TriggerAsignThirtyThree {

    public static void preventDuplicateContacts(List<Contact> newContacts){
        
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        
        for(Contact con : newContacts){
            if(con.Email != null){
                emailSet.add(con.Email);
            }
            if(con.Phone != null){
                phoneSet.add(con.Phone);
            }
        }
        
        if(emailSet.isEmpty() && phoneSet.isEmpty()){
            return;
        }
        
        List<Contact> existingContacts = [SELECT Id, Email, Phone FROM Contact WHERE Email IN : emailSet OR Phone IN : phoneSet];
        
        Map<String,Id> emailMap = new Map<String,Id>();
        Map<String,Id> phoneMap = new Map<String,Id>();
        
        for(Contact con : existingContacts){
            if(con.Email != null){
                emailMap.put(con.Email, con.Id);
            }
            if(con.Phone != null){
                phoneMap.put(con.Phone, con.Id);
            }
        }
        
        for(Contact con : newContacts){
            if(con.Email != null && emailMap.containsKey(con.Email)){
                if(con.Id == null || con.Id != emailmap.get(con.Email)){
                    con.addError('Duplicate Contact Email Found. ');
                }
            }
            if(con.Phone != null && phoneMap.containsKey(con.Phone)){
                if(con.Id == null || con.Id != phoneMap.get(con.Phone)){
                    con.addError('Duplicate Contact Phone found.');
                }
            }
        }
        
    }
    
}