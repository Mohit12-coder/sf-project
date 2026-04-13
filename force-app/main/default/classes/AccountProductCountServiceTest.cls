@IsTest
private class AccountProductCountServiceTest {
    @TestSetup
    static void setupData() {
        // Create two Accounts
        List<Account> accts = new List<Account>{
            new Account(Name = 'Acme'),
            new Account(Name = 'Globex')
        };
        insert accts;

        // For Acme: Two Opps — one with higher Amount but fewer products
        Opportunity acmeOpp1 = new Opportunity(Name='Acme Small', StageName='Prospecting', CloseDate=Date.today().addDays(10), Amount=1000, AccountId=accts[0].Id);
        Opportunity acmeOpp2 = new Opportunity(Name='Acme Big', StageName='Prospecting', CloseDate=Date.today().addDays(20), Amount=5000, AccountId=accts[0].Id);
        insert new List<Opportunity>{ acmeOpp1, acmeOpp2 };

        // For Globex: Single Opp
        Opportunity globexOpp = new Opportunity(Name='Globex Only', StageName='Prospecting', CloseDate=Date.today().addDays(5), Amount=2000, AccountId=accts[1].Id);
        insert globexOpp;

        // Products (OpportunityLineItems) require a Pricebook, Product2, and PricebookEntry
        Pricebook2 stdPb = [SELECT Id FROM Pricebook2 WHERE IsStandard=true LIMIT 1];
        // Activate Standard Pricebook for test context
        stdPb.IsActive = true; update stdPb;
        Product2 p1 = new Product2(Name='Widget', IsActive=true);
        Product2 p2 = new Product2(Name='Gadget', IsActive=true);
        insert new List<Product2>{ p1, p2 };
        insert new List<PricebookEntry>{
            new PricebookEntry(Pricebook2Id=stdPb.Id, Product2Id=p1.Id, UnitPrice=10, IsActive=true),
            new PricebookEntry(Pricebook2Id=stdPb.Id, Product2Id=p2.Id, UnitPrice=20, IsActive=true)
        };

        // Build a map from Product2Id -> PricebookEntry for convenience
        List<PricebookEntry> pbes = [
            SELECT Id, Product2Id FROM PricebookEntry
            WHERE Product2Id IN :new Set<Id>{p1.Id, p2.Id}
            AND Pricebook2Id = :stdPb.Id AND IsActive=true
        ];
        Map<Id, PricebookEntry> pbeByProd = new Map<Id, PricebookEntry>();
        for (PricebookEntry pbe : pbes) {
            pbeByProd.put(pbe.Product2Id, pbe);
        }

        // Add 1 line to high Amount Opp (acmeOpp2), and 3 to low Amount Opp (acmeOpp1) to prove tie-break on Amount only
        insert new List<OpportunityLineItem>{
            new OpportunityLineItem(OpportunityId=acmeOpp2.Id, PricebookEntryId=pbeByProd.get(p1.Id).Id, Quantity=1, UnitPrice=10),
            new OpportunityLineItem(OpportunityId=acmeOpp1.Id, PricebookEntryId=pbeByProd.get(p1.Id).Id, Quantity=1, UnitPrice=10),
            new OpportunityLineItem(OpportunityId=acmeOpp1.Id, PricebookEntryId=pbeByProd.get(p2.Id).Id, Quantity=2, UnitPrice=20),
            new OpportunityLineItem(OpportunityId=globexOpp.Id, PricebookEntryId=pbeByProd.get(p2.Id).Id, Quantity=1, UnitPrice=20)
        };
    }

    @IsTest
    static void shouldUpdateCounts_ForHighestAmountOpp() {
        List<Account> accts = [SELECT Id FROM Account WHERE Name IN ('Acme','Globex') ORDER BY Name];
        Set<Id> accIds = new Set<Id>();
        for (Account a : accts) accIds.add(a.Id);

        Test.startTest();
        AccountProductCountService.recomputeForAccounts(accIds);
        Test.stopTest();
        List<Account> queried = [
            SELECT Name, NoOfProducts__c FROM Account WHERE Id IN :accIds
        ];
        Map<String, Account> result = new Map<String, Account>();
        for (Account a : queried) {
            result.put(a.Name, a);
        }

        Integer acmeCount = result.containsKey('Acme') && result.get('Acme').NoOfProducts__c != null ? Integer.valueOf(result.get('Acme').NoOfProducts__c.intValue()) : 0;
        Integer globexCount = result.containsKey('Globex') && result.get('Globex').NoOfProducts__c != null ? Integer.valueOf(result.get('Globex').NoOfProducts__c.intValue()) : 0;
        System.assertEquals(1, acmeCount, 'Acme should reflect products on highest-amount Opp (1 line)');
        System.assertEquals(1, globexCount, 'Globex should reflect its only Opp lines (1 line)');
    }

    @IsTest
    static void shouldSetZero_WhenNoOpps() {
        Account a = new Account(Name='No Opps');
        insert a;

        Test.startTest();
        AccountProductCountService.recomputeForAccounts(new Set<Id>{a.Id});
        Test.stopTest();

        Account refreshed = [SELECT NoOfProducts__c FROM Account WHERE Id = :a.Id];
        Integer val = refreshed.NoOfProducts__c == null ? 0 : refreshed.NoOfProducts__c.intValue();
        Assert.areEqual(0, val, 'No opportunities should set count to 0');
    }
}
