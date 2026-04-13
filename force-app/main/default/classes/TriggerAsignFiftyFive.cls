public class TriggerAsignFiftyFive {

    public static void createFollowUpTasks(List<Lead> newLeads, Map<Id, Lead> oldMap){

        List<Task> taskList = new List<Task>();

        for(Lead l : newLeads){

            Lead oldLead = oldMap.get(l.Id);

            // Check if Lead is just converted
            if(l.IsConverted && !oldLead.IsConverted){

                Task t = new Task();

                t.Subject = 'Follow Up with Converted Lead';
                t.OwnerId = l.OwnerId;
                t.Status = 'Not Started';
                t.Priority = 'Normal';

                // Link with converted records
                if(l.ConvertedContactId != null){
                    t.WhoId = l.ConvertedContactId;
                }

                if(l.ConvertedAccountId != null){
                    t.WhatId = l.ConvertedAccountId;
                }

                // Description
                t.Description = 'Lead Converted Successfully\n'
                    + 'Name: ' + l.Name + '\n'
                    + 'Company: ' + l.Company + '\n'
                    + 'Please follow up with the customer.';

                // Optional: Due Date
                t.ActivityDate = System.today().addDays(2);

                taskList.add(t);
            }
        }

        if(!taskList.isEmpty()){
            insert taskList;
        }
    }
    
}