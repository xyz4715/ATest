@isTest
private class FetchContactDetailsTest {
    static testMethod void runPositiveTestCases() {
	Account acc = new Account(PersonMailingStreet='testNo',PersonMailingCity='IN',PersonMailingState='test',PersonEmail='test23@test.com',Phone='(888) 899-9999',PersonMailingPostalCode='89798',FirstName='testFN',LastName='TestLN',SkyMiles_Number__pc='7668768765');
    insert acc;
    FetchContactDetails.newAccount();
        FetchContactDetails.getAccountsFromSFDC(acc.id);
        FetchContactDetails.getAccountsFROMWSDL('7668768765',null,acc.id);
        //FetchContactDetails.newAccount();
    }
}