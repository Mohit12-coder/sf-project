import { LightningElement } from 'lwc';
import { updateRecord, updateRecordRecord } from 'lightning/uiRecordApi';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import STATUS_FIELD from '@salesforce/schema/Account.status__c';
import ID_FIELD from '@salesforce/schema/Account.Id';

export default class CreateAccountLms extends LightningElement {

    name;
    phone;
    industry;
     
    handleChange(event) {
        const field = event.target.name;
        if (field === 'name') {
            this.name = event.target.value;
        } else if (field === 'phone') {
            this.phone = event.target.value;
        } else if (field === 'industry') {
            this.industry = event.target.value;
        }
    }

    createAccount() {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[PHONE_FIELD.fieldApiName] = this.phone;
        fields[INDUSTRY_FIELD.fieldApiName] = this.industry;
        fields[STATUS_FIELD.fieldApiName] = 'Active';
        fields[ID_FIELD.fieldApiName] = '001gL00000m9ePCQAY';


        const recordInput = {
            apiName: ACCOUNT_OBJECT.objectApiName,
            fields: fields
        };

        console.log("success")
        updateRecord(recordInput)
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account Created with Id: ' + result.id,
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                console.log(error)
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

}