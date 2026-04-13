import { LightningElement,api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['Account.Name', 'Account.Phone', 'Account.Industry'];

export default class GetRecordLds extends LightningElement {

    @api recordId;

    account;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            this.account = data;
            console.log('Record Data:', data);
        } else if (error) {
            console.error('Error:', error);
        }
    }

   
    get name() {
        return this.account?.fields?.Name?.value;
    }

    get phone() {
        return this.account?.fields?.Phone?.value;
    }

    get industry() {
        return this.account?.fields?.Industry?.value;
    }

}