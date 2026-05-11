public without sharing class AssetPortalController {

    @AuraEnabled(cacheable=true)
    public static List<Asset> getProducts() {
        return getAllAssets();
    }

    private static List<Asset> getAllAssets() {

        Id contactId = getLoggedInContactId();
    
        if (contactId == null) {
            return [SELECT Id, Name, Status, Price, PurchaseDate, Warranty_End_Date__c, Active_Until__c, Product2.Name, Product2.RecordType.Name, ContactId FROM Asset ORDER BY CreatedDate DESC ];
        }

        return [SELECT Id, Name, Status, Price, PurchaseDate, Warranty_End_Date__c, Active_Until__c, Product2.Name, Product2.RecordType.Name, ContactId FROM Asset WHERE ContactId = :contactId ORDER BY CreatedDate DESC];
    }

    private static Id getLoggedInContactId() {
        User u = [ SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return u.ContactId;
    }

    @AuraEnabled
    public static void extendWarranty(Id assetId, Integer months) {

        Asset a = [ SELECT Id, Warranty_End_Date__c FROM Asset WHERE Id = :assetId LIMIT 1];

        Date baseDate = a.Warranty_End_Date__c;

        if(baseDate == null || baseDate < Date.today()){
            baseDate = Date.today();
        }
        a.Warranty_End_Date__c = baseDate.addMonths(months);
        update a;
    }

    @AuraEnabled
    public static void activateService(Id assetId, Integer months) {

        Asset a = [ SELECT Id, Active_Until__c, Status FROM Asset WHERE Id = :assetId LIMIT 1 ];

        Date baseDate = a.Active_Until__c;

        if(baseDate == null || baseDate < Date.today()){
            baseDate = Date.today();
        }

        a.Active_Until__c = baseDate.addMonths(months);
        a.Status = 'Active';
        update a;
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getMyCases() {

        Id contactId = getLoggedInContactId();

        if(contactId == null){
            return [SELECT Id, CaseNumber, Subject, Priority, Status, CreatedDate, Asset.Name FROM Case ORDER BY CreatedDate DESC ];
        }

        return [SELECT Id, CaseNumber, Subject, Priority, Status, CreatedDate, Asset.Name FROM Case WHERE ContactId = :contactId ORDER BY CreatedDate DESC];
    }

    @AuraEnabled
    public static String createCase( Id assetId, String subject, String description, String priority) {
        try{
            Asset a = [ SELECT Id, ContactId, AccountId FROM Asset WHERE Id = :assetId LIMIT 1];

            Case c = new Case();
            c.Subject = subject;
            c.Description = description;
            c.Priority = priority;
            c.Status = 'New';
            c.Origin = 'Web';
            c.AssetId = a.Id;
            c.ContactId = a.ContactId;
            c.AccountId = a.AccountId;

            insert c;

            c = [SELECT CaseNumber FROM Case WHERE Id = :c.Id];
            
            return c.CaseNumber;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Case getCaseDetail(String caseNumber) {

        return [SELECT Id, CaseNumber, Subject,Status, Priority, Description,CreatedDate, LastModifiedDate, Asset.Name FROM Case WHERE CaseNumber = :caseNumber LIMIT 1 ];
    }

}