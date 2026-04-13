import { LightningElement, api } from 'lwc';
import searchAccounts from '@salesforce/apex/OpportunityDashboardController.searchAccounts';
import getRecentAccounts from '@salesforce/apex/OpportunityDashboardController.getRecentAccounts';
import updateOpportunityAccount from '@salesforce/apex/OpportunityDashboardController.updateOpportunityAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountLookupCell extends LightningElement {
    @api recordId;
    @api accountId;
    @api accountName;

    isEditMode = false;

    records = [];
    searchText = '';

    selectedAccountId = '';
    selectedAccountName = '';

    showDropdown = false;

    get lookupClass() {
        let css = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        if (this.showDropdown) {
            css += ' slds-is-open';
        }
        return css;
    }

    handleEdit() {
        this.isEditMode = true;
        this.searchText = '';
        this.selectedAccountId = '';
        this.selectedAccountName = '';
        this.loadRecent();
    }

    loadRecent() {
        getRecentAccounts().then(result => {
            this.records = result;
            this.showDropdown = true;
        });
    }

    openDropdown() {
        this.showDropdown = true;

        if (!this.records.length) {
            this.loadRecent();
        }
    }

    handleSearch(event) {
        this.searchText = event.target.value;

        if (!this.searchText || this.searchText.length < 2) {
            this.loadRecent();
            return;
        }

        searchAccounts({ searchText: this.searchText })
            .then(result => {
                this.records = result;
                this.showDropdown = true;
            });
    }

    handleSelect(event) {
        this.selectedAccountId = event.currentTarget.dataset.id;
        this.selectedAccountName = event.currentTarget.dataset.name;
        this.showDropdown = false;
    }

    handleRemoveSelection() {
        this.selectedAccountId = '';
        this.selectedAccountName = '';
        this.searchText = '';
        this.loadRecent();
    }

    handleSave() {
        if (!this.selectedAccountId) {
            return;
        }

        updateOpportunityAccount({opportunityId: this.recordId, accountId: this.selectedAccountId}).then(() => {
                this.accountName = this.selectedAccountName;
                this.isEditMode = false;

                this.dispatchEvent( new ShowToastEvent({title: 'Success', message: 'Account updated', variant: 'success' }));

                this.dispatchEvent( new CustomEvent('refreshdata', { bubbles: true, composed: true}));
            });
    }

    handleCancel() {
        this.isEditMode = false;
        this.showDropdown = false;
    }
}