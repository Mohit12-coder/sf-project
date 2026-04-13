import { LightningElement } from 'lwc';
import getAccount from'@salesforce/apex/AccountApexClass.getAccount';
const columns = [
        {label : 'Account Id',fieldName:'Id'},
        {label:'Name',fieldName:'Name'},
        {label:'Phone',fieldName:'Phone'},
        {label:'Industry',fieldName:'Industry'},
        
    ]

export default class ImparativesDemo extends LightningElement {

    columns=columns;

    data=[];


    handleClick(){
        getAccount().then(result => {WireAccountDemo({data,error})
                this.data = data;
                this.error = undefined;
                console.log('Data:', result);
            })
            .catch(error => {
                this.error = error;
                this.data = [];
                console.error('Error:', error);
            });

       
    }

}