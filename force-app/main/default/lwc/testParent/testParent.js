/* eslint-disable no-alert */
import { LightningElement, api, wire, track } from 'lwc';
import readAccountsFromApex from '@salesforce/apex/testController.readAccounts';
import countAccountsFromApex from '@salesforce/apex/testController.countAccounts';

export default class TestParent extends LightningElement {

    @track
    error;

    @track
    stack;

    @track
    accountRecords;
    
    @track
    accountRecordCount = 0;

    @track
    title = '';

    async init() {
        try {
            this.accountRecordCount = await countAccountsFromApex();
            this.title = 'Total Account: ' + this.accountRecordCount;
        } catch (error) {
            this.error = error;
        }
    }

    handleClickReadAccounts() {
        readAccountsFromApex()
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
        this.init();
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

    handleButtonEventFromChild(event) {
        alert('clicked on child record: ' + event.detail);
    }

    handleClickPokeChilds() {
        /*let childComponent = this.template.querySelector('c-test-child[accountId="0017Q000003d23HQAQ"]');
        if (childComponent)
            childComponent.handleExternalCall();
        */
        this.template.querySelectorAll('c-test-child').forEach(element => {
            if (element.accountId === '0017Q000003d23HQAQ')
                element.handleExternalCall();
        });
    }

}