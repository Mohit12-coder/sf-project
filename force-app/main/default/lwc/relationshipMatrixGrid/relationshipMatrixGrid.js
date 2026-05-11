import { LightningElement,wire,api } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

import {refreshApex} from '@salesforce/apex';

import tickLogo from '@salesforce/resourceUrl/tickLogo';
import hyphenLogo from '@salesforce/resourceUrl/hyphenLogo';
import closeLogo from '@salesforce/resourceUrl/closeLogo';

export default class RelationshipMatrixGrid extends LightningElement {
    @api recordId;
    rows=[];
    columns =[];
    isLoading = true;
    
    showModal = false;
    selectedRecordId;


    @wire(getRelatedListRecords, {
            parentRecordId: '$recordId',
            relatedListId: 'Relationship_Matrixs__r',
            fields: [
                'Relationship_Matrix__c.Contact__c',
                'Relationship_Matrix__c.Contact__r.Name',
                'Relationship_Matrix__c.User__c',
                'Relationship_Matrix__c.User__r.Name',
                'Relationship_Matrix__c.Health__c'
            ],
            pageSize: 1999
    })
    list({data, error}){
        if (data) {
            console.log(JSON.stringify(data.records, null, 2));
            this.buildMatrix(data.records || []);
            this.isLoading = false;
        } else if (error) {
            this.rows = [];
            this.columns = [];
            this.isLoading = false;
        }
    }

    buildMatrix(records) {
        const contactMap = new Map();
        const userMap = new Map();
        const cellMap = new Map();

        records.forEach(rec => {

            const contactId = rec.fields.Contact__c.value;
            const userId = rec.fields.User__c.value;

            const contactName =rec.fields.Contact__r.displayValue || rec.fields.Contact__r.value?.fields?.Name?.value;

            const userName =  rec.fields.User__r.displayValue || rec.fields.User__r.value?.fields?.Name?.value;

            const health = rec.fields.Health__c.value;

            contactMap.set(contactId, contactName);
            userMap.set(userId, userName);

            const key = `${contactId}-${userId}`;

            cellMap.set(key, { recordId: rec.id,health: health, iconUrl: this.getHealthIcon(health) });
        });

        this.columns = Array.from(userMap, ([userId, userName]) => ({ userId, userName}));

        this.rows = Array.from(contactMap, ([contactId, contactName]) => ({
            contactId,
            contactName,
            cells: this.columns.map(col => {
                const key = `${contactId}-${col.userId}`;
                const cell = cellMap.get(key);

                return { key,recordId: cell ? cell.recordId : null, iconUrl: cell ? cell.iconUrl : '', health: cell ? cell.health : ''};
            })
        }));
    }

    getHealthIcon(health){
        switch(health){
            case 'Good': return tickLogo;
            case 'Average' : return hyphenLogo;
            case 'Bad' : return closeLogo;
            default : return '-';
        }
    }

    handleCellClick(event) {
        this.selectedRecordId = event.currentTarget.dataset.id;
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
        this.selectedRecordId = null;
    }

    handleSuccess() {
        this.showModal = false;
        this.selectedRecordId = null;

        refreshApex(this.wiredMatrixResult);
    }

}