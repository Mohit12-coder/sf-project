import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getArticles from '@salesforce/apex/KnowledgeController.getArticles';

export default class FaqPage extends NavigationMixin(LightningElement) {

    articles = [];

    connectedCallback() {
        this.loadArticles();
    }

    async loadArticles() {
        try {
            this.articles = await getArticles();
        } catch (error) {
            console.error(error);
        }
    }

    goToAssets() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/my-assets'
            }
        });
    }
    
}