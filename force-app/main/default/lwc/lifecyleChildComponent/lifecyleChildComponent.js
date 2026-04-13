import { LightningElement } from 'lwc';

export default class LifecyleChildComponent extends LightningElement {

    constructor(){
        //super();
        console.log("Call Recieved From Child Construtor");

    }

    connectedCallback(){
        console.log("Call Recieved From Child connectedCallback");
    }

    renderedCallback(){
        console.log("Call Recieved From Child renderedCallback");
    }

    disconnectedCallback(){
        console.log("Call Recieved From Child disconnectedCallback");
    }

}