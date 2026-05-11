import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class PortalFooter extends NavigationMixin(LightningElement) {

    navigateTo(urlPath) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: urlPath
            }
        });
    }

    goHome() {
        this.navigateTo('/');
    }

    goAssets() {
        this.navigateTo('/my-assets');
    }

    goCases() {
        this.navigateTo('/my-cases');
    }

    goFaq() {
        this.navigateTo('/faq');
    }
}