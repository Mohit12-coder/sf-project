import { LightningElement,wire } from 'lwc';
import highRevenueAccounts from '@salesforce/apex/AccountController.getHighRevenueAccountRecords';

export default class HighRevenueAccount extends LightningElement {

    accountsToDisplay =[];

    @wire(highRevenueAccounts)
    getAccountsHandler(response){
        const {data, error} = response;
        if(error){
            console.error(error);
            return;
        }
        if(data){
            this.accountsToDisplay = data;
        }


    }


}