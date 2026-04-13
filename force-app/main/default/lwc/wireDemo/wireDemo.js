import { LightningElement, wire, api } from 'lwc';
import adpId from '@salesforce/apex/DemoWireClass.methodName';

export default class WireDemo extends LightningElement {
    @api msg = 'Componnnnnt';

    data;
    error;

    @wire(adpId)
    wireData({ error, data }) {
        if (data) {
            this.data = data;
            this.error = undefined;
            return;
        }
        if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
}
