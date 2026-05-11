import { LightningElement, track } from 'lwc';
import getRelatedRecords from '@salesforce/apex/MultiContactViewerController.getRelatedRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MultiContactViewer extends LightningElement {

    @track selectedContacts = [];
    @track groupedRecords = [];
    @track casesList = [];
    @track tasksList = [];

    isLoading = false;
    isModalOpen = false;

    handleContactSelection(event) {

        this.selectedContacts = JSON.parse(JSON.stringify(event.detail) );

        this.fetchRelatedRecords();
    }

    handleRemoveContact(event) {
        const contactId =event.detail;
        this.selectedContacts = this.selectedContacts.filter(contact => contact.contactId !== contactId );
        this.fetchRelatedRecords();
    }

    fetchRelatedRecords() {
        const contactIds = this.selectedContacts.map( contact => contact.contactId);

        if(contactIds.length === 0) {
            this.groupedRecords = [];
            this.casesList = [];
            this.tasksList = [];
            return;
        }

        this.isLoading = true;

        getRelatedRecords({ contactIds })

            .then(result => {
                this.groupedRecords = [...result];
                this.casesList = [];
                this.tasksList = [];

                result.forEach(record => {
                    this.casesList = [ ...this.casesList, ...record.casesList];
                    this.tasksList = [ ...this.tasksList, ...record.tasksList];
                });

                const hasAnyRecords = this.groupedRecords.some(record => { return ( record.casesList.length > 0 || record.tasksList.length > 0);});
                
                if(!hasAnyRecords) {
                    this.showToast('No Records', 'No Cases or Tasks Found', 'info');
                }

            }).catch(error => {
                console.error(error);

                let errorMessage ='Something went wrong';

                if(error?.body?.message) {
                    errorMessage = error.body.message;
                }
                else if(error?.message) {
                    errorMessage =error.message;
                }
                this.showToast('Error', errorMessage,'error');

            }).finally(() => {this.isLoading = false;});
    }

    handleOpenFullscreen() {
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title,message,variant}));
    }

    get showRecordsSection() {
        return this.selectedContacts.length > 0;
    }
}