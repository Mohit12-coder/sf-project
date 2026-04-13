import { LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
    sendToParent(){
        const inputValue = this.template.querySelector('lightning-input').value;
        let evt = new CustomEvent('send', {detail : inputValue});
        this.dispatchEvent(evt);
    }
}