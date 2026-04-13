import { LightningElement } from 'lwc';

export default class LifecycleHooksExample extends LightningElement {

    isVisible = true;

    constructor(){
        super();
        console.log("Call Recieved From Construtor");

    }

    connectedCallback(){
        console.log("Call Recieved From connectedCallback");
    }


    renderedCallback(){
        console.log("Call Recieved From renderedCallback");
    }

    errorCallback(){
        console.log("Call Recieved From errorCallback");
    }

    handleClick(){
        this.isVisible = !this.isVisible;
    }
    
    disconnectedCallback(){
        console.log("Call Recieved From disconnectedCallback");
    }
    
}