trigger OpportunityLineItemAfterTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete) {
    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUndelete) {
        for (OpportunityLineItem oli : Trigger.new) if (oli.OpportunityId != null) accountIds.add(oli.Opportunity.AccountId);
    }
    if (Trigger.isUpdate) {
        for (OpportunityLineItem oli : Trigger.new) if (oli.OpportunityId != null) accountIds.add(oli.Opportunity.AccountId);
        for (OpportunityLineItem oli : Trigger.old) if (oli.OpportunityId != null) accountIds.add(oli.Opportunity.AccountId);
    }
    if (Trigger.isDelete) {
        for (OpportunityLineItem oli : Trigger.old) if (oli.OpportunityId != null) accountIds.add(oli.Opportunity.AccountId);
    }

    // Fallback for cases where parent Opportunity wasn't loaded in context
    if (!accountIds.isEmpty()) {
        AccountProductCountService.recomputeForAccounts(accountIds);
        return;
    }

    // If AccountId not present due to relationship not loaded, resolve via query
    Set<Id> oppIds = new Set<Id>();
    if (Trigger.isInsert || Trigger.isUndelete || Trigger.isUpdate) {
        for (OpportunityLineItem oli : Trigger.new) if (oli.OpportunityId != null) oppIds.add(oli.OpportunityId);
    }
    if (Trigger.isDelete || Trigger.isUpdate) {
        for (OpportunityLineItem oli : Trigger.old) if (oli.OpportunityId != null) oppIds.add(oli.OpportunityId);
    }
    if (!oppIds.isEmpty()) {
        for (Opportunity o : [SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds]) {
            if (o.AccountId != null) accountIds.add(o.AccountId);
        }
    }
    if (!accountIds.isEmpty()) AccountProductCountService.recomputeForAccounts(accountIds);
}
