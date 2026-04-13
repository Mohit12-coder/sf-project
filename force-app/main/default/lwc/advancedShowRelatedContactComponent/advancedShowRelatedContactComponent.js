import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getContacts from '@salesforce/apex/AccountRelatedContactHandler.getContacts';

// Account fields
const FIELDS = ['Account.Status__c', 'Account.Type'];

export default class AdvancedShowRelatedContactComponent extends NavigationMixin(LightningElement) {

    @api recordId;

    status;
    type;
    contacts = [];
    isLoading = false;

    // 🔹 Get Account Data
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    accountHandler({ data, error }) {
        if (data) {
            this.status = data.fields.Status__c.value;
            this.type = data.fields.Type.value;

            console.log('Status:', this.status);
            console.log('Type:', this.type);

            // ✅ Conditional fetch
            if (this.isEligibleAccount) {
                this.fetchContacts();
            } else {
                this.contacts = [];
            }

        } else if (error) {
            console.error(error);
        }
    }

    // 🔹 Condition
    get isEligibleAccount() {
        return this.status === 'Active' && this.type === 'Customer - Direct';
    }

    // 🔹 Imperative Apex Call
    fetchContacts() {
        this.isLoading = true;

        getContacts({ accountId: this.recordId })
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                console.error(error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    // 🔹 Navigation
    handleNavigate(event) {
        const recordId = event.currentTarget.dataset.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
}