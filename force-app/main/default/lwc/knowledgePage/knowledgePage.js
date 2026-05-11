import { LightningElement, wire } from 'lwc';
import getArticles from '@salesforce/apex/KnowledgeController.getArticles';

export default class KnowledgePage extends LightningElement {
    articles = [];

    @wire(getArticles)
    wiredArticles({ data, error }) {
        if (data) {
            this.articles = data;
        } else if (error) {
            console.error(error);
        }
    }
}