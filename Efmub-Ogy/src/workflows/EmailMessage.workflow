<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Status_Response_Received</fullName>
        <description>Used to change the Case Status for when an inbound email is received</description>
        <field>Status</field>
        <literalValue>Response Received</literalValue>
        <name>Case Status - Response Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Case Status - Email Received</fullName>
        <actions>
            <name>Case_Status_Response_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Used to change the Case Status for when an inbound email is received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
