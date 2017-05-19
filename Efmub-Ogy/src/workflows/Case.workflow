<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Challenge_Status</fullName>
        <description>Set Challenge Status = Pending when Challengeable = Yes</description>
        <field>Challenge_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Set Challenge Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_related_information</fullName>
        <field>Account_Related_Data__c</field>
        <formula>Account.FirstName +&apos; &apos;+  Account.LastName +&apos; &apos;+    (Account.PersonContact.SkyMiles_Number__c) +&apos; &apos;+(Account.PersonEmail)
+&apos; &apos;+(Account.Phone)</formula>
        <name>Update Account related information</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Case_Ownership</fullName>
        <description>Update Case Status to Open when user pulls a Case from a Queue</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Update Status Case Ownership</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Challenge Status</fullName>
        <actions>
            <name>Set_Challenge_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Challengeable__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set Challenge Status = Pending when Challengeable = Yes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Info Account Related Data</fullName>
        <actions>
            <name>Update_Account_related_information</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will update a account related field which will hold all account related information which can be used for global search of cases for fields such as email, ph#, skymiles#</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status Case Ownership</fullName>
        <actions>
            <name>Set_Challenge_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status_Case_Ownership</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Case Status to Open when user pulls a Case from a Queue</description>
        <formula>AND( ISCHANGED(OwnerId),  Print_Letter_Complete__c = false, OR( OwnerId = $User.Id, AND(  LEFT(PRIORVALUE(OwnerId),3) = &apos;00G&apos;, LEFT(OwnerId,3) = &apos;005&apos; ) )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
