/*******************************************************//**

@class      CWException

@brief      CW Core Error Handling Class

    The CWException class provides a dynamically configurable
    error handling mechanism.

@author     Glyn Anderson (LiquidHub.GHA)

@version    2014-02-04  LiquidHub.GHA
    Created.
@version    2014-02-05  LiquidHub.GHA
    Changed return types from Object to Boolean.
    Added 'errorNull' methods.
@version    2014-03-01  LiquidHub.GHA
    Implemented the abstract ErrorHandler class, which allows
    the error handling method to be determined using a delegate.
@version    2014-03-04  LiquidHub.GHA
    Made CWException a virtual class.  Made the newErrorHandler
    factory method more robust with try/catch.  Fixed bug with
    newErrorHandler factory method - ErrorHandler classes must be
    public.  Added support for CWCoreConfiguration.
@version    2014-03-04  LiquidHub.GHA
    Changed the definition of ErrorHandler to remove the one-argument
    version of 'handleError' - it was never called.

@todo   Add support for FireLog.

@see        CWExceptionTest

    (c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWException extends Exception
{
    /*******************************************************
                        constants
    *******************************************************/

    private static final String defaultErrorMessage         = 'CWException';                    //  used if no error message is provided
    private static final String fallbackErrorHandler        = 'CWException.IgnoreError';        //  used if no default ErrorHandler is specified

    /*******************************************************
                CWException constructors
    *******************************************************/

    public CWException( Object errorObject, Exception cause )
    {
        setMessage( errorObject != null ? String.valueOf( errorObject ) : defaultErrorMessage );
        if ( cause != null ) initCause( cause );
    }

    public CWException( Object errorObject )
    {
        this( errorObject, (Exception) null );
        if ( errorObject != null && errorObject instanceof Exception ) initCause( (Exception) errorObject );
    }

    /*******************************************************
    These constructors are defined automatically by virtue of
    extending the Exception class.
    *******************************************************/
/*
    public CWException( String errorObject, Exception cause )
    {
        this( errorObject, cause );
    }

    public CWException( Exception cause )
    {
        this( (Object) cause, cause );
    }

    public CWException( String errorObject )
    {
        this( errorObject, (Exception) null );
    }

    public CWException()
    {
        this( (Object) null, (Exception) null );
    }
*/

    /*******************************************************
                ErrorHandler class
    *******************************************************/

    public abstract class ErrorHandler
    {
        public abstract Boolean handleError( Object errorObject, Exception cause );
    }

    /*******************************************************
                ThrowError class
    *******************************************************/

    public class ThrowError extends ErrorHandler
    {
        public override Boolean handleError( Object errorObject, Exception cause )
        {
            throw new CWException( errorObject, cause );
        }
    }

    /*******************************************************
                UseDebugLog class
    *******************************************************/

    public class UseDebugLog extends ErrorHandler
    {
        public override Boolean handleError( Object errorObject, Exception cause )
        {
            List<String> errorStrings = new List<String>();
            errorStrings.add( errorObject != null ? String.valueOf( errorObject ) : defaultErrorMessage );
            if ( cause != null ) errorStrings.add( String.valueOf( cause ) );
            System.debug( CWString.join( errorStrings, '\n' ) );
            return false;
        }
    }

    /*******************************************************
                UseFireLog class
    *******************************************************/

    public class UseFireLog extends ErrorHandler
    {
        public override Boolean handleError( Object errorObject, Exception cause )
        {
            return false;
        }
    }

    /*******************************************************
                IgnoreError class
    *******************************************************/

    public class IgnoreError extends ErrorHandler
    {
        public override Boolean handleError( Object errorObject, Exception cause )
        {
            return false;
        }
    }

    /*******************************************************
                errorHandler properties
    *******************************************************/

    private static List<ErrorHandler>   errorHandlerStack
    {
        get
        {
            if ( errorHandlerStack == null )
            {
                errorHandlerStack = new List<ErrorHandler>();
                errorHandlerStack.add( defaultErrorHandler );
            }
            return errorHandlerStack;
        }
        private set;
    }

    private static ErrorHandler     theErrorHandler
    {
        get { return !errorHandlerStack.isEmpty() ? errorHandlerStack.get( 0 ) : null; }
    }

    private static ErrorHandler     defaultErrorHandler
    {
        get
        {
            if ( defaultErrorHandler == null )
            {
                String  handler = (String) CWCoreConfiguration.get( 'Default_ErrorHandler__c' );
                defaultErrorHandler = newErrorHandler( handler != null ? handler : fallbackErrorHandler );
            }
            return defaultErrorHandler;
        }
        private set;
    }

    /*******************************************************
                newErrorHandler factory method
    *******************************************************/

    public static ErrorHandler newErrorHandler( String errorHandlerName )
    {
        try
        {
            return
                String.isNotBlank( errorHandlerName )
            ?   (ErrorHandler) Type.forName( errorHandlerName ).newInstance()
            :   null;
        }
        catch ( Exception e )
        {
            return null;
        }
    }

    /*******************************************************
                setErrorHandler methods
    *******************************************************/

    public static void setErrorHandler( ErrorHandler handler )
    {
        if ( !errorHandlerStack.isEmpty() && handler != null ) errorHandlerStack.add( 0, handler );
    }

    public static void setErrorHandler( String errorHandlerName )
    {
        setErrorHandler( newErrorHandler( errorHandlerName ) );
    }

    /*******************************************************
                restoreErrorHandler method
    *******************************************************/

    public static void restoreErrorHandler()
    {
        if ( errorHandlerStack.size() > 1 ) errorHandlerStack.remove( 0 );
    }

    /*******************************************************
                resetErrorHandler method
    *******************************************************/

    public static void resetErrorHandler()
    {
        errorHandlerStack = null;
    }

    /*******************************************************
                error methods
    *******************************************************/

    public static Boolean error( Object errorObject, Exception cause )
    {
        return theErrorHandler != null && theErrorHandler.handleError( errorObject, cause );
    }

    public static Boolean error( Exception cause )
    {
        return error( (Object) cause, cause );
    }

    public static Boolean error( Object errorObject )
    {
        return error( errorObject, (Exception) null );
    }

    public static Boolean error()
    {
        return error( (Object) null, (Exception) null );
    }

    /*******************************************************
                errorNull methods
    *******************************************************/

    public static Object errorNull( Object errorObject, Exception cause )
    {
        error( errorObject, cause );
        return null;
    }

    public static Object errorNull( Exception cause )
    {
        error( (Object) cause, cause );
        return null;
    }

    public static Object errorNull( Object errorObject )
    {
        error( errorObject, (Exception) null );
        return null;
    }

    public static Object errorNull()
    {
        error( (Object) null, (Exception) null );
        return null;
    }
}