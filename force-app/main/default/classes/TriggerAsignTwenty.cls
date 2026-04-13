public class TriggerAsignTwenty {

    public static void preventDuplicateEmail(List<Lead> newLeads, Map<Id,Lead> oldMap){

        Set<String> emailSet = new Set<String>();
        Map<String,Integer> batchEmailCount = new Map<String,Integer>();

        for(Lead ld : newLeads){

            if(ld.Email != null){

                emailSet.add(ld.Email);

                if(batchEmailCount.containsKey(ld.Email)){
                    batchEmailCount.put(ld.Email, batchEmailCount.get(ld.Email) + 1);
                }
                else{
                    batchEmailCount.put(ld.Email, 1);
                }

            }

        }

        for(Lead ld : newLeads){

            if(ld.Email != null && batchEmailCount.get(ld.Email) > 1){
                ld.addError('Duplicate Email found in the same batch.');
            }

        }

        if(emailSet.isEmpty()){
            return;
        }

        Map<String,Id> existingLeadEmails = new Map<String,Id>();

        for(Lead ld : [
            SELECT Id, Email
            FROM Lead
            WHERE Email IN :emailSet
        ]){
            existingLeadEmails.put(ld.Email, ld.Id);
        }

        for(Lead ld : newLeads){

            if(ld.Email != null && existingLeadEmails.containsKey(ld.Email)){

                if(ld.Id == null || ld.Id != existingLeadEmails.get(ld.Email)){
                    ld.addError('Lead with this Email already exists.');
                }

            }

        }

    }
    
}