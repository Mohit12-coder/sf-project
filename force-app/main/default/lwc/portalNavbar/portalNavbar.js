import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class PortalNavbar extends NavigationMixin(LightningElement) {

    isMenuOpen = false;

    get menuClass() {
        return this.isMenuOpen ? 'menu mobile-open' : 'menu';
    }

    toggleMenu() {
        this.isMenuOpen = !this.isMenuOpen;
    }

    navigateTo(urlPath) {
        this.isMenuOpen = false;

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

    goRegister() {
        this.navigateTo('/SelfRegister');
    }

    goLogin(){
        this.navigateTo('/login');
    }
}