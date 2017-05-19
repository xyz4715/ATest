global class Phx_Create_Case_from_Email_handler implements Messaging.InboundEmailHandler {
    
    public string emailSubject;
    public string bodyText;
    public string DetectedLanguage;
    public string detectedLangResponse;
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();     
        
        Map<string, List<DeltaAirLineForms__c>> deltaAirLinesMap= new Map<string, List<DeltaAirLineForms__c>>();
        
        for(DeltaAirLineForms__c deltaRec : [select Name,Form_Name__c,Field_Label__c,Field_Type_for_Validation__c,Salesforce_API_Name__c from DeltaAirLineForms__c LIMIT 50000]) {
            if(deltaAirLinesMap.containsKey(deltaRec.Form_Name__c)) {
                List<DeltaAirLineForms__c> deltaList= deltaAirLinesMap.get(deltaRec.Form_Name__c);
                deltaList.add(deltaRec);
                deltaAirLinesMap.put(deltaRec.Form_Name__c, deltaList);
            } else {
                deltaAirLinesMap.put(deltaRec.Form_Name__c, new List<DeltaAirLineForms__c> { deltaRec });
            }
        }
        /**************************Start Pattern matching **************************** */
        emailSubject = email.subject;
        bodyText = email.plainTextBody; 
        //system.debug('text is:'+bodyText );
        if(bodyText!='')
        {
            DetectedLanguage = detectLanguage() ;
        }
        
        string formName =''; 
        for(string formNamekey :deltaAirLinesMap.keySet()){
            Pattern namePattern= Pattern.compile('(?m)(?i)^'+formNamekey+'.*');
            Matcher matcher = namePattern.matcher(bodyText );            
            if (matcher.find()){ 
                formName =  matcher.group(0);
            }       
        }
        List<DeltaAirLineForms__c> DeltaAirLineFormsFields = new List<DeltaAirLineForms__c>();
        if(formName!='')
            DeltaAirLineFormsFields  = deltaAirLinesMap.get(formName);//[select Name,Field_Label__c,Field_Type_for_Validation__c,Salesforce_API_Name__c from DeltaAirLineForms__c where Form_Name__c=:formName];
        try{ 
            if(DeltaAirLineFormsFields.size()>0){
                Account Acc= new Account();
                string mailingAddressconcatenate = '';
                for(DeltaAirLineForms__c DALLabel : DeltaAirLineFormsFields){
                    Pattern namePattern= Pattern.compile('(?m)(?i)^'+DALLabel.Field_Label__c+'.*');
                    Matcher matcher = namePattern.matcher(bodyText );
                    if (matcher.find()){ 
                        
                        String actualValue = matcher.group(0).replace(DALLabel.Field_Label__c,'');
                        
                        //concatenate Address line1 and Line 2
                        if(DALLabel.Salesforce_API_Name__c == 'PersonMailingStreet'){
                            mailingAddressconcatenate = mailingAddressconcatenate + actualValue;
                            actualValue = mailingAddressconcatenate;
                        }
                        
                        //EMail validation
                        if(DALLabel.Field_Type_for_Validation__c == 'Email'){
                            actualValue  = checkEmail(actualValue);
                        }
                        
                        Acc.put(DALLabel.Salesforce_API_Name__c ,actualValue);
                    }
                }    
                List<Account> skyMilesCheck = new List<Account>();
                if(Acc.SkyMiles_Number__pc!=null){
                skyMilesCheck = [select id from Account where  SkyMiles_Number__pc=:Acc.SkyMiles_Number__pc];
                system.debug('skyMilesCheck-->'+skyMilesCheck+'--'+Acc.SkyMiles_Number__pc);
                }
                if(skyMilesCheck.size()>0){
                    Acc = skyMilesCheck[0];
                }else{
                    insert Acc;                
                }
                case c = createCase(Acc.id);
                result.message = bodyText+'     /n  Thanks for mailing us, your Account detail is' + Acc+'  and case# is : '+c.id+'   Regarding detection response through callout    >>>'+detectedLangResponse ; 
                
                return result;
                /**************************end Pattern matching *****************************/
                
            }else{
                result.message = 'Done';//, and the form sent was'+formName;
                createCase(null);
                return result;
            }
        }catch(exception e){   
        system.debug('Exception:'+e);         
            case c  = createCase(null);
            result.message = 'unable to create Account Please try again. Your Case# is:'+c.id+detectedLangResponse +e;
            return result;
        }        
    }
    
    public string detectLanguage()
    {
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint( 'http://ws.detectlanguage.com/0.2/detect?key=demo&q=' + EncodingUtil.urlEncode(bodyText,'UTF-8'));
        req.setMethod('GET');
        Http http = new Http();
        string responseBody;
        if(!Test.isRunningTest()){
           HttpResponse  response = http.send(req);  
            responseBody = response.getBody();
        }else{
            responseBody = '{"data":{"detections":[{"language":"en","isReliable":true,"confidence":10}]}}';
        }
        Phx_Create_Case_from_Email_handler jsonParsedData = (Phx_Create_Case_from_Email_handler) System.JSON.deserialize(responseBody, Phx_Create_Case_from_Email_handler.class) ;
        
        string inboundEmailLanguage = 'English';
        system.debug('Response is >>>>'+jsonParsedData );
        map<string, string> detectlanguageConversions = new map<string,string> {
            'aa'=>'Afar',
            'ab'=>'Abkhazian',
            'af'=>'Afrikaans',
            'ak'=>'Akan',
            'am'=>'Amharic',
            'ar'=>'Arabic',
            'as'=>'Assamese',
            'ay'=>'Aymara',
            'az'=>'Azerbaijani',
            'ba'=>'Bashkir',
            'be'=>'Belarusian',
            'bg'=>'Bulgarian',
            'bh'=>'Bihari',
            'bi'=>'Bislama',
            'bn'=>'Bengali',
            'bo'=>'Tibetan',
            'br'=>'Breton',
            'bs'=>'Bosnian',
            'bug'=>'Buginese',
            'ca'=>'Catalan',
            'ceb'=>'Cebuano',
            'chr'=>'Cherokee',
            'co'=>'Corsican',
            'crs'=>'Seselwa',
            'cs'=>'Czech',
            'cy'=>'Welsh',
            'da'=>'Danish',
            'de'=>'German',
            'dv'=>'Dhivehi',
            'dz'=>'Dzongkha',
            'egy'=>'Egyptian',
            'el'=>'Greek',
            'en'=>'English',
            'eo'=>'Esperanto',
            'es'=>'Spanish',
            'et'=>'Estonian',
            'eu'=>'Basque',
            'fa'=>'Persian',
            'fi'=>'Finnish',
            'fj'=>'Fijian',
            'fo'=>'Faroese',
            'fr'=>'French',
            'fy'=>'Frisian',
            'ga'=>'Irish',
            'gd'=>'Scots Gaelic',
            'gl'=>'Galician',
            'gn'=>'Guarani',
            'got'=>'Gothic',
            'gu'=>'Gujarati',
            'gv'=>'Manx',
            'ha'=>'Hausa',
            'haw'=>'Hawaiian',
            'hi'=>'Hindi',
            'hmn'=>'Hmong',
            'hr'=>'Croatian',
            'ht'=>'Haitian Creole',
            'hu'=>'Hungarian',
            'hy'=>'Armenian',
            'ia'=>'Interlingua',
            'id'=>'Indonesian',
            'ie'=>'Interlingue',
            'ig'=>'Igbo',
            'ik'=>'Inupiak',
            'is'=>'Icelandic',
            'it'=>'Italian',
            'iu'=>'Inuktitut',
            'iw'=>'Hebrew',
            'ja'=>'Japanese',
            'jw'=>'Javanese',
            'ka'=>'Georgian',
            'kha'=>'Khasi',
            'kk'=>'Kazakh',
            'kl'=>'Greenlandic',
            'km'=>'Khmer',
            'kn'=>'Kannada',
            'ko'=>'Korean',
            'ks'=>'Kashmiri',
            'ku'=>'Kurdish',
            'ky'=>'Kyrgyz',
            'la'=>'Latin',
            'lb'=>'Luxembourgish',
            'lg'=>'Ganda',
            'lif'=>'Limbu',
            'ln'=>'Lingala',
            'lo'=>'Laothian',
            'lt'=>'Lithuanian',
            'lv'=>'Latvian',
            'mfe'=>'Mauritian Creole',
            'mg'=>'Malagasy',
            'mi'=>'Maori',
            'mk'=>'Macedonian',
            'ml'=>'Malayalam',
            'mn'=>'Mongolian',
            'mr'=>'Marathi',
            'ms'=>'Malay',
            'mt'=>'Maltese',
            'my'=>'Burmese',
            'na'=>'Nauru',
            'ne'=>'Nepali',
            'nl'=>'Dutch',
            'no'=>'Norwegian',
            'nr'=>'Ndebele',
            'nso'=>'Pedi',
            'ny'=>'Nyanja',
            'oc'=>'Occitan',
            'om'=>'Oromo',
            'or'=>'Oriya',
            'pa'=>'Punjabi',
            'pl'=>'Polish',
            'ps'=>'Pashto',
            'pt'=>'Portuguese',
            'qu'=>'Quechua',
            'rm'=>'Rhaeto Romance',
            'rn'=>'Rundi',
            'ro'=>'Romanian',
            'ru'=>'Russian',
            'rw'=>'Kinyarwanda',
            'sa'=>'Sanskrit',
            'sco'=>'Scots',
            'sd'=>'Sindhi',
            'sg'=>'Sango',
            'si'=>'Sinhalese',
            'sk'=>'Slovak',
            'sl'=>'Slovenian',
            'sm'=>'Samoan',
            'sn'=>'Shona',
            'so'=>'Somali',
            'sq'=>'Albanian',
            'sr'=>'Serbian',
            'ss'=>'Siswant',
            'st'=>'Sesotho',
            'su'=>'Sundanese',
            'sv'=>'Swedish',
            'sw'=>'Swahili',
            'syr'=>'Syriac',
            'ta'=>'Tamil',
            'te'=>'Telugu',
            'tg'=>'Tajik',
            'th'=>'Thai',
            'ti'=>'Tigrinya',
            'tk'=>'Turkmen',
            'tl'=>'Tagalog',
            'tlh'=>'Klingon',
            'tn'=>'Tswana',
            'to'=>'Tonga',
            'tr'=>'Turkish',
            'ts'=>'Tsonga',
            'tt'=>'Tatar',
            'ug'=>'Uighur',
            'uk'=>'Ukrainian',
            'ur'=>'Urdu',
            'uz'=>'Uzbek',
            've'=>'Venda',
            'vi'=>'Vietnamese',
            'vo'=>'Volapuk',
            'war'=>'Waray Philippines',
            'wo'=>'Wolof',
            'xh'=>'Xhosa',
            'yi'=>'Yiddish',
            'yo'=>'Yoruba',
            'za'=>'Zhuang',
            'zh'=>'Chinese Simplified',
            'zh-Hant'=>'Chinese Traditional',
            'zu'=>'Zulu'};
         Decimal probability = 0.0;
        if(jsonParsedData!=null){
            for(cls_detections languageDetection  : jsonParsedData.data.detections){
                if(languageDetection.language!='en' && languageDetection.confidence >probability ){
                    
                    if(detectlanguageConversions!=null && detectlanguageConversions.get(languageDetection.language)!=null)
                    {
                        inboundEmailLanguage = detectlanguageConversions.get(languageDetection.language);
                    }else{
                        inboundEmailLanguage = languageDetection.language;
                    }
                    if(languageDetection.isReliable) 
                    {
                        break;
                    }                  
                }                
            }
        }
        detectedLangResponse = 'Begin JSON >>>>>>>>    '+jsonParsedData+'     <<<<<<<<End JSOn Resp' +'  we selected following InboundEmail language >>>'+inboundEmailLanguage ;
        system.debug('inboundEmailLanguage -->'+inboundEmailLanguage); 
        return inboundEmailLanguage;
    }
    public Case createCase(id AccountId){
        //To Detect Language
        
        case c = new case();
        //creating a new case record
        if(AccountId!=null)
        {
            system.debug('has account id::'+AccountId);
            Account a = [select id,PersonContactId  from account where id=:AccountId ]; 
            c.contactid=a.PersonContactId;
        }
                        
        c.Inbound_Language__c = DetectedLanguage ;
        
        system.debug('person contact is'+c.contactid);
        c.AccountId = AccountId;
        c.Status = 'Open';
        c.Type = 'General';
        c.Origin = 'Web';
        c.Received_Via__c= 'Customer Care';
        c.Received_Date__c = Date.Today();
        c.Subject= emailSubject;
        c.Description= bodyText;
        c.ownerid= '00G0n000000QRDT';
        insert c;                 
        
        // creating a new email record 
        EmailMessage em = new EmailMessage();
        em.FromAddress='web@delta.com'; // need to replace this
        em.FromName='Web';
        em.TextBody=bodyText;
        em.ParentId=c.id;
        em.Subject =emailSubject;
        insert em; 
        return c;
    }
    public string checkEmail(string email){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', email.trim())){
            if(email.contains('<')){
                return email.substring(0, email.indexOf('<'));
            }            
        }
        return email; 
    } 
    
    public string checkPhone(string Phone){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', Phone.trim())){
            if(Phone.contains('<')){
                return Phone.substring(0, Phone.indexOf('<'));
            }            
        }
        return Phone; 
    } 
    
    public string checkSkymiles(string Skymiles){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', Skymiles.trim())){
            if(Skymiles.contains('<')){
                return Skymiles.substring(0, Skymiles.indexOf('<'));
            }            
        }
        return Skymiles; 
    } 
    
    public string checkFlyingBlue(string FlyingBlue){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', FlyingBlue.trim())){
            if(FlyingBlue.contains('<')){
                return FlyingBlue.substring(0, FlyingBlue.indexOf('<'));
            }            
        }
        return FlyingBlue; 
    } 
    
    public string checkFormName(string FormName){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', FormName.trim())){
            if(FormName.contains('<')){
                return FormName.substring(0, FormName.indexOf('<'));
            }            
        }
        return FormName; 
    } 
    
    public string checkStreetAddress1(string StreetAddress1){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', StreetAddress1.trim())){
            if(StreetAddress1.contains('<')){
                return StreetAddress1.substring(0, StreetAddress1.indexOf('<'));
            }            
        }
        return StreetAddress1; 
    } 
    
    public string checkStreetAddress2(string StreetAddress2){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', StreetAddress2.trim())){
            if(StreetAddress2.contains('<')){
                return StreetAddress2.substring(0, StreetAddress2.indexOf('<'));
            }            
        }
        return StreetAddress2;   
    } 
    
    public string checkPostalCode(string PostalCode){  
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', PostalCode.trim())){
            if(PostalCode.contains('<')){
                return PostalCode.substring(0, PostalCode.indexOf('<'));
            }            
        }
        return PostalCode; 
        
    } 
    
    public string checkSubject(string Subject){   
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', Subject.trim())){
            if(Subject.contains('<')){
                return Subject.substring(0, Subject.indexOf('<'));
            }            
        }
        return Subject; 
    }
    
    public cls_data data;
    public class cls_data {
        public List<cls_detections> detections;
    }
    public class cls_detections {
        public String language; //ta
        public boolean isReliable;
        public Double confidence;   //10.24
    }
    
}