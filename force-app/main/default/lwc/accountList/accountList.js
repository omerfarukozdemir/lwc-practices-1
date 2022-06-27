import { LightningElement, track } from 'lwc';
import readAccounts from '@salesforce/apex/AccountController.listAccounts';
import { getErrorMessage } from "c/utility";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import FAIL_MESSAGE_TITLE from '@salesforce/label/c.ShowToastEventFailMessageTitle';

const COLUMNS = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text'
    },
    {
        label: 'AccountNumber',
        fieldName: 'AccountNumber',
        type: 'text'
    },
    {
        label: 'Site',
        fieldName: 'Site',
        type: 'text'
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone'
    },
]

export default class AccountList extends LightningElement {

    columns = COLUMNS;
    isLoading = false;
    @track
    accountList = [];

    handleLoadAccountList() {
        this.showProductListButton = true;
        this.isLoading = true;
        readAccounts().then(data => {
            this.accountList = data;
        }).catch(error => {
            const errorMessage = getErrorMessage(error);
            this.dispatchEvent(new ShowToastEvent({
                variant: 'error',
                title: FAIL_MESSAGE_TITLE,
                message: errorMessage
            }));
        }).finally(() => {
            this.isLoading = false;
        })

    }

    connectedCallback() {
        this.handleLoadAccountList();
    }
}