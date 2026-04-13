import { LightningElement, api } from 'lwc';
import updateOpportunityRecords from '@salesforce/apex/OpportunityDashboardController.updateOpportunityRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OpportunityList extends LightningElement {
    @api records = [];
    @api pageNumber = 1;
    @api totalPages = 1;
    @api isLoading = false;

    draftValues = [];

    columns = [
        { label: 'Name', fieldName: 'Name', editable: true},
        { label: 'Stage', fieldName: 'StageName', editable: true},
        { label: 'Amount', fieldName: 'Amount', type: 'currency', editable: true},
        { label: 'Probability', fieldName: 'Probability', type: 'number', editable: true},
        { label: 'Account Name', fieldName: 'accountName', type: 'accountLookup', typeAttributes: { recordId: { fieldName: 'Id' }, accountId: { fieldName: 'AccountId' }, accountName: { fieldName: 'accountName' } }}
    ];

    get disablePrevious() {
        return this.pageNumber <= 1;
    }

    get disableNext() {
        return this.pageNumber >= this.totalPages;
    }

    handlePrevious() {
        this.dispatchEvent( new CustomEvent('previous', { bubbles: true, composed: true}));
    }

    handleNext() {
        this.dispatchEvent(  new CustomEvent('next', { bubbles: true, composed: true}));
    }

    handleSave(event) {
        const drafts = event.detail.draftValues;

        if (!drafts || drafts.length === 0) {
            return;
        }

        updateOpportunityRecords({ oppList: drafts })
            .then(() => {
                this.draftValues = [];

                this.dispatchEvent( new ShowToastEvent({ title: 'Success', message: 'Records updated successfully', variant: 'success'}));

                this.dispatchEvent( new CustomEvent('refreshdata', { bubbles: true, composed: true }));
            })
            .catch(() => {
                this.dispatchEvent( new ShowToastEvent({ title: 'Error', message: 'Update failed', variant: 'error' }));
            });
    }
}