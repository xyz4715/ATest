/*******************************************************//**

@class      CaseContactHandlerTest

@brief      Test Class for the CaseContactHandler Class

@author     Glyn Anderson (LiquidHub.GHA)

@version    2015-12-01  LiquidHub.GHA
    Created.

@see        CaseContactHandler
@see        CaseContact (trigger)

    (c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class CaseContactHandlerTest
{
    public static testMethod void testCaseContactHandler()
    {
        CWTest testResults = new CWTest( 'testCaseContactHandler' );

        Account account = new Account
        (   Name        = 'Test Account'
        );
        insert account;

        Contact contact = new Contact
        (   LastName    = 'Test',
            AccountId   = account.Id
        );
        insert contact;

        Case    theCase = new Case
        (   ContactId   = contact.Id
        );
        insert theCase;

       // Case_Contact__c caseContact = new Case_Contact__c
     //   (   Case__c     = theCase.Id,
       //     Contact__c  = contact.Id
       // );

        testResults.startTest();

        //insert caseContact;

        //  test code goes here...

        testResults.stopTest();
        testResults.report();
    }
}