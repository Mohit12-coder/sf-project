import { LightningElement,wire } from 'lwc';
import getAccount from'@salesforce/apex/AccountApexClass.getAccount';

 const columns = [
        {label : 'Account Id',fieldName:'Id'},
        {label:'Name',fieldName:'Name'},
        {label:'Phone',fieldName:'Phone'},
        {label:'Industry',fieldName:'Industry'},
        
    ]

export default class WireAccountDemo extends LightningElement {


   columns=columns;

    data=[];

    @wire(getAccount)
    wireAccount({error,data}){
        if(data){
            this.data=data;
        }
        if(error){
            console.log(error); 
        }
    }

}