public with sharing class OpportunityCurrencyService {

    public static void handleOpportunityCurrency( List<Opportunity> newList, Map<Id, Opportunity> oldMap, Boolean isInsert, Boolean isUpdate ) {

        Set<Id> oppIds = new Set<Id>();

        for (Opportunity opp : newList) {
            Boolean isRun = false;

            if (isInsert) {
                isRun = true;
            }
           
            if (isUpdate) {
                if (opp.Amount != oldMap.get(opp.Id).Amount || opp.Currency_Type__c != oldMap.get(opp.Id).Currency_Type__c) {
                    isRun = true;
                }
            }

            if (isRun && opp.Amount != null && String.isNotBlank(opp.Currency_Type__c)) {
                oppIds.add(opp.Id);
            }
        }

        if (!oppIds.isEmpty()) {
            updateConvertedAmounts(new List<Id>(oppIds));
        }
    }

    @future(callout=true)
    public static void updateConvertedAmounts(List<Id> oppIds) {

        List<Opportunity> oppList = [ SELECT Id, Amount, Currency_Type__c FROM Opportunity WHERE Id IN :oppIds ];

        Map<String, Decimal> rates = getUsdRatesMap();

        List<Opportunity> updateList = new List<Opportunity>();

        for (Opportunity opp : oppList) {

            String currencyc = opp.Currency_Type__c;

            if (rates.containsKey(currencyc)) {

                Decimal rate = rates.get(currencyc);
                Decimal converted = opp.Amount * rate;

                Opportunity obj = new Opportunity();
                obj.Id = opp.Id;
                obj.Converted_Amount__c = converted.setScale(2);

                updateList.add(obj);
            }
        }

        if (!updateList.isEmpty()) {
            update updateList;
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<Map<String, Object>> getUsdRates() {
    
        Map<String, Decimal> rates = getUsdRatesMap();
    
        List<Map<String, Object>> data = new List<Map<String, Object>>();
    
        for (String currencyName : rates.keySet()) {
    
            Map<String, Object> row = new Map<String, Object>();
            row.put('currencyCode', currencyName);
            row.put('rateAgainstUSD', rates.get(currencyName));
    
            data.add(row);
        }
    
        return data;
    }

    public static Map<String, Decimal> getUsdRatesMap() {

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
        
        req.setEndpoint('https://v6.exchangerate-api.com/v6/c201f3082166c2b6f6012e80/latest/USD');

        HttpResponse res = http.send(req);

        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        Map<String, Object> apiRates = (Map<String, Object>) body.get('conversion_rates');

        Map<String, Decimal> finalRates = new Map<String, Decimal>();

        for (String currencyName : apiRates.keySet()) {
            finalRates.put( currencyName, Decimal.valueOf(String.valueOf(apiRates.get(currencyName))));
        }
        
        return finalRates;
    }
}