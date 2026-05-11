import { LightningElement, api }
from 'lwc';

export default class FullScreenModal
extends LightningElement {

    @api groupedRecords = [];

    caseColumns = [
        { label: 'Case Number',fieldName: 'CaseNumber', type: 'text'},
        { label: 'Subject', fieldName: 'Subject', type: 'text' },
        { label: 'Status', fieldName: 'Status', type: 'text'},
        { label: 'Priority', fieldName: 'Priority', type: 'text'}
    ];

    taskColumns = [
        { label: 'Subject', fieldName: 'subject', type: 'text'},
        { label: 'Who', fieldName: 'whoName', type: 'text'},
        { label: 'Activity Date', fieldName: 'activityDate', type: 'date'}
    ];


    handleClose() {
        this.dispatchEvent( new CustomEvent( 'closemodal') );
    }
}