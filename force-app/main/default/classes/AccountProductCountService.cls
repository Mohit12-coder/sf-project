/**
 * Computes and updates Account.NoOfProducts__c to reflect the count of products
 * on the Account's Opportunity that has the highest Amount.
 *
 * Assumptions (can be adjusted if needed):
 * - Products are standard OpportunityLineItem records.
 * - All Opportunities are considered regardless of Stage.
 * - Tie-breaker for equal highest Amount: pick the most recently modified Opportunity.
 * - Target field on Account is a Number field named NoOfProducts__c.
 */
public with sharing class AccountProductCountService {
    /**
     * Recalculate product counts for the provided Account Ids and update the Accounts if needed.
     * @param accountIds Set of Account Ids to recompute.
     */
    public static void recomputeForAccounts(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        // Find the highest-amount Opportunity per Account using a windowed aggregate style via subquery ordering.
        // Approach: query all candidate Opps for these Accounts ordered by Amount DESC, LastModifiedDate DESC.
        // We'll pick the first per Account in Apex, then count OLI for that Opp.
        List<Opportunity> opps = [
            SELECT Id, AccountId, Amount, LastModifiedDate
            FROM Opportunity
            WHERE AccountId IN :accountIds
            ORDER BY AccountId, Amount DESC NULLS LAST, LastModifiedDate DESC, Id ASC
        ];

        // Choose top per Account according to the ordering above.
        Map<Id, Opportunity> topOppByAccount = new Map<Id, Opportunity>();
        for (Opportunity o : opps) {
            if (!topOppByAccount.containsKey(o.AccountId)) {
                topOppByAccount.put(o.AccountId, o);
            }
        }

        if (topOppByAccount.isEmpty()) {
            // No opportunities for these accounts; set count to 0
            List<Account> toZero = new List<Account>();
            for (Id accId : accountIds) {
                toZero.add(new Account(Id = accId, NoOfProducts__c = 0));
            }
            if (!toZero.isEmpty()) update toZero;
            return;
        }

        Set<Id> topOppIds = new Set<Id>();
        for (Opportunity sel : topOppByAccount.values()) {
            topOppIds.add(sel.Id);
        }

        // Count OpportunityLineItems per selected Opportunity using aggregate SOQL.
        Map<Id, Integer> oliCountByOpp = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT OpportunityId oppId, COUNT(Id) cnt
            FROM OpportunityLineItem
            WHERE OpportunityId IN :topOppIds
            GROUP BY OpportunityId
        ]) {
            oliCountByOpp.put((Id)ar.get('oppId'), (Integer)ar.get('cnt'));
        }

        // Prepare Account updates, only when value changes.
        Map<Id, Account> existingAccounts = new Map<Id, Account>([
            SELECT Id, NoOfProducts__c
            FROM Account
            WHERE Id IN :accountIds
        ]);

        List<Account> updates = new List<Account>();
        for (Id accId : accountIds) {
            Integer countVal = 0;
            Opportunity sel = topOppByAccount.get(accId);
            if (sel != null) {
                countVal = oliCountByOpp.containsKey(sel.Id) ? oliCountByOpp.get(sel.Id) : 0;
            }

            Account existing = existingAccounts.get(accId);
            if (existing == null) continue;
            // Only update when changed
            if ((existing.NoOfProducts__c == null && countVal != 0) ||
                (existing.NoOfProducts__c != null && Integer.valueOf(existing.NoOfProducts__c.intValue()) != countVal)) {
                updates.add(new Account(Id = accId, NoOfProducts__c = countVal));
            }
        }

        if (!updates.isEmpty()) update updates;
    }
}
