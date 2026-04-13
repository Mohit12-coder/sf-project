import { LightningElement } from 'lwc';

export default class OpportunityTopBar extends LightningElement {
    searchText = '';

    handleToggle() {
        this.dispatchEvent( new CustomEvent('togglemenu', { bubbles: true, composed: true }) );
    }

    handleSearch(event) {
        this.searchText = event.target.value;

        this.dispatchEvent( new CustomEvent('searchchange', { detail: this.searchText, bubbles: true, composed: true }) );
    }
}