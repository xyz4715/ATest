/*******************************************************//**

@class		CWExceptionTest

@brief		Tests for CW Core Error Handling Class

	The CWExceptionTest class contains the test methods for the
	CWException class.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-09-04	LiquidHub.GHA
	Created.
@version	2014-11-21	LiquidHub.GHA
	Increased coverage to 100%.

@see		CWException

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
public class CWExceptionTest
{
	public static testMethod void testCWException()
	{
		CWTest	testResult	= new CWTest( 'CWExceptionTest::testCWException' );

		CWException.setErrorHandler( 'CWException.ThrowError' );
		try { CWException.error();										} catch ( Exception theException ) {}
		try { CWException.error( (Exception) null );					} catch ( Exception theException ) {}
		try { CWException.error( (Object) null );						} catch ( Exception theException ) {}
		try { CWException.errorNull();									} catch ( Exception theException ) {}
		try { CWException.errorNull( (Exception) null );				} catch ( Exception theException ) {}
		try { CWException.errorNull( (Object) null );					} catch ( Exception theException ) {}
		try { CWException.errorNull( (Object) null, (Exception) null );	} catch ( Exception theException ) {}

		CWException.setErrorHandler( 'CWException.IgnoreError' );
		try { CWException.errorNull();									} catch ( Exception theException ) {}
		try { CWException.errorNull( (Exception) null );				} catch ( Exception theException ) {}
		try { CWException.errorNull( (Object) null );					} catch ( Exception theException ) {}
		try { CWException.errorNull( (Object) null, (Exception) null );	} catch ( Exception theException ) {}

		CWException.setErrorHandler( 'CWException.ThrowError' );
		try { CWException.error(); } catch ( Exception theException ) {}

		CWException.setErrorHandler( 'CWException.UseDebugLog' );
		try { CWException.error(); } catch ( Exception theException ) {}

		CWException.setErrorHandler( 'CWException.UseFireLog' );
		try { CWException.error(); } catch ( Exception theException ) {}

		CWException.setErrorHandler( 'CWException.IgnoreError' );
		try { CWException.error(); } catch ( Exception theException ) {}

		CWException.restoreErrorHandler();
		CWException.resetErrorHandler();

		CWException theException = new CWException( new CWException( 'Test', new CWException( 'Test' ) ) );
		CWException.ErrorHandler	errorHandler = CWException.newErrorHandler( 'Bogus Error Handler' );
									errorHandler = CWException.newErrorHandler( (String) null );

		testResult.report();
	}
}