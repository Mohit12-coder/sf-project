public class TriggerAsignTwentyThree {

    public static void createContactRelationship(List<Contact> newContacts){

        List<Contact_Relationship__c> relationshipList = new List<Contact_Relationship__c>();

        for(Contact con : newContacts){

            if(con.Contact_Relationship__c == true){

                Contact_Relationship__c rel = new Contact_Relationship__c();

                rel.Name = con.Id;

                relationshipList.add(rel);
            }

        }

        if(!relationshipList.isEmpty()){
            insert relationshipList;
        }

    }
    
}