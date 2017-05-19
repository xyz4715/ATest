@isTest(SeeAllData=true)
public class Phx_Create_Case_from_Email_handler_test
{
    public static testMethod void EmailParserTester(){
        
        // setup controller object
        Phx_Create_Case_from_Email_handler  objconfirm = new Phx_Create_Case_from_Email_handler ();
        System.debug('Im starting a method');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        email.subject ='Testing';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only. Bye';
        envelope.fromAddress = 'maf@test.com';
        
        objconfirm.handleInboundEmail(email, envelope);
        objconfirm.checkPhone('9775890765');
        objconfirm.checkSkymiles('9775890765');
        objconfirm.checkFlyingBlue('9775890765');
        objconfirm.checkFormName('9775890765');
        objconfirm.checkStreetAddress1('9775890765');
        objconfirm.checkStreetAddress2('9775890765');
        objconfirm.checkPostalCode('9775890765');
        objconfirm.checkSubject('9775890765');
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
        
        email.plainTextBody = 'Delta AirLines Delayed Bag Fee Rebate Form\n'+
            +'Source: delta.com\n'+
            +'To: ContactUs.Delta@delta.com\n'+
            +'Delta Air Lines Delayed Bag Fee Rebate Form\n'+
            +'Prefix: Ms\n'+
            +'First Name: JIEWEN\n'+
            +'Middle Name:\n'+
            +'Last Name: YAO\n'+
            +'Suffix:\n'+
            +'Address: SONG SHAN LAKE\n'+
            +'Address Line 2:\n'+
            +'City: DONGGUAN\n'+
            +'State/Province:\n'+
            +'Postal Code/Zip:\n'+
            +'Country: CN\n'+
            +'Primary Country Code: < 086\n'+
            +'Phone Number: 13790305622\n'+
            +'Reply-To Email Address: renee.yao@sainstore.com\n'+
            +'File Reference Number: SFODL44133\n'+
            +'Bag Tag Number 1: 7006524009\n'+
            +'Bag Tag Number 2:\n'+
            +'Ticket Number:\n'+
            +'Excess Bag Receipt:\n'+
            +'Flight Number: DL4918\n'+
            +'Origin City: SFO\n'+
            +'Destination City: LAX\n'+
            +'Flight Date: 03/24/2017\n'+
            +'17年3月24日，我乘坐达美DL733下午2点45分从堪 萨 斯 MCI 飞 往 LAX（中 转 ）， 计 划 6点乘坐DL4922从LAX 飞 往 SFO\n'+
            +'。到达LAX后被告知DL4922将延 误 到晚上 9点起 飞 ，但是我 们 从 SFO 飞 往 HK的航班，新加坡航空SQ001将在凌晨1点\n'+
            +'Submitted:';
        objconfirm.handleInboundEmail(email, envelope);
        
        
        email.plainTextBody = 'Delta AirLines Delayed Bag Fee Rebate Form\n'+
            +'Source: delta.com\n'+
            +'To: ContactUs.Delta@delta.com\n'+
            +'Delta Air Lines Delayed Bag Fee Rebate Form\n'+ 
            +'Prefix: Ms\n'+
            +'First Name: JIEWEN\n'+
            +'Middle Name:\n'+
            +'Last Name: YAO\n'+
            +'Suffix:\n'+
            +'Address: SONG SHAN LAKE\n'+
            +'Address Line 2:\n'+
            +'City: DONGGUAN\n'+
            +'State/Province:\n'+
            +'Postal Code/Zip:\n'+
            +'Country: CN\n'+
            +'Primary Country Code: < 086\n'+
            +'Phone Number: 13790305622\n'+
            +'Reply-To Email Address: renee.yao@sainstore.com<renee.yao@sainstore.com>\n'+
            +'File Reference Number: SFODL44123\n'+
            +'Bag Tag Number 1: 7006524909\n'+
            +'Bag Tag Number 2:\n'+
            +'Ticket Number:\n'+
            +'Excess Bag Receipt:\n'+
            +'Flight Number: DL4918\n'+
            +'Origin City: SFO\n'+
            +'Destination City: LAX\n'+
            +'Flight Date: 03/24/2017\n';
        objconfirm.handleInboundEmail(email, envelope);
        
        
    }
}