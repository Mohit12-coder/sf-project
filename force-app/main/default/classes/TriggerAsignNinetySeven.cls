public class TriggerAsignNinetySeven {

    public static void preventDuplicateLeads(List<Lead> newLeads){

        Set<String> leadNames = new Set<String>();

        // Step 1: Prepare Name Keys
        for(Lead l : newLeads){
            if(l.LastName != null){
                String nameKey = (l.FirstName != null ? l.FirstName : '') 
                                 + l.LastName;
                leadNames.add(nameKey.toLowerCase());
            }
        }

        if(leadNames.isEmpty()){
            return;
        }

        // Step 2: Fetch existing Leads
        List<Lead> existingLeads = [
            SELECT Id, FirstName, LastName
            FROM Lead
            WHERE LastName != null
        ];

        Set<String> existingNames = new Set<String>();

        for(Lead l : existingLeads){
            String nameKey = (l.FirstName != null ? l.FirstName : '') + l.LastName;
            existingNames.add(nameKey.toLowerCase());
        }

        // Step 3: Check duplicates
        Set<String> seenNames = new Set<String>();

        for(Lead l : newLeads){

            String nameKey = (l.FirstName != null ? l.FirstName : '') + l.LastName;
            nameKey = nameKey.toLowerCase();

            // Duplicate in DB OR within same batch
            if(existingNames.contains(nameKey) || seenNames.contains(nameKey)){
                l.addError('Duplicate Lead Name is not allowed');
            }

            seenNames.add(nameKey);
        }
    }
    
}