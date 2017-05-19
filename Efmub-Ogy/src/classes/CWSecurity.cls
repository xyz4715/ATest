/*******************************************************//**

@class		CWSecurity

@brief		CW Core Crypto Class

	This class implements support for encryption/decryption,
	and other data securing methods.

@author		Tim Smith (LiquidHub.TRS)

@version	2014-08-10	LiquidHub.TRS
	Created.

@see		CWSecurityTest

@todo	Add support for decrypt
@todo	Add support for decryptWithManagedIV
@todo	Add support for signWithCertificate
@todo	Add support for signXML
@todo	Add support for generating digest (with repeat) and MAC
@todo	Add private key management
@todo	Incorporate other security needs (Sharing, Auth, Certificate Management etc)

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWSecurity
{
	/*******************************************************
			Crypto Method Enumeration
	*******************************************************/

	public enum Method
	{
		ENCRYPT,
		SIGN,
		SIGNWITHCERT,
		SIGNXML,
		DECRYPT
	}

	/*******************************************************
			Encryption/Decryption Algorithm Enumeration
	*******************************************************/

	public enum Algorithm
	{
		// Encryption Algorithms
		AES128,
		AES192,
		AES256,
		// Signature Algorithms
		RSA,
		RSASHA1,
		RSASHA256,
		// Hash/Digest Algorithms
		MD5,
		SHA1,
		SHA256,
		SHA512,
		// MAC Algorithms
		HMACMD5,
		HMACSHA1,
		HMACSHA256,
		HMACSHA512
	}

	/*******************************************************
				map from Algorithm to String
	*******************************************************/

	private static Map<Algorithm,String> map_Algorithm_String
	{
		get
		{
			if ( map_Algorithm_String == null )
			{
				map_Algorithm_String = new Map<Algorithm,String>
				{	Algorithm.AES128		=>	'AES128',
					Algorithm.AES192		=>	'AES192',
					Algorithm.AES256		=>	'AES256',
					Algorithm.RSA			=>	'RSA',
					Algorithm.RSASHA1		=>	'RSA-SHA1',
					Algorithm.RSASHA256		=>	'RSA-SHA256',
					Algorithm.MD5			=>	'MD5',
					Algorithm.SHA1			=>	'SHA1',
					Algorithm.SHA256		=>	'SHA-256',
					Algorithm.SHA512		=>	'SHA-512',
					Algorithm.HMACMD5		=>	'hmacMD5',
					Algorithm.HMACSHA1		=>	'hmacSHA1',
					Algorithm.HMACSHA256	=>	'hmacSHA256',
					Algorithm.HMACSHA512	=>	'hmacSHA512'
				};
			}
			return map_Algorithm_String;
		}
		private set;
	}

	public class Krypto		//	Crypto is an existing class, so using Superman's dog, Krypto.
	{
		/***************************************************
						members
		***************************************************/

		private Method		cryptoMethod;
		private Blob		privateKey;
		private Blob		initVector;

		/***************************************************
						Request constructor(s)
		***************************************************/

		public Krypto( Method method, String key, String vector )
		{
			cryptoMethod	= method;
			privateKey		= Blob.valueOf( key != null ? key : '' );
			initVector		= Blob.valueOf( vector != null ? vector : '' );
		}

		public Krypto( Method method, String key )
		{
			this( method, key, (String) null );
		}

		public Blob encrypt( Algorithm algorithm, String input )
		{
			Blob	encryptedBlob;
			Blob	inputBlob = Blob.valueOf( input );

			String	algorithmValue = map_Algorithm_String.get( algorithm );

			encryptedBlob =
				cryptoMethod == Method.SIGN								?	Crypto.sign( algorithmValue, privateKey, inputBlob )
			:	cryptoMethod == Method.ENCRYPT && initVector.size() > 0	?	Crypto.encrypt( algorithmValue, privateKey, initVector, inputBlob )
			:	cryptoMethod == Method.ENCRYPT							?	Crypto.encryptWithManagedIV( algorithmValue, privateKey, inputBlob )	:	null;

			return encryptedBlob != null ? encryptedBlob : (Blob) CWException.errorNull( 'Encryption failed.' );
		}

		public Blob encrypt( Algorithm algorithm, CWObject input )
		{
			return encrypt( algorithm, CWHttp.urlEncode( input ) );
		}

		public Blob encrypt( Algorithm algorithm, Object input )
		{
			return (input instanceof CWObject) ? encrypt( algorithm, (CWObject) input ) : encrypt( algorithm, CWString.valueOf( input ) );
		}
	}
}