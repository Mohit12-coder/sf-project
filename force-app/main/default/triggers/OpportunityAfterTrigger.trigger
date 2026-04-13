trigger OpportunityAfterTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUndelete) {
        for (Opportunity o : Trigger.new) if (o.AccountId != null) accountIds.add(o.AccountId);
    }
    if (Trigger.isUpdate) {
        for (Opportunity o : Trigger.new) if (o.AccountId != null) accountIds.add(o.AccountId);
        for (Opportunity o : Trigger.old) if (o.AccountId != null) accountIds.add(o.AccountId);
    }
    if (Trigger.isDelete) {
        for (Opportunity o : Trigger.old) if (o.AccountId != null) accountIds.add(o.AccountId);
    }

    if (!accountIds.isEmpty()) {
        AccountProductCountService.recomputeForAccounts(accountIds);
    }
}
