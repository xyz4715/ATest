/*******************************************************//**

@class		CWPredicate

@brief		CW Core Predicate Class

	A predicate is a function that takes an argument and returns
	true or false.  This abstract class provides an interface method,
	'test', and several predefined predicates (as inner classes)
	that apply logical operations on other predicates.

@author		Glyn Anderson (ClosedWon.GHA)

@version	2014-02-22	ClosedWon.GHA
	Created.

@see		CWPredicateTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public abstract class CWPredicate
{
	/*******************************************************
						test method

	This abstract method must be overridden by derived classes.
	It implements the Boolean function, or 'test', of the
	predicate.
	*******************************************************/

	public abstract Boolean test( Object theObject );

	/*******************************************************
						test method

	This static version of 'test' applies the given predicate
	to the given object.  If there is no predicate, the result
	is 'true'.
	*******************************************************/

	public static Boolean test( CWPredicate thePredicate, Object theObject )
	{
		return thePredicate == null || thePredicate.test( theObject );
	}

	/*******************************************************
					FieldHasValue predicate

	This predicate returns 'true' if the specified field has
	the specified value.
	*******************************************************/

	public class FieldHasValue extends CWPredicate
	{
		String		fieldName;
		Set<Object>	fieldValues;

		public FieldHasValue( String fieldName, Object fieldValue )
		{
			this.fieldName		= fieldName;
			this.fieldValues	= new Set<Object>{ fieldValue };
		}

		public FieldHasValue( String fieldName, Set<Object> fieldValues )
		{
			this.fieldName		= fieldName;
			this.fieldValues	= new Set<Object>( fieldValues );
		}

		public FieldHasValue( String fieldName, List<Object> fieldValues )
		{
			this.fieldName		= fieldName;
			this.fieldValues	= new Set<Object>( fieldValues );
		}

		public override Boolean test( Object theObject )
		{
			return
				(	theObject instanceOf sObject
				&&	fieldValues.contains( ((sObject) theObject).get( fieldName ) )
				)
			||	(	theObject instanceOf CWAccessible
				&&	fieldValues.contains( ((CWAccessible) theObject).get( fieldName ) )
				);
		}
	}

	/*******************************************************
					TrueOp predicate

	This predicate is always 'true', regardless of the Object.
	*******************************************************/

	public class TrueOp extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return true;
		}
	}

	/*******************************************************
					FalseOp predicate

	This predicate is always 'false', regardless of the Object.
	*******************************************************/

	public class FalseOp extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return false;
		}
	}

	/*******************************************************
					AndOp predicate

	This predicate returns the conjunction (logical AND) of
	its predicates.  It employs short-circuit evaluation.
	*******************************************************/

	public class AndOp extends CWPredicate
	{
		List<CWPredicate>	list_predicates;

		public AndOp( List<CWPredicate> predicates )
		{
			list_predicates = predicates != null ? predicates : new List<CWPredicate>();
		}

		public AndOp( CWPredicate predicate_1, CWPredicate predicate_2 )
		{
			this( new List<CWPredicate>{ predicate_1, predicate_2 } );
		}

		public override Boolean test( Object theObject )
		{
			for ( CWPredicate predicate : list_predicates )
			{
				if ( !test( predicate, theObject ) ) return false;
			}
			return true;
		}
	}

	/*******************************************************
					OrOp predicate

	This predicate returns the disjunction (logical OR) of
	its predicates.  It employs short-circuit evaluation.
	*******************************************************/

	public class OrOp extends CWPredicate
	{
		List<CWPredicate>	list_predicates;

		public OrOp( List<CWPredicate> predicates )
		{
			list_predicates = predicates != null ? predicates : new List<CWPredicate>();
		}

		public OrOp( CWPredicate predicate_1, CWPredicate predicate_2 )
		{
			this( new List<CWPredicate>{ predicate_1, predicate_2 } );
		}

		public override Boolean test( Object theObject )
		{
			for ( CWPredicate predicate : list_predicates )
			{
				if ( test( predicate, theObject ) ) return true;
			}
			return false;
		}
	}

	/*******************************************************
					XorOp predicate

	This predicate returns the logical XOR of its predicates.
	It returns 'true' if an odd number of its predicates are
	true.  All predicates are evaluated.
	*******************************************************/

	public class XorOp extends CWPredicate
	{
		List<CWPredicate>	list_predicates;

		public XorOp( List<CWPredicate> predicates )
		{
			list_predicates = predicates != null ? predicates : new List<CWPredicate>();
		}

		public XorOp( CWPredicate predicate_1, CWPredicate predicate_2 )
		{
			this( new List<CWPredicate>{ predicate_1, predicate_2 } );
		}

		public override Boolean test( Object theObject )
		{
			Boolean output = false;
			for ( CWPredicate predicate : list_predicates )
			{
				output ^= test( predicate, theObject );
			}
			return output;
		}
	}

	/*******************************************************
					NotOp predicate

	This predicate returns the logical complement of its predicate.
	*******************************************************/

	public class NotOp extends CWPredicate
	{
		CWPredicate	thePredicate;

		public NotOp( CWPredicate predicate )
		{
			thePredicate = predicate;
		}

		public override Boolean test( Object theObject )
		{
			return !test( thePredicate, theObject );
		}
	}

	/*******************************************************
					IfOp predicate

	This predicate evaluates its conditional predicate, then
	evaluates and returns its 'ifTrue' predicate, if the
	conditional was 'true'; or its 'ifFalse' predicate, if the
	conditional was 'false'.  The 'ifFalse' predicate is optional.
	*******************************************************/

	public class IfOp extends CWPredicate
	{
		CWPredicate	theConditional;
		CWPredicate	testIfTrue;
		CWPredicate	testIfFalse;

		public IfOp( CWPredicate conditional, CWPredicate ifTrue, CWPredicate ifFalse )
		{
			theConditional	= conditional;
			testIfTrue		= ifTrue;
			testIfFalse		= ifFalse;
		}

		public IfOp( CWPredicate conditional, CWPredicate ifTrue )
		{
			this( conditional, ifTrue, (CWPredicate) null );
		}

		public override Boolean test( Object theObject )
		{
			return
				test( theConditional, theObject )
				?	test( testIfTrue, theObject )
				:	test( testIfFalse, theObject );
		}
	}
}