import { LightningElement, api } from 'lwc';

export default class SelectedContactPills extends LightningElement {
    @api contacts = [];

    handleRemove(event) { 
        const contactId = event.target.name;

        this.dispatchEvent( new CustomEvent( 'removecontact', {detail: contactId}));
    }
}