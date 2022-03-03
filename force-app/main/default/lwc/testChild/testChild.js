/* eslint-disable no-alert */
import { api, LightningElement, track } from 'lwc';

export default class TestChild extends LightningElement {

    @api
    accountId;

    constructor() {
        super();

        console.log(`child constructor`);
    }

    connectedCallback() {
        console.log(`child connectedCallback ${this.accountId}`);
    }

    renderedCallback() {
        console.log(`child renderedCallback ${this.accountId}`);
    }
    
    disconnectedCallback() {
        console.log(`child disconnectedCallback ${this.accountId}`);
    }
    
    errorCallback(error, stack) {
        console.log(`child error ${JSON.stringify(error)}`);
        console.log(`child stack ${JSON.stringify(stack)}`);
    }

    handleClickMe() {
        const someEvent = CustomEvent('aneventfromchild', {
            detail: this.accountId
        });
        this.dispatchEvent(someEvent);
    }

    @api
    handleExternalCall() {
        alert('someonecalledme: ' + this.accountId); 
    }
}