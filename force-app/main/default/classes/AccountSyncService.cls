public class AccountSyncService {
    
    public static void cloneAccount(List<Account> accList, Map<Id,Account>oldMap){
        
        List<Id> accIds = new List<Id>();

        for (Account acc : accList) {
            if (Trigger.isInsert) {
                accIds.add(acc.Id);
            } else {
                Account oldAcc = oldMap.get(acc.Id);
    
                if (acc.Name != oldAcc.Name || acc.Phone != oldAcc.Phone || acc.Website != oldAcc.Website || acc.Industry != oldAcc.Industry || acc.BillingCity != oldAcc.BillingCity || acc.BillingCountry != oldAcc.BillingCountry) {
                    accIds.add(acc.Id);
                }
            }
        }
    
        if (!accIds.isEmpty()) {
            AccountSyncService.syncAccounts(accIds);
        }
        
    }

    @future(callout=true)
    public static void syncAccounts(List<Id> accountIds){
        
        List<Account> accList = [SELECT Id, Name, Phone, Website, Industry, BillingCity,BillingCountry, Target_Account_Id__c FROM Account WHERE Id IN :accountIds];
        
        List<Account> accToUpdate = new List<Account>();
        
        for(Account acc : accList){
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SalesforceConnectedAppNamedCredential/services/apexrest/accountsync');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            
            Map<String, Object> accMap = new Map<String, Object>();
            accMap.put('sourceId', acc.Id);
            accMap.put('name', acc.Name);
            accMap.put('phone', acc.Phone);
            accMap.put('website', acc.Website);
            accMap.put('industry', acc.Industry);
            accMap.put('billingCity', acc.BillingCity);
            accMap.put('billingCountry', acc.BillingCountry);

            req.setBody(JSON.serialize(accMap));
            
            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                acc.Target_Account_Id__c = res.getBody();
                accToUpdate.add(acc);
            }
            
        }
        if (!accToUpdate.isEmpty()) {
            update accToUpdate;
        }
        
    }
    
}