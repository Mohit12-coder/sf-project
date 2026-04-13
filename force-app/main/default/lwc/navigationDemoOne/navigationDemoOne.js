import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class NavigationDemoOne extends NavigationMixin(LightningElement) {

    navigateToAccount(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes:{
                objectApiName: 'Account',
                actionName: 'new' 
                
            }
        });
    }

}