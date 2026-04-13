public class TriggerAsignThirtySeven {

    public static void sendEmailToClientContact(List<OpportunityLineItem> newItems){
        
        Set<Id> oppIds = new Set<Id>();
        
        for(OpportunityLineItem oli : newItems){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
        }
        
        if(oppIds.isEmpty()){
            return;
        }
        
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT Id,AccountId,Account.Client_Contact__c, Account.Client_Contact__r.Email FROM Opportunity WHERE Id IN :oppIds]);
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(OpportunityLineItem oli : newItems){
            Opportunity opp = oppMap.get(oli.OpportunityId);
            
            if(opp != null && opp.Account !=null && opp.Account.Client_Contact__c != null && opp.Account.Client_Contact__r.Email !=null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(new String[]{opp.Account.Client_Contact__r.Email});
                
                mail.setSubject('New Product Added');
                
                mail.setPlainTextBody('A new product has been added to your opportunity.');
                
                emails.add(mail);
            }
        }
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
        
    }
    
}