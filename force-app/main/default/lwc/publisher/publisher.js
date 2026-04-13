import { LightningElement ,wire} from 'lwc';
import SAMPLEMC from '@salesforce/messageChannel/MyChannel__c';
import { publish, MessageContext } from 'lightning/messageService';

export default class Publisher extends LightningElement {

    inputValue;

    @wire(MessageContext)
    context;

    inputHandler(event){
        this.inputValue= event.target.value;

        console.log("input handled");
    }

    publishMessage(){
        const message = {lmsData :{value: this.inputValue}};

        publish(this.context, SAMPLEMC, message);

        console.log("published");
    }

}