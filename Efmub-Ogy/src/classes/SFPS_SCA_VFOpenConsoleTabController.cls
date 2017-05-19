public with sharing class SFPS_SCA_VFOpenConsoleTabController {
    public String sBackToRecordId {get;set;}
    public String sTargetURL {get;set;}
    public String sPrimaryTab {get;set;}
    
    public SFPS_SCA_VFOpenConsoleTabController() {
        sBackToRecordId = ApexPages.currentPage().getParameters().get('BackToRecordId');
        sTargetURL =  ApexPages.currentPage().getParameters().get('TargetURL');
        sPrimaryTab = ApexPages.currentPage().getParameters().get('PrimaryTab');

        if (sPrimaryTab != null)
            sPrimaryTab = sPrimaryTab.ToUpperCase();
    }

     public PageReference returnToRecordPage() {
        if (sBackToRecordId != '0')
            return new PageReference('/' + sBackToRecordId);
        else
            return new PageReference('/');
    }
}