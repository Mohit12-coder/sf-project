import { LightningElement, track } from 'lwc';

export default class ToggleCard extends LightningElement {
    @track showCard = false;

    get buttonLabel() {
        return this.showCard ? 'Hide Details' : 'Show Details';
    }

    handleToggle() {
        this.showCard = !this.showCard;
    }
}