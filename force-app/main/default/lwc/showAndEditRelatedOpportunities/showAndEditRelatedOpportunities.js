import { LightningElement, wire } from 'lwc';
import showAccounts from '@salesforce/apex/ShowAllAccounts.showAccounts';
import { NavigationMixin } from 'lightning/navigation';

export default class ShowAndEditRelatedOpportunities extends NavigationMixin(LightningElement) {

    accounts;
    error;

    @wire(showAccounts)
    wiredAccounts({error,data}){
        if(data){
            this.accounts = data;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.accounts = undefined;
        }
    }

    navigateToRecord(event) {
        const recordId = event.currentTarget.dataset.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

}