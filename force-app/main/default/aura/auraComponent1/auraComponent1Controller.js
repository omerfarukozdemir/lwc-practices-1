/* eslint-disable no-console */
/* eslint-disable no-alert */
({
    handleSendMessageClick: function(component, event, helper) {
        var payload = {
            param1: "Message Has Been Sent from Aura",
            param2: "Hello world!"
        };
        component.find("AuraChannel").publish(payload);
    },
    handleLWCMessage: function(component, event, helper) {
        if (event != null && event.getParam("param1") != null) {
            console.log('AURA ALERT (message from lwc)');
            console.log(event.getParam("param1") + ' ' + event.getParam("param2"));
        }
    },
    handleVFMessage: function(component, event, helper) {
        if (event != null && event.getParam("param1") != null) {
            console.log('AURA ALERT (message from vfpage)');
            console.log(event.getParam("param1") + ' ' + event.getParam("param2"));
        }
    }
})