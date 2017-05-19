// Author - Vincent Lui

public without sharing class Case_Association_Handler implements CWTrigger.Handler
{    
    public Case_Association_Handler() {
    }
      
    public void afterTrigger( CWTrigger theTrigger ) { 
        // create Reverse Case Link record
        if (theTrigger.isInsert && checkRecursive.runOnce()) {
            System.Debug('*** afterTrigger - isInsert');
            Insert_Record();
        }
        
        // delete Reverse Case Link record
        if (theTrigger.isDelete && checkRecursive.runOnce()) {
            System.Debug('*** afterTrigger - isDelete');
            Delete_Record();
        }
    }
    
    public void beforeTrigger(CWTrigger theTrigger) {
        System.Debug('*** beforeTrigger - isInsert');
        List<CaseAssociation__c> lNewCaseTrigger = Trigger.new;
        List<CaseAssociation__c> lNewCaseTemp = new List<CaseAssociation__c>();
      
        if (theTrigger.isInsert) {
           for (CaseAssociation__c zTemp:lNewCaseTrigger) {
               if (zTemp.Case__c == zTemp.Case1__c) {
                   zTemp.name.addError('Case can not be associated to itself.');   
               } else {
                   lNewCaseTemp = [SELECT Id FROM CaseAssociation__c WHERE Case__c = :zTemp.Case__c AND Case1__c = :zTemp.Case1__c];
                   if (lNewCaseTemp.Size() > 0)
                       zTemp.name.addError('Case association already exists.');
               }
           }
        }
    }
    
    private void Delete_Record() {
        List<CaseAssociation__c> lOldCaseTrigger = Trigger.old;
        List<CaseAssociation__c> lDeleteCaseTemp = new List<CaseAssociation__c>();
        List<CaseAssociation__c> lDeleteRecordId = new List<CaseAssociation__c>();
        
        // find the Reverse Case Linked record and delete it
        for (CaseAssociation__c zTemp:lOldCaseTrigger) {
            lDeleteRecordId = [select Id from CaseAssociation__c where Case__c = :zTemp.Case1__c AND Case1__c = :zTemp.Case__c];
            if (lDeleteRecordId != null) {
                for (CaseAssociation__c zId:lDeleteRecordId) {
                    lDeleteCaseTemp.Add(zId);
                    lDeleteRecordId = null;
                }
            }
        }
        
        if (lDeleteCaseTemp.size() > 0)
             delete lDeleteCaseTemp;
    }
    
    private void Insert_Record() {
        List<CaseAssociation__c> lNewCaseTrigger = Trigger.new;
        List<CaseAssociation__c> lNewCaseTemp = new List<CaseAssociation__c>();
    
        // insert reverse case link (ie. link a to b, link b to a)
        for (CaseAssociation__c zTemp : lNewCaseTrigger) {    
            if (zTemp.Case__c != null && zTemp.Case1__c != null) {
                CaseAssociation__c caNew = new CaseAssociation__c();
                caNew.Case__c = zTemp.Case1__c;
                caNew.Case1__c = zTemp.Case__c;
                lNewCaseTemp.add(caNew);
            }
        }    
        // check list size
        if (lNewCaseTemp.size() > 0)
            insert lNewCaseTemp;
    }
}