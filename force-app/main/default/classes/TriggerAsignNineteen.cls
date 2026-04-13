public class TriggerAsignNineteen {

    public static void preventTaskDeletion(List<Task> oldTasks){

        // Get current user's profile
        String profileName = [
            SELECT Name
            FROM Profile
            WHERE Id = :UserInfo.getProfileId()
        ].Name;

        if(profileName != 'System Administrator'){

            for(Task t : oldTasks){
                t.addError('Only System Administrator can delete Task records.');
            }

        }

    }
    
}