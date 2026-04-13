import { LightningElement, wire,api } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import getContacts from '@salesforce/apex/AccountRelatedContactHandler.getContacts';

const FIELDS = ['Account.Status__c', 'Account.Type'];

export default class ShowRelatedContact extends LightningElement {

    @api recordId;
    contacts =[];
    status;
    type;
   

    @wire (getRecord,{recordId : '$recordId', fields : FIELDS})
    accountHandler({data,error}){
        if(data){
            this.status = data.fields.Status__c.value;
            this.type = data.fields.Type.value;

            console.log(this.status);
            console.log(this.type);
        }
        else if(error){
            console.error(error);
        }
    }
    
    

    get isEligibleAccount(){
        
         return this.status === 'Active' && this.type ==='Customer - Direct';
    }


    @wire(getContacts, {accId : '$recordId'})
    contactHandler({data,error}){
        if(data){
            this.contacts = data;
        }
        else if(error){
            console.error(error);
        }
    }

}