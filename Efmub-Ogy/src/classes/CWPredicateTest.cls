/*******************************************************//**

@class		CWPredicateTest

@brief		Tests for CWPredicate Class

	The CWPredicateTest class contains the test methods for the
	CWPredicate class.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-12-17	LiquidHub.GHA
	Created.

@see		CWPredicate

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWPredicateTest
{
	private static testMethod void testCWPredicate()
	{
		CWPredicate	trueOp	= new CWPredicate.TrueOp();
		CWPredicate	falseOp	= new CWPredicate.FalseOp();

		CWPredicate	ifTrueOp	= new CWPredicate.IfOp
		(	new CWPredicate.AndOp( trueOp, trueOp ),
			new CWPredicate.OrOp
			(	new CWPredicate.XorOp( falseOp, falseOp ),
				new CWPredicate.NotOp( trueOp )
			)
		);

		Boolean	result	= ifTrueOp.test( (Object) null );

		CWPredicate	ifFalseOp	= new CWPredicate.IfOp
		(	falseOp,
			trueOp
		);

		result	= ifFalseOp.test( (Object) null );
	}
}