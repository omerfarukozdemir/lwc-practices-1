import { api, LightningElement } from 'lwc';

export default class TestChild extends LightningElement {

    @api
    accountId;

    constructor() {
        super();
        console.log(`child constructor ${this.accountId}`);
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
}