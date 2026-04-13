import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext, unsubscribe } from 'lightning/messageService';
import SAMPLEMC from '@salesforce/messageChannel/MyChannel__c';
export default class Subscriber extends LightningElement {

    receivedMessage="";
    subscription;

    @wire(MessageContext)
        context

    subscribeMessage(){
        this.subscription=subscribe(
            this.context,
            SAMPLEMC,
            (message) => {this.handleMessage(message)}
        );
        console.log("subscribing message");
    }

    handleMessage(message) {
        
        this.receivedMessage = message.lmsData.value ? message.lmsData.value : "No Message Publish";

        
        console.log(message.lmsData.value);
    }

    unsubscribeMessage(){
        if (this.subscription) {
            unsubscribe(this.subscription);
            this.subscription = null;
            console.log('Unsubscribed successfully');
        }
    }

}