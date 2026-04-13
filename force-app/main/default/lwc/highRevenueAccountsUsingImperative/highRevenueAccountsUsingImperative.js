import { LightningElement } from 'lwc';
import getHighRevenueAccountRecords from '@salesforce/apex/AccountController.getHighRevenueAccountRecords';
export default class HighRevenueAccountsUsingImperative extends LightningElement {

    accountsToDisplay=[];
    countOfRecords=5;

    connectedCallback(){
        getHighRevenueAccountRecords({count : this.countOfRecords}).then(response => {
            console.log('Response using imparative at connectedCallback', response);
            this.accountsToDisplay = response;
        }).catch(error => {
            console.error('Error', error);
        })
    }

    setCount(event){
        console.log('Value', event.target.value);
        let inputValue = event.target.value;
        if(inputValue == '') return;

        this.countOfRecords = inputValue;

        getHighRevenueAccountRecords({count : this.countOfRecords}).then(response =>{
            console.log('Response using imparative at custom count', response);
            this.accountsToDisplay = response;
        }).catch(error =>{
            console.error('Error', error);
        });
    }

    

}
