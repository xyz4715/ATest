<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Female_Gender</fullName>
        <description>Set Gender to Female based on customer prefix</description>
        <field>Gender__pc</field>
        <literalValue>Female</literalValue>
        <name>Set Female Gender</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Male_Gender</fullName>
        <description>Set Gender to Male based on customer prefix</description>
        <field>Gender__pc</field>
        <literalValue>Male</literalValue>
        <name>Set Male Gender</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unknown_Gender</fullName>
        <description>Set Gender to Unknown based on customer prefix</description>
        <field>Gender__pc</field>
        <literalValue>Unknown</literalValue>
        <name>Set Unknown Gender</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Female Gender</fullName>
        <actions>
            <name>Set_Female_Gender</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Salutation</field>
            <operation>equals</operation>
            <value>Ms.,Mrs.</value>
        </criteriaItems>
        <description>Set Gender to Female based on customer prefix</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Male Gender</fullName>
        <actions>
            <name>Set_Male_Gender</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Salutation</field>
            <operation>equals</operation>
            <value>Mr.</value>
        </criteriaItems>
        <description>Set Gender to Male based on customer prefix</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Unknown Gender</fullName>
        <actions>
            <name>Set_Unknown_Gender</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Gender to Unknown based on customer prefix</description>
        <formula>AND( ISNEW(), ISBLANK(TEXT( Gender__pc )), OR( ISPICKVAL( Salutation , &quot;Dr.&quot;), ISPICKVAL( Salutation , &quot;Rev.&quot;), ISPICKVAL( Salutation , &quot;&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
