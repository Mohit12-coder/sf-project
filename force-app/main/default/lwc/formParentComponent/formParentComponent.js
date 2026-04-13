import { LightningElement } from 'lwc';

export default class FormParentComponent extends LightningElement {
    msgp = 'parent';

    handleClick(){
        this.template.querySelector('c-list-child-component').handleChange();
    }
}