/*******************************************************//**

@class      CaseHandler

@brief      Trigger Handler for Cases

    This class is called by the Case trigger to manage Cases.

@author     Glyn Anderson   (LiquidHub.GHA)

@version    2015-12-01  LiquidHub.GHA
    Created.

@see        CaseTrigger (trigger)
@see        CaseHandlerTest

    (c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class CaseHandler implements CWTrigger.Handler
{
    public static set<id> caseId{get;set;}
    /*******************************************************
                        beforeTrigger
    *******************************************************/

    public void beforeTrigger( CWTrigger theTrigger )
    {
        theTrigger.flag     = true;         //  prevent re-triggering on these records

        //  nothing to do here yet...
    }

    /*******************************************************
                        afterTrigger
    *******************************************************/

    public void afterTrigger( CWTrigger theTrigger )
    {
        theTrigger.flag     = true;         //  prevent re-triggering on these records

        //  nothing to do here yet...
    }
    
    public static void beforeCaseUpdate(list<case> caseList, map<id,case> oldmap,map<id,case> newmap)
    {
        map<id,map<string,integer>> caseMap = new map<id,map<string,integer>>();
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        caseId = new set<id>();
        for(case cs:caseList)
        {
            if((oldmap.get(cs.id).Status != newmap.get(cs.id).Status)&&(cs.Status == 'Closed'))
            {
                caseId.add(cs.id);
            }
            
            //Added my Amol-PHX-122
          
             Boolean oldOppIsClosed = oldmap.get(cs.id).Status.equals('Closed');
             Boolean newOppIsClosed = cs.Status.equals('Closed');
             // Check that the field was changed to the status correct value
             if (oldOppIsClosed==true && newOppIsClosed==true) {
                   newmap.get(cs.id).addError('Case Cannot be edited in Closed status.Please Re-open & Edit it');
               }
            //end code  PHX-122
        }
        if(caseId.size() > 0)
        {
            list<case> DOTCases = [select id, Type,SSR__c ,Disability_Code_Required__c ,RecordType.developerName,(select id,Complaint_Code__r.Recordtype.developerName,DOT_Disability_Code__r.Recordtype.developerName,DOT_Disability_Code__c from Case_Complaints__r) from case where id IN :caseId ];
            for(case c: DOTCases)
            {
                integer recordTypeCount = 0;
                map<string,integer> complaintTypeMap = new map<string,integer>();
                for(Case_Complaint__c cc: c.Case_Complaints__r)
                {
                    if(complaintTypeMap.keyset().contains(cc.Complaint_Code__r.Recordtype.developerName))
                    {
                        if(cc.DOT_Disability_Code__c == null){
                        complaintTypeMap.put(cc.Complaint_Code__r.Recordtype.developerName,complaintTypeMap.get(cc.Complaint_Code__r.Recordtype.developerName)+1);
                        }
                        else{
                        if(complaintTypeMap.keyset().contains(cc.DOT_Disability_Code__r.Recordtype.developerName)){
                           complaintTypeMap.put(cc.DOT_Disability_Code__r.Recordtype.developerName,complaintTypeMap.get(cc.DOT_Disability_Code__r.Recordtype.developerName)+1);
                        }
                        else{
                        complaintTypeMap.put(cc.DOT_Disability_Code__r.Recordtype.developerName,1);
                        }
                        }
                        
                    }
                    else{
                        //if(cc.DOT_Disability_Code__c == null){
                        complaintTypeMap.put(cc.Complaint_Code__r.Recordtype.developerName,1);
                        //}
                        if(cc.DOT_Disability_Code__c != null){
                        complaintTypeMap.put(cc.DOT_Disability_Code__r.Recordtype.developerName,1);
                        }
                    }
                    
                }
                caseMap.put(c.id,complaintTypeMap);
                if(c.RecordType.developerName == 'DOT')
                {
                    if((profileName == 'DOT Coordinator')&&(c.Type != 'Disability'))
                    {
                        if((!complaintTypeMap.keyset().contains('DOT'))||(!complaintTypeMap.keyset().contains('Delta')))
                            newmap.get(c.id).addError('Case should have DOT and Delta complaint codes');
                    }
                    if((profileName == 'DOT Coordinator')&&(c.Type == 'Disability'))
                    {
                        if((!complaintTypeMap.keyset().contains('DOT'))||(!complaintTypeMap.keyset().contains('Delta'))||(!complaintTypeMap.keyset().contains('Dot_Disability')))
                            newmap.get(c.id).addError('Case should have DOT code, 1 Delta disability code and the respective DOT disability code.');
                    }
                    
                                        
                }
                if(c.RecordType.developerName == 'Disability')
                {
                   
                  if((c.Type == 'Disability')&&(profileName == 'Disability Coordinator')&&(c.SSR__c == ''))newmap.get(c.id).addError('Please select SSR');
                  if((profileName == 'Disability Coordinator')&&(c.Type == 'Disability'))
                    {
                        if((!complaintTypeMap.keyset().contains('Delta'))||(!complaintTypeMap.keyset().contains('Dot_Disability')))
                            newmap.get(c.id).addError('Case should have 1 Delta disability code and the respective DOT disability code.');
                    }
                }
            }
            
           
        }
    }
}