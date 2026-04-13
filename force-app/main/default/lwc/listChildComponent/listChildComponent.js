import { LightningElement, api } from 'lwc';

export default class ListChildComponent extends LightningElement {

    msgc="childnew";

    @api handleChange(){
        this.msgc = 'child';
    }



}