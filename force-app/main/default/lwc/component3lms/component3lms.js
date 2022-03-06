/* eslint-disable no-alert */
import { LightningElement, wire } from 'lwc';
import {publish, subscribe, MessageContext} from 'lightning/messageService';
import AURA_CHANNEL from '@salesforce/messageChannel/AuraChannel__c';
import VF_CHANNEL from '@salesforce/messageChannel/VFChannel__c';
import LWC_CHANNEL from '@salesforce/messageChannel/LWCChannel__c';

export default class Component3lms extends LightningElement {
    @wire(MessageContext)
    messageContext;

    subscribeToAuraMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            AURA_CHANNEL,
            (message) => this.handleAuraMessage(message)
        );
    }

    subscribeToVFMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            VF_CHANNEL,
            (message) => this.handleVFMessage(message)
        );
    }

    handleAuraMessage(message) {
        console.log('LWC ALERT (message from aura)');
        console.log(message.param1 + ' ' + message.param2);
    }

    handleVFMessage(message) {
        console.log('LWC ALERT (message from vfpage)');
        console.log(message.param1 + ' ' + message.param2);
    }

    connectedCallback() {
        this.subscribeToAuraMessageChannel();
        this.subscribeToVFMessageChannel();
    }

    handleSendMessage() {
        var payload = {
            param1: "Message Has Been Sent from LWC",
            param2: "Hello world!"
        };
        publish(this.messageContext, LWC_CHANNEL, payload);
    }
}