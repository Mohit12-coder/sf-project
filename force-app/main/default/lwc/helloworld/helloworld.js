import { LightningElement } from 'lwc';

export default class Helloworld extends LightningElement {
    greets ='';

    handleClick(event){
        this.greets = this.template.querySelctor("lightning-input").value;
    }
}
