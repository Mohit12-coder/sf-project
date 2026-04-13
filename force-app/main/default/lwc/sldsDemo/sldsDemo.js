import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SldsDemo extends LightningElement {

    @api recordId;
    
    @track isModalOpen = false;
    updatedData = {};


    handleError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Something went wrong!',
                variant: 'error'
            })
        );
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        inputFields.forEach(field => field.reset());
    }

    handleSuccess(event) {

        this.updatedData = event.detail.fields;

        this.isModalOpen = true;

        // this.dispatchEvent(
        //     new ShowToastEvent({
        //         title: 'Success',
        //         message: 'Account updated successfully!',
        //         variant: 'success'
        //     })
        // );
    }

    closeModal(){
        this.isModalOpen = false;
    }
}