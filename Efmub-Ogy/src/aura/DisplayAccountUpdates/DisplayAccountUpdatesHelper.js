({
    getAccountsFromSFDC: function(component) {
        var action = component.get('c.getAccountsFromSFDC');
        action.setParams({ AccountRecId : component.get("v.recordId")});
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.existingAccount', actionResult.getReturnValue());
            component.set('v.newAccount', actionResult.getReturnValue());
            
            
        });
        $A.enqueueAction(action);
    },
    searchDetail :function(component){
        
        var SMVal = component.get('v.skyMilesNumberTemp');
        var FBVal = component.get('v.LoyaltyNumberTemp');
        if((SMVal==null ||SMVal=='') && (FBVal==null||FBVal=='')){
            component.set('v.SearchErrorMessage','Please enter value');
        }else{
        if(!((SMVal!=null && SMVal.length > 0 && SMVal.length < 10) ||(FBVal!=null && FBVal.length > 0 && FBVal.length < 10))){
         component.set("v.contantVisible",true);
            component.set("v.spinnerVisible",true);
            component.set('v.skyMilesNumber',component.get('v.skyMilesNumberTemp'));
            component.set('v.LoyaltyNumber',component.get('v.LoyaltyNumberTemp'));
            this.getAccountsFromSFDC(component);
            this.getAccountsFROMWSDL(component);
        }
        }
    },
    initThisAccount : function(component) {
        var self = this;  
        var initAction = component.get("c.newAccount");
        initAction.setCallback(self, function(a) {
            component.set("v.newAccount", a.getReturnValue());
            component.set('v.newAccount.FirstName', component.get('v.existingAccount.FirstName'));
            component.set('v.newAccount.LastName', component.get('v.existingAccount.LastName'));
            component.set('v.newAccount.PersonMailingStreet', component.get('v.existingAccount.PersonMailingStreet'));
            component.set('v.newAccount.PersonMailingState', component.get('v.existingAccount.PersonMailingState'));
            component.set('v.newAccount.PersonMailingCity', component.get('v.existingAccount.PersonMailingCity'));
            component.set('v.newAccount.PersonMailingPostalCode', component.get('v.existingAccount.PersonMailingPostalCode'));
            component.set('v.newAccount.PersonEmail', component.get('v.existingAccount.PersonEmail'));
            component.set('v.newAccount.Phone', component.get('v.existingAccount.Phone'));
            
    });
        
        // Enqueue the action
        $A.enqueueAction(initAction);
    },
    getAccountsFROMWSDL: function(component) {
        var action = component.get('c.getAccountsFROMWSDL');
        action.setParams({ skyMilesNumber : component.get('v.skyMilesNumber'),
                          LoyaltyNumber : component.get('v.LoyaltyNumber'),
                         accountId : component.get('v.recordId')});
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.WSDLAccount', actionResult.getReturnValue());
             
            if(actionResult.getReturnValue()==null){
                component.set("v.contantVisible",false);
            }else{
                component.set('v.dataBaseName', component.get('v.WSDLAccount').dBName);
            	console.log(component.get('v.dataBaseName'));
                component.set("v.contantVisible",true);
            }
            component.set("v.spinnerVisible",false);
        });     
        //console.dir(component.get('v.WSDLAccount'));
       
        $A.enqueueAction(action);
    },
    updateAccountDetails: function(component){
        console.log('save:1');
        var action = component.get("c.getUpdateAccount");
        var accountD = component.get("v.newAccount");
        var wsdlAccount = component.get("v.WSDLAccount");
        action.setParams({"accountRec": accountD });
        //var self = this;
        action.setCallback(self, function(actionResult) {  
            //alert(actionResult.getReturnValue());
            var returnVal = actionResult.getReturnValue();
            if(returnVal=='Success'){
            window.location.href = '/'+component.get('v.recordId');
            }else{
                component.set("v.accountUpdateError",true);
                component.set("v.accountUpdateErrorMessage",returnVal);
                
            }
        }); 
        $A.enqueueAction(action);
    }
})