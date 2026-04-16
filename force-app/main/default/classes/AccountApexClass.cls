public class AccountApexClass {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount(){
        List<Account> accList = [SELECT id, Name, Phone FROM Account];
        
        return accList;
    }
    
}