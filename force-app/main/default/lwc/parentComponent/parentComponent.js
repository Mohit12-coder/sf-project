import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    childMessage= 'No Message Recieved';

    storeMessage(event){
        console.log(event.detail);
        this.childMessage = event.detail;
    }
}