public class TriggerAsignSeven {
    
    public static void preventActiveAccountDeletion(List<Account> oldAccounts){
        
        try{
            
            for(Account acc : oldAccounts){
                
                if(acc.Status__c == 'Active'){
                    acc.addError('Active Accounts cannot be deleted.');
                }
                
            }
            
        }
        catch(Exception e){
            System.debug('Error : ' + e.getMessage());
        }
        
    }
    
}