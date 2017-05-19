/*******************************************************//**

@class		CWTest

@brief		CW Core Test Support Class

	This class is used by test methods to accumulate and report
	test results.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-01-29	LiquidHub.GHA
	Created.
@version	2014-03-05	LiquidHub.GHA
	Added the TestErrorHandler class and the 'startTest' and
	'stopTest' methods.
@version	2014-03-08	LiquidHub.GHA
	Added 'lastErrorStartsWith' and 'clearErrors' methods.
@version	2014-10-22	LiquidHub.GHA
	Moved test method into its own class, CWTestTest.  CWTest
	is no longer annotated '@isTest'.  Added all the exception
	testing methods.

@see		CWTestTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWTest
{
	/*******************************************************
				TestResult class

	This class records the result of a single assertion test.
	*******************************************************/

	private class TestResult
	{
		public String	testName;			//	(optional) an identifier for the assertion
		public Boolean	testSuccess;		//	the result of the assertion
		public String	testMessage;		//	(optional) message used if the assertion failed
		public Object	expectedValue;		//	(optional) the value that was expected
		public Object	actualValue;		//	(optional) the actual value returned

		/***************************************************
					TestResult constructors

		These constructors take a name (which can be null)
		and a message (which can be null, and is only saved
		if the assertion fails).  The first constructor
		takes the success value of the assertion directly.
		The second constructor determines the success value
		by comparing the expected and actual values.
		***************************************************/

		public TestResult( String name, Boolean success, String message )
		{
			testName	= name;
			testSuccess	= success;

			if ( !testSuccess )
			{
				testMessage	= message;
			}
		}

		public TestResult( String name, Object expected, Object actual, String message )
		{
			this( name, expected == actual, message );

			if ( !testSuccess )
			{
				expectedValue	= expected;
				actualValue		= actual;
			}
		}

		/***************************************************
					report method

		This method returns a report for this test result.
		If the assertion passed, the report is a single line.
		If the assertion failed, the report will include the
		message, expected value and actual value if available.
		***************************************************/

		public String report()
		{
			List<String> list_Reports	= new List<String>();

			list_Reports.add( testSuccess ? 'Passed: ' : 'Failed: ' );
			list_Reports.add( String.isBlank( testName ) ? 'Unnamed Test' : testName );
			list_Reports.add( '\n' );

			if ( String.isNotBlank( testMessage ) )
			{
				list_Reports.add( '- ' + testMessage.trim() + '\n' );
			}

			if ( expectedValue != null || actualValue != null )
			{
				list_Reports.add( '-   Expected: ' + String.valueOf( expectedValue ) + '\n' );
				list_Reports.add( '-   Actual:   ' + String.valueOf( actualValue   ) + '\n' );
			}

			return CWString.join( list_Reports );
		}
	}

	/*******************************************************
				TestErrorHandler class

	This class serves as the CWFramework error handler during
	test execution.
	*******************************************************/

	private class TestErrorHandler extends CWException.ErrorHandler
	{
		private List<String> errors;

		public TestErrorHandler()
		{
			errors = new List<String>();
		}

		public override Boolean handleError( Object errorObject, Exception cause )
		{
			List<String> errorStrings = new List<String>();
			errorStrings.add( errorObject != null ? String.valueOf( errorObject ) : 'TestErrorHandler' );
			if ( cause != null ) errorStrings.add( String.valueOf( cause ) );
			errors.add( CWString.join( errorStrings, '\n' ) );
			return false;
		}

		public List<String> getErrors()
		{
			return errors;
		}

		public void clearErrors()
		{
			errors.clear();
		}
	}

	/*******************************************************
				CWTest members
	*******************************************************/

	private String				testMethodName;		//	(optional) a name for this test method
	private List<TestResult>	list_Results;		//	the list of test results
	private Boolean				testMethodSuccess;	//	a cumulative result: any failure makes this false
	private TestErrorHandler	testErrorHandler;

	@TestVisible
	private Boolean				testingThis;		//	true if we're testing this CWTest object

	/*******************************************************
				CWTest constructors

	The constructor takes an optional test method name.
	*******************************************************/

	public CWTest( String name )
	{
		testMethodName		= name;
		list_Results		= new List<TestResult>();
		testMethodSuccess	= true;
		testErrorHandler	= new TestErrorHandler();
		testingThis			= false;
	}

	public CWTest()
	{
		this( (String) null );
	}

	/*******************************************************
				startTest method

	Calls Test.startTest and installs the test ErrorHandler
	*******************************************************/

	public void startTest()
	{
		Test.startTest();
		CWException.setErrorHandler( testErrorHandler );
	}

	/*******************************************************
				startTest method

	Calls Test.stopTest and installs the test ErrorHandler
	*******************************************************/

	public void stopTest()
	{
		Test.stopTest();
		CWException.restoreErrorHandler();
	}

	/*******************************************************
				lastErrorStartsWith method

	Returns true if the most recent error start with the given
	string.
	*******************************************************/

	public Boolean lastErrorStartsWith( String errorStart )
	{
		List<String> errors = testErrorHandler.getErrors();
		return
			errors != null
		&&	errorStart != null
		&&	errors.get( errors.size() - 1 ).startsWith( errorStart );
	}

	/*******************************************************
				clearErrors method

	Clears errors from the test ErrorHandler.
	*******************************************************/

	public void clearErrors()
	{
		testErrorHandler.clearErrors();
	}

	/*******************************************************
				checkErrors method

	Returns true if the test ErrorHandler has errors.
	*******************************************************/

	public Boolean checkErrors()
	{
		return !testErrorHandler.getErrors().isEmpty();
	}

	/*******************************************************
				getErrorString method

	Returns the concatenated error string from the test ErrorHandler.
	*******************************************************/

	public String getErrorString()
	{
		return CWString.join( testErrorHandler.getErrors(), '\n' );
	}

	/*******************************************************
				assert methods

	These methods take:
		a name (which can be null) that identifies the assertion;
		a success value for the assertion; OR
		expected and actual values, which are compared;
		an optional message to be used if the assertion fails.
	*******************************************************/

	public Boolean assert( String name, Boolean success, String message )
	{
		list_Results.add( new TestResult( name, success, message ) );
		testMethodSuccess &= success;
		return success;
	}

	public Boolean assert( String name, Boolean success )
	{
		return assert( name, success, (String) null );
	}

	public Boolean assert( String name, Object expected, Object actual, String message )
	{
		TestResult result = new TestResult( name, expected, actual, message );
		list_Results.add( result );
		testMethodSuccess &= result.testSuccess;
		return result.testSuccess;
	}

	public Boolean assert( String name, Object expected, Object actual )
	{
		return assert( name, expected, actual, (String) null );
	}

	/*******************************************************
				annotate method

	This method adds an annotation to the report.  It appears
	as a "Passed" test.
	*******************************************************/

	public Boolean annotate( String name )
	{
		return assert( name, true );
	}

	/*******************************************************
				fail method

	This method adds a failed test to the report.
	*******************************************************/

	public Boolean fail( String name )
	{
		return assert( name, false );
	}

	/*******************************************************
				report method

	If the test method HAS NOT failed, this method does nothing.
	If the test method HAS failed, this method causes a
	System assertion failure and generates a report of all
	the CWTest assertions that have been made.
	*******************************************************/

	public String report()
	{
		if ( testMethodSuccess ) return null;

		List<String> list_Reports = new List<String>();

		list_Reports.add( '\n' );
		list_Reports.add( String.isBlank( testMethodName ) ? 'Unnamed Test Method' : testMethodName );
		list_Reports.add( ' Failed\n' );

		for ( TestResult result : list_Results )
		{
			list_Reports.add( result.report() );
		}

		String report = CWString.join( list_Reports );
		if ( !testingThis ) System.assert( false, report );
		return report;
	}

	/*******************************************************
		enableException, enableExceptions methods
	*******************************************************/

	public void enableException( String exceptionName )
	{
		if ( String.isNotBlank( exceptionName ) ) exceptionsToThrow.add( exceptionName );
	}

	public void enableExceptions( Set<String> exceptionNames )
	{
		for ( String exceptionName : exceptionNames )
		{
			enableException( exceptionName );
		}
	}

	/*******************************************************
		disableException, disableExceptions methods
	*******************************************************/

	public void disableException( String exceptionName )
	{
		if ( String.isNotBlank( exceptionName ) ) exceptionsToThrow.remove( exceptionName );
	}

	public void disableExceptions( Set<String> exceptionNames )
	{
		for ( String exceptionName : exceptionNames )
		{
			disableException( exceptionName );
		}
	}

	/*******************************************************
					replaceException method
	*******************************************************/

	public void replaceException( String oldExceptionName, String newExceptionName )
	{
		disableException( oldExceptionName );
		enableException( newExceptionName );
	}

	/*******************************************************
					clearExceptions method
	*******************************************************/

	public void clearExceptions()
	{
		exceptionsToThrow.clear();
	}

	/*******************************************************
			throwException, throwExceptions methods
	*******************************************************/

	private static Set<String>	exceptionsToThrow	= new Set<String>();

	public static void throwException( String exceptionName, Object theException )
	{
		if	(	Test.isRunningTest()
			&&	String.isNotBlank( exceptionName )
			&&	theException != null
			&&	exceptionsToThrow.contains( exceptionName )
			)
		{
			try
			{
				if ( theException instanceof Type )
				{
					theException = ((Type) theException).newInstance();
					if ( theException instanceof Exception )
					{
						((Exception) theException).setMessage( exceptionName );
					}
				}
				if ( theException instanceof Exception )
				{
					throw (Exception) theException;
				}
			}
			catch ( Exception anException ) {}
			throw new CWException( theException );
		}
	}

	public static void throwException( String exceptionName )
	{
		throwException( exceptionName, exceptionName );
	}

	public static void throwExceptions( Map<String,Object> exceptions )
	{
		if ( !Test.isRunningTest() ) return;

		for ( String exceptionName : exceptions.keySet() )
		{
			throwException( exceptionName, exceptions.get( exceptionName ) );
		}
	}

	public static void throwExceptions( Set<String> exceptions )
	{
		if ( !Test.isRunningTest() ) return;

		for ( String exceptionName : exceptions )
		{
			throwException( exceptionName );
		}
	}
}