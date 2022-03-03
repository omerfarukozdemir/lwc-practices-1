import { LightningElement, api, wire, track } from 'lwc';
import readAccountsFromApex from '@salesforce/apex/testController.readAccounts';
import countAccountsFromApex from '@salesforce/apex/testController.countAccounts';

export default class MultipleApexCall extends LightningElement {
    
    async handleApexCalls() { 
        let firstMethodPromise = countAccountsFromApex();
        let secondMethodPromise = readAccountsFromApex();
        await Promise.all([firstMethodPromise, secondMethodPromise])
            .then(results => {
                console.log('results 0: ' + JSON.stringify(results[0]));
                console.log('results 1: ' + JSON.stringify(results[1]));
            }).catch(errors => {
                console.log(JSON.stringify(errors))
            }).finally(() => {
                console.log('promise all finished');
            });
    }

    connectedCallback() {
        console.log('connectedCallback');
        this.handleApexCalls();
    }

    handleClickCallChained() {
        countAccountsFromApex()
            .then(result => {
                console.log('Chain 1 result: ' + JSON.stringify(result))
                readAccountsFromApex()
                    .then(result2 => {
                        console.log('Chain 2 result: ' + JSON.stringify(result2))
                    }).catch(error2 => {
                        console.log('Chain 2 error: ' + JSON.stringify(error2))
                    });
            })
            .catch(error => {
                console.log('Chain 1 error: ' + JSON.stringify(error))
            });
    }

    handleClickCallSametime() {
        this.handleApexCalls();
    }
}