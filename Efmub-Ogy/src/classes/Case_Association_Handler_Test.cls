// Author: Vincent Lui

@isTest
public class Case_Association_Handler_Test {
    static testMethod void Case_Association_Handler_Test()
    {
        CWTest testResults = new CWTest( 'testCheckRecursive' );
        CaseAssociation__c ca1 = new CaseAssociation__c();
        ca1.Case__c = '5000S000001EIcH';
        ca1.Case1__c = '5000S000001EK3J';

        testResults.startTest();        
        insert ca1;
        
        checkRecursive.SetRunFlag(true);
        
        // CaseAssociation__c ca2 = new CaseAssociation__c();
        // ca2.Case__c = '5000S000001EIcH';
        // ca2.Case1__c = '5000S000001EK3J';
        // insert ca2;
        
        checkRecursive.SetRunFlag(true);
        
        CaseAssociation__c ca3 = new CaseAssociation__c();
        ca3 = [SELECT Id FROM CaseAssociation__c WHERE Case__c = '5000S000001EIcH' AND Case1__c = '5000S000001EK3J'];
        delete ca3;
        
        testResults.stopTest();
        testResults.report();
  }
}