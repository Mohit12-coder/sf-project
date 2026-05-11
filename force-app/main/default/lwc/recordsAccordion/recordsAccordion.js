import { LightningElement, api } from 'lwc';

export default class RecordsAccordion extends LightningElement {
    @api casesList = [];
    @api tasksList = [];

    caseColumns = [
        { label: 'Case Number', fieldName: 'CaseNumber', type: 'text'},
        { label: 'Subject', fieldName: 'Subject', type: 'text'},
        { label: 'Status', fieldName: 'Status',type: 'text'},
        { label: 'Priority', fieldName: 'Priority', type: 'text'},
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date'}
    ];

    taskColumns = [
        { label: 'Subject', fieldName: 'subject', type: 'text'},
        { label: 'Who', fieldName: 'whoName', type: 'text'},
        { label: 'Activity Date', fieldName: 'activityDate', type: 'date'},
        { label: 'Created Date', fieldName: 'createdDate', type: 'date'}
    ];

    handleOpenModal() {
        this.dispatchEvent( new CustomEvent('openfullscreen' ));
    }
}