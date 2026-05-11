import { LightningElement, wire } from 'lwc';
import getMyCases from '@salesforce/apex/AssetPortalController.getMyCases';

export default class MyCases extends LightningElement {
    cases = [];
    error;
    isMobile = false;

    connectedCallback() {
        this.checkScreen();
        window.addEventListener('resize', this.handleResize);
    }

    disconnectedCallback() {
        window.removeEventListener('resize', this.handleResize);
    }

    handleResize = () => {
        this.checkScreen();
    }

    checkScreen() {
        this.isMobile = window.innerWidth <= 768;
    }

    @wire(getMyCases)
    wiredCases({ data, error }) {
        if (data) {
            this.cases = data.map(row => ({
                ...row,
                assetName: row.Asset?.Name,
                statusStyle:
                    row.Status === 'Closed' ? 'background:#e8f8ef;color:#0d8a45;border:1px solid #8ad9ab;' : 'background:#fff4e5;color:#b26a00;border:1px solid #ffd38a;'
            }));

            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.error(error);
        }
    }
}