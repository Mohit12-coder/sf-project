public class TriggerAsignSixty {

    public static void handleTaskOnStageChange(List<Opportunity> newList, Map<Id, Opportunity> oldMap){

        Set<Id> oppIds = new Set<Id>();

        // Step 1: Find Stage Changed Opportunities
        for(Opportunity opp : newList){
            if(opp.StageName != oldMap.get(opp.Id).StageName){
                oppIds.add(opp.Id);
            }
        }

        if(oppIds.isEmpty()){
            return;
        }

        // Step 2: Fetch existing Tasks
        Map<Id, List<Task>> oppTaskMap = new Map<Id, List<Task>>();

        for(Task t : [
            SELECT Id, WhatId, Description
            FROM Task
            WHERE WhatId IN :oppIds
        ]){
            if(!oppTaskMap.containsKey(t.WhatId)){
                oppTaskMap.put(t.WhatId, new List<Task>());
            }
            oppTaskMap.get(t.WhatId).add(t);
        }

        List<Task> tasksToInsert = new List<Task>();
        List<Task> tasksToUpdate = new List<Task>();

        // Step 3: Process Logic
        for(Opportunity opp : newList){

            if(!oppIds.contains(opp.Id)){
                continue;
            }

            if(!oppTaskMap.containsKey(opp.Id)){
                // No Task → Create new Task
                Task t = new Task();
                t.Subject = 'Follow up on Opportunity';
                t.WhatId = opp.Id;
                t.Description = 'Stage updated to: ' + opp.StageName;
                t.Status = 'Not Started';
                t.Priority = 'Normal';

                tasksToInsert.add(t);

            } else {
                // Task exists → Update all related Tasks
                for(Task t : oppTaskMap.get(opp.Id)){
                    t.Description = 'Stage updated to: ' + opp.StageName;
                    tasksToUpdate.add(t);
                }
            }
        }

        // Step 4: DML
        if(!tasksToInsert.isEmpty()){
            insert tasksToInsert;
        }

        if(!tasksToUpdate.isEmpty()){
            update tasksToUpdate;
        }
    }
    
}