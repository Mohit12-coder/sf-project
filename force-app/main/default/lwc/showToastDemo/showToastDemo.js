import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class ShowToastDemo extends LightningElement {

    handleClick(){
        const event = new ShowToastEvent({
            title : 'ShowToastDeom',
            message : 'toats massage',
            variant : 'info'

        })

        this.dispatchEvent(event);
    }

    
}