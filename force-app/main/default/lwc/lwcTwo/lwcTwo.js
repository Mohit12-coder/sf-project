import { LightningElement } from 'lwc';

export default class LwcTwo extends LightningElement {

    firstName='';
    lastName='';
    email='';
    phone='';
    title='';

    handleChange(event){
        const field = event.target.name;
        this[field] = event.target.value;
    }

    handleSave(){
        console.log()
    }

}