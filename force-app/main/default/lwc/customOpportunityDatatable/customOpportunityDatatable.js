import LightningDatatable from 'lightning/datatable';
import accountLookupTemplate from './accountLookupTemplate.html';

export default class CustomOpportunityDatatable extends LightningDatatable {
    static customTypes = {
        accountLookup: {
            template: accountLookupTemplate,
            typeAttributes: [
                'recordId',
                'accountId',
                'accountName'
            ]
        }
    };
}