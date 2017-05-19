/*******************************************************//**

@class		CWSecurityTest

@brief		CWSecurity Test Class

@author		Tim Smith (LiquidHub.TRS)

@version	2014-08-30	LiquidHub.TRS
	Created.

@see		CWSecurity

@todo		Use CWTest - asserts, report

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWSecurityTest
{
	/*******************************************************
					Test Method
	*******************************************************/

	static testMethod void cwSecurityUnitTest()
	{
		////	Constants
		String	a32BitEncryptionKey		= 'TestEncryptionKeyTestEncryptionK';
		String	a16BitVector			= 'TestInitVectorrr';

		////	Begin Test
		CWTest testResults = new CWTest( 'CWSecurityTest' );
		String testingMethod;

		testResults.startTest();

		////	encrypt methods test
		CWSecurity.Krypto	kryptoEncrypt =
			new CWSecurity.Krypto
			(	CWSecurity.Method.ENCRYPT,
				a32BitEncryptionKey
			);

		CWSecurity.Krypto	kryptoEncryptIV =
			new CWSecurity.Krypto
			(	CWSecurity.Method.ENCRYPT,
				a32BitEncryptionKey,
				a16BitVector
			);

		CWSecurity.Krypto	kryptoSign =
			new CWSecurity.Krypto
			(	CWSecurity.Method.SIGN,
				String.valueOf( EncodingUtil.base64Decode( '' ) )
			);

		Object	input			= new CWObject( '{"key":"value"}' );
		Blob	encryptedBlob	= kryptoEncrypt.encrypt( CWSecurity.Algorithm.AES256, input );
		Blob	encryptedIVBlob	= kryptoEncryptIV.encrypt( CWSecurity.Algorithm.AES256, input );
//		Blob	signedBlob		= kryptoSign.encrypt( CWSecurity.Algorithm.RSASHA256, input );

		testResults.stopTest();
		testResults.report();
	}
}