({
    doInit: function(component, event, helper) {          
        var skyMilesNumberCheck = component.get('v.skyMilesNumber');
        var flyingBlueNumberCheck = component.get('v.LoyaltyNumber');
        if(skyMilesNumberCheck!='' || flyingBlueNumberCheck!=''){
            helper.getAccountsFromSFDC(component);
            helper.getAccountsFROMWSDL(component);
        }else{
            component.set("v.contantVisible",false);
            component.set("v.spinnerVisible",false);
        }
        //helper.initThisAccount(component);
        
    },
    formPress: function(component, event, helper) { 
        component.set('v.SearchErrorMessage','');
        if (event.keyCode === 13) {
           // var validity = component.find("skymilesID").get("v.validity");
            //if(validity.valid){
                helper.searchDetail(component); 
            //}
        }
    },
    doSearch: function(component, event, helper) {   
        helper.searchDetail(component);
    } ,
    showOtherDatabaseValue : function(component, event, helper) {
        component.set("v.spinnerVisible",true);
        var dBNameVal = component.get('v.dataBaseName');
        var skyMilesNumberTemp = component.get('v.skyMilesNumber');
        var flyingBlueNumberTemp = component.get('v.LoyaltyNumber');
        if(dBNameVal=='Loyalty'){
            component.set('v.skyMilesNumber','');
        }else{
            component.set('v.LoyaltyNumber','');
        }
        helper.getAccountsFROMWSDL(component);
        component.set('v.skyMilesNumber',skyMilesNumberTemp);
        component.set('v.LoyaltyNumber',flyingBlueNumberTemp);
        
    },
    handleMenuSelect: function(component, event, helper) {
        var FieldName = event.getParam("value");        
        var menuItem = event.getSource().get("v.name");
        
        if(FieldName=='OtherAddress'){
            component.set('v.newAccount.PersonOtherStreet', menuItem.PersonMailingStreet);
            component.set('v.newAccount.PersonOtherCity', menuItem.PersonMailingCity);
            component.set('v.newAccount.PersonOtherState', menuItem.PersonMailingState);
            component.set('v.newAccount.PersonOtherPostalCode', menuItem.PersonMailingPostalCode);
        }        
        if(FieldName=='MailingAddress'){
            component.set('v.newAccount.PersonMailingStreet', menuItem.PersonMailingStreet);
            component.set('v.newAccount.PersonMailingCity', menuItem.PersonMailingCity);
            component.set('v.newAccount.PersonMailingState', menuItem.PersonMailingState);
            component.set('v.newAccount.PersonMailingPostalCode', menuItem.PersonMailingPostalCode);
        }
        if(FieldName=='otherphone'){
            component.set('v.newAccount.PersonOtherPhone', menuItem);
        }
        if(FieldName=='Mobile'){
            component.set('v.newAccount.PersonMobilePhone', menuItem);
        }
        if(FieldName=='PhoneNo'){
            component.set('v.newAccount.Phone', menuItem);
        }
        if(FieldName=='workemail'){
            component.set('v.newAccount.Work_Email__pc', menuItem);
        }
        if(FieldName=='otheremail'){
            component.set('v.newAccount.Other_Email__pc', menuItem);
        }
        if(FieldName=='emailAdd'){
            component.set('v.newAccount.PersonEmail', menuItem);
        }
        //{!v.WSDLAccount.dataBaseNumber} component.get("v.WSDLAccount.dataBaseNumber")
        //component.set('v.newAccount.SkyMiles_Number__pc', '2363804002');
        ///*   system.debug('LDetails-->'+wsdlAccount);
        
       if(component.get('v.dataBaseName')=='FlyingBlue'){
            component.set('v.newAccount.Flying_Blue_Status__pc',component.get("v.WSDLAccount.dataBaseStatus"));
            component.set('v.newAccount.Current_Miles_FB__pc',component.get("v.WSDLAccount.CurrentMiles"));
            component.set('v.newAccount.Flying_Blue_Number__pc',component.get("v.WSDLAccount.dataBaseNumber"));
        }else{
            component.set('v.newAccount.SkyMiles_Status__pc',component.get("v.WSDLAccount.dataBaseStatus"));
            component.set('v.newAccount.Current_Miles__pc',component.get("v.WSDLAccount.CurrentMiles"));
            component.set('v.newAccount.SkyMiles_Number__pc',component.get("v.WSDLAccount.dataBaseNumber"));
        }
        
    },
    
    
    updateValue:function(component, event, helper) {  
        var selectedValue = event.getSource().get("v.text");
        var selectedV = event.getSource();
        var FieldName = event.getSource().get("v.name");
        if(FieldName=='PersonName'){
            //component.find('AccName').set('v.value',selectedValue);
            component.set('v.newAccount.FirstName', component.get('v.WSDLAccount.FirstName'));
            component.set('v.newAccount.LastName', component.get('v.WSDLAccount.LastName'));
        }
        if(FieldName=='PersonMailingStreet'){
            //component.find('AccMailingStreet').set('v.value',selectedValue);
            component.set('v.newAccount.PersonMailingStreet', selectedValue);
        }
        if(FieldName=='PersonMailingState'){
            //component.find('AccMailingState').set('v.value',selectedValue);
            component.set('v.newAccount.PersonMailingState', selectedValue);
        }
        if(FieldName=='PersonMailingCity'){
            //component.find('AccMailingCity').set('v.value',selectedValue);
            component.set('v.newAccount.PersonMailingCity', selectedValue);
        }        
        if(FieldName=='PersonMailingPostalCode'){
            //component.find('AccPostalCode').set('v.value',selectedValue);
            component.set('v.newAccount.PersonMailingPostalCode', selectedValue);
        }
        if(FieldName=='PersonEmail'){
            //component.find('AccPersonEmail').set('v.value',selectedValue);
            component.set('v.newAccount.PersonEmail', selectedValue);
        }
        if(FieldName=='Phone'){
            component.set('v.newAccount.Phone', selectedValue);
        }
    },
    noRecordformPress: function(component, event, helper) {
        if (event.keyCode === 13) {
            window.location.href = '/'+component.get('v.recordId');
        }
    },
    backToAccount: function(component, event, helper) {	
        window.location.href = '/'+component.get('v.recordId');
    },
    updateNewValue : function(component, event, helper) {
        helper.updateAccountDetails(component);
        
        
    }
})