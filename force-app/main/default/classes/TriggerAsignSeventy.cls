public class TriggerAsignSeventy {

    public static void updateContactProfile(List<Account> newList, Map<Id, Account> oldMap){
        Set<Id> accIds = new Set<Id>();
        
        for(Account acc : newList){
            Account oldAcc = oldMap.get(acc.Id);
            
            if(acc.Website != null && acc.Website != oldAcc.Website){
                accIds.add(acc.Id);
            }
        }
        
        if(accIds.isEmpty()){
            return;
        }
        
        List<Contact> contacts = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId IN : accIds];
        
        Map<Id, String> accWebsiteMap = new Map<Id, String>();
        
        for(Account acc : newList){
            if(accIds.contains(acc.Id)){
                accWebsiteMap.put(acc.Id , acc.Website);
            }
        }
        
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Contact con : contacts){
            
            String website = accWebsiteMap.get(con.AccountId);
            
            String firstLetter = '';
            
            if(con.FirstName != null && con.FirstName.length() >0){
                firstLetter = con.FirstName.substring(0,1);
            }
            
            String lastName = con.LastName != null ? con.LastName : '';
			
			String profileValue = website + '/' + firstLetter + lastName;

			contactsToUpdate.add(new Contact( Id=con.Id , Profile__c = profileValue));            
        }
        
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    
	}
}