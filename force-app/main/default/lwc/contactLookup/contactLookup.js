import { LightningElement, api, track } from 'lwc';
import searchContacts from '@salesforce/apex/MultiContactViewerController.searchContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactLookup extends LightningElement {

    @api selectedContacts = [];
    @track searchResults = [];

    showDropdown = false;
    debounceTimeout;

    handleSearch(event) {

        const searchKey = event.target.value;

        clearTimeout( this.debounceTimeout );
        this.debounceTimeout = setTimeout(() => {
                if(!searchKey) {
                    this.searchResults = [];
                    this.showDropdown = false;
                    return;
                }
                searchContacts({ searchKey }).then(result => {
                        this.showDropdown = true;
                        this.searchResults = result;
                    }).catch(error => {
                        this.showToast( 'Error', error.body.message, 'error');
                    });
            }, 400);
    }


    get processedSearchResults() {
        return this.searchResults.map(contact => {
            return {...contact, isSelected: this.selectedContacts.some( selected => selected.contactId === contact.contactId )};             
        });
    }

    handleCheckboxChange(event) {

        const contactId = event.target.dataset.id;
        const checked = event.target.checked;

        const selectedContact = this.searchResults.find( contact => contact.contactId=== contactId);
        let updatedContacts = [...this.selectedContacts];

        if(checked) {
            if(updatedContacts.length >= 10) {
                this.showToast( 'Limit Reached', 'Maximum 10 contacts allowed', 'warning');
                return;
            }

            const alreadyExists = updatedContacts.some( contact => contact.contactId === contactId);

            if(!alreadyExists) {
                updatedContacts.push( selectedContact);
            }
        }
        else {
            updatedContacts = updatedContacts.filter( contact => contact.contactId !== contactId);
        }
        this.dispatchEvent(new CustomEvent('contactselection', { detail: updatedContacts}));
    }

    showToast(title, message, variant) {
        this.dispatchEvent( new ShowToastEvent({ title, message, variant}));
    }
}