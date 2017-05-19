// Author: Vincent Lui

@isTest
public class checkRecursiveTest {
    static testMethod void checkRecursiveTest()
    {
        CWTest testResults = new CWTest( 'testCheckRecursive' );
        testResults.startTest();
        
        checkRecursive.RunOnce();
        
        testResults.stopTest();
        testResults.report();
  }
}