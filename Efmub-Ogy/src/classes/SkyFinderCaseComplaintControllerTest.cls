@isTest
public class SkyFinderCaseComplaintControllerTest {

    @isTest(seeAllData=true)
    static void basicGetters()
    {
        SkyFinderCaseComplaintController controller = new SkyFinderCaseComplaintController();
        controller.newComplaintDescription = Null;
        controller.newComplaintLocation    = Null;
        controller.newFlightLegId          = Null;
        controller.newFlightLegAirport     = Null;
        controller.complaintCodeId         = Null;
        controller.hasCaseId               = False;
        controller.caseNumber              = Null;
        controller.topCaseId               = Null;
        controller.hasPnr                  = False;
        controller.pnr                     = Null;
        controller.hasContactName          = False;
        controller.contactName             = Null;
        controller.contactId               = Null;
        controller.hasComplaintCity        = False;
        controller.complaintCity           = Null;
        controller.hasSkyMilesNumber       = False;
        controller.skyMilesNumber          = Null;
        controller.caseComplaint           = Null;
        controller.attachedComplaints      = Null;

        controller.getDataJson();
        controller.getComplaintLocations();
        controller.getComplaintCodesList2();
        controller.getAirportLocations();
    }

    @isTest(seeAllData=true)
    static void testContructor()
    {
        //Complaint_Code__c cc=new Complaint_Code__c();
        
        
        Complaint_Code__c testComplaintCode = [
            SELECT Id, Name
            FROM   Complaint_Code__c
            WHERE  Disability_Code_Required__c = FALSE AND Active__c = TRUE
            LIMIT  1
        ];

        Case testCase = new Case(
            RecordTypeId='0120S0000004LRzQAM',
            Subject = 'Test Case 123',
            Origin='Phone',
            Type='Disability',
            Status ='Open',
            Received_Via__c='BBB',
            CurrencyIsoCode ='USD',
            Received_Date__c= Date.parse('4/11/2017')
        );
        upsert testCase;      

        //Flight_Leg__c testFlightLeg0 = new Flight_Leg__c(Name = 'DL0123 2016-06-21 ATL ABQ');
        //Flight_Leg__c testFlightLeg1 = new Flight_Leg__c(Name = 'DL1234 2016-06-21 MSP ATL');
        //insert new List<Flight_Leg__c>{ testFlightLeg0, testFlightLeg1 };

        Case_Complaint__c testCaseComplaint0 = new Case_Complaint__c(
            Case__c       = testCase.Id
            //,Flight_Leg__c = testFlightLeg0.Id
        );
        Case_Complaint__c testCaseComplaint1 = new Case_Complaint__c(
            Case__c           = testCase.Id,
            //Flight_Leg__c     = testFlightLeg0.Id,
            Complaint_Code__c = testComplaintCode.Id
        );
        Case_Complaint__c testCaseComplaint2 = new Case_Complaint__c(
            Case__c           = testCase.Id,
            //Flight_Leg__c     = testFlightLeg0.Id,
            Complaint_Code__c = testComplaintCode.Id
        );
        insert new List<Case_Complaint__c>{ testCaseComplaint0, testCaseComplaint1, testCaseComplaint2 };

        PageReference tpageRef = Page.SkyFinderCaseComplaintPage;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id', testCase.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        SkyFinderCaseComplaintController controller = new SkyFinderCaseComplaintController();

        controller.getFlightLegs();

        controller.clickRemoveComplaint();
        controller.complaintCodeId = testCaseComplaint1.Id;
        controller.clickRemoveComplaint();
        controller.complaintCodeId = testCaseComplaint2.Id;
        controller.clickRemoveComplaint();

        controller.clickResetComplaint();

        controller.complaintCodeId = testCaseComplaint0.Id;
        controller.clickAddComplaint(); // error
        controller.newComplaintDescription = '';
        controller.clickAddComplaint(); // error
        controller.newComplaintDescription = 'abc';
        controller.clickAddComplaint(); // error
        controller.newComplaintDescription = '|abc';
        controller.clickAddComplaint(); // error
        controller.newComplaintDescription = '|' + testComplaintCode.Name;
        controller.clickAddComplaint(); // error
        controller.caseComplaint.Disability_Group__c = 'Other';
        controller.clickAddComplaint(); // error
        controller.caseComplaint.Disability_Code__c = 'Oxygen';
        controller.clickAddComplaint(); // success fill in existing flight leg
        controller.clickAddComplaint(); // success copy flight leg
    }
}