import { LightningElement } from 'lwc';

export default class NewSldsComponentExample extends LightningElement {
    firstName = '';
    lastName = '';
    Name ='';

    handleChange(event){
        const field = event.target.name;

        if(field === "fname"){
            this.firstName = event.target.value;
        }
        else if(field === "lname"){
            this.lastName = event.target.value;
        }
    }

    handleSubmit(){
        this.Name = this.firstName + " " + this.lastName ;
    }
}