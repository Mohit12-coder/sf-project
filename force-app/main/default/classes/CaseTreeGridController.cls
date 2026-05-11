public with sharing class CaseTreeGridController {
    
    public class CaseTreeNode{
        @AuraEnabled public Id id;
        @AuraEnabled public String caseNumber;
        @AuraEnabled public String priority;
        @AuraEnabled public String origin;
        @AuraEnabled public String status;
        @AuraEnabled public List<CaseTreeNode> _children;

        public CaseTreeNode(Case c){
            
        }
    }

}