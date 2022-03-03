import { LightningElement, api, wire, track } from 'lwc';
import readAccountsWire from '@salesforce/apex/testController.readAccounts';

export default class TestParent extends LightningElement {

    @track
    error;

    @track
    stack;

    @track
    accountRecords;

    handleClickReadAccounts() {
        readAccountsWire()
            .then(result => {
                this.accountRecords = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    constructor() {
        super();
        console.log('parent constructor');
    }

    connectedCallback() {
        console.log('parent connectedCallback');
    }

    renderedCallback() {
        console.log('parent renderedCallback');
    }
    
    disconnectedCallback() {
        console.log('parent disconnectedCallback');
    }
    
    errorCallback(error, stack) {
        console.log(`parent error ${JSON.stringify(error)}`);
        console.log(`parent stack ${JSON.stringify(stack)}`);

        this.error = error;
        this.stack = stack;
    }

}