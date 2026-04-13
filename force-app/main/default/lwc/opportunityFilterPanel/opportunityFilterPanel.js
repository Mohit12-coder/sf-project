import { LightningElement, api, wire } from 'lwc';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

export default class OpportunityFilterPanel extends LightningElement {
    @api filterRows = [];

    showBuilder = false;

    fieldName = '';
    operator = 'contains';
    fieldValue = '';

    recordTypeId;
    fieldMetaMap = {};
    picklistFieldValues = {};

    fieldOptions = [];

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    infoHandler({ data }) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;

            const options = [];
            const metaMap = {};

            Object.keys(data.fields).forEach((apiName) => {
                const fieldInfo = data.fields[apiName];

                if (fieldInfo && fieldInfo.filterable) {
                    options.push({
                        label: fieldInfo.label,
                        value: apiName
                    });

                    metaMap[apiName] = {
                        label: fieldInfo.label,
                        type: fieldInfo.dataType
                    };
                }
            });

            options.sort((a, b) => {
                return a.label.localeCompare(b.label);
            });

            this.fieldOptions = options;
            this.fieldMetaMap = metaMap;

            if (!this.fieldName && this.fieldOptions.length > 0) {
                this.fieldName = this.fieldOptions[0].value;
            }
        }
    }

    @wire(getPicklistValuesByRecordType, {
        objectApiName: OPPORTUNITY_OBJECT,
        recordTypeId: '$recordTypeId'
    })
    picklistHandler({ data }) {
        if (data) {
            this.picklistFieldValues = data.picklistFieldValues;
        }
    }

    get hasRows() {
        return this.filterRows && this.filterRows.length > 0;
    }

    get displayRows() {
        return this.filterRows.map(row => {
            return {
                id: row.id,
                fieldLabel: row.fieldLabel,
                operatorLabel: row.operatorLabel,
                value: row.value
            };
        });
    }

    get selectedFieldType() {
        if (!this.fieldName || !this.fieldMetaMap[this.fieldName]) {
            return 'String';
        }
        return this.fieldMetaMap[this.fieldName].type;
    }

    get isPicklistField() {
        return this.selectedFieldType === 'Picklist' ||
               this.selectedFieldType === 'MultiPicklist';
    }

    get isBooleanField() {
        return this.selectedFieldType === 'Boolean';
    }

    get isDateField() {
        return this.selectedFieldType === 'Date' ||
               this.selectedFieldType === 'DateTime';
    }

    get isNumberField() {
        return this.selectedFieldType === 'Double' ||
               this.selectedFieldType === 'Currency' ||
               this.selectedFieldType === 'Percent' ||
               this.selectedFieldType === 'Integer' ||
               this.selectedFieldType === 'Long';
    }

    get valueOptions() {
        const picklistData = this.picklistFieldValues[this.fieldName];

        if (picklistData && picklistData.values) {
            return picklistData.values;
        }

        return [];
    }

    get operatorOptions() {
        if (this.isBooleanField) {
            return [
                { label: 'Equals', value: 'equals' }
            ];
        }

        if (this.isDateField) {
            return [
                { label: 'Equals', value: 'equals' },
                { label: 'Before', value: 'before' },
                { label: 'After', value: 'after' }
            ];
        }

        if (this.isNumberField) {
            return [
                { label: 'Greater Than', value: 'greaterThan' },
                { label: 'Less Than', value: 'lessThan' },
                { label: 'Equals', value: 'equals' }
            ];
        }

        if (this.isPicklistField) {
            return [
                { label: 'Equals', value: 'equals' }
            ];
        }

        return [
            { label: 'Contains', value: 'contains' },
            { label: 'Equals', value: 'equals' },
            { label: 'Starts With', value: 'startsWith' }
        ];
    }

    openBuilder() {
        this.showBuilder = true;
        this.fieldValue = '';
        if (!this.fieldName && this.fieldOptions.length > 0) {
            this.fieldName = this.fieldOptions[0].value;
        }
        this.operator = this.getDefaultOperator(this.fieldName);
    }

    closeBuilder() {
        this.showBuilder = false;
    }

    handleFieldChange(event) {
        this.fieldName = event.detail.value;
        this.fieldValue = '';
        this.operator = this.getDefaultOperator(this.fieldName);
    }

    handleOperatorChange(event) {
        this.operator = event.detail.value;
    }

    handleValueChange(event) {
        this.fieldValue = event.detail.value ? event.detail.value : event.target.value;
    }

    handleApply() {
        if (!this.fieldName || !this.fieldValue) {
            return;
        }

        const fieldLabel = this.getFieldLabel(this.fieldName);
        const operatorLabel = this.getOperatorLabel(this.operator);

        this.dispatchEvent(
            new CustomEvent('applyfilter', {
                detail: {
                    id: String(Date.now() + Math.floor(Math.random() * 1000)),
                    fieldApiName: this.fieldName,
                    fieldLabel: fieldLabel,
                    fieldType: this.selectedFieldType,
                    operator: this.operator,
                    operatorLabel: operatorLabel,
                    value: this.fieldValue
                },
                bubbles: true,
                composed: true
            })
        );

        this.showBuilder = false;
    }

    handleRemoveClick(event) {
        const rowId = event.currentTarget.dataset.id;

        this.dispatchEvent(
            new CustomEvent('removefilterrow', {
                detail: rowId,
                bubbles: true,
                composed: true
            })
        );
    }

    handleClearAll() {
        this.dispatchEvent(
            new CustomEvent('clearall', {
                bubbles: true,
                composed: true
            })
        );
    }

    getDefaultOperator(fieldName) {
        const type = this.fieldMetaMap[fieldName] ? this.fieldMetaMap[fieldName].type : 'String';

        if (type === 'Boolean') {
            return 'equals';
        }

        if (type === 'Date' || type === 'DateTime') {
            return 'equals';
        }

        if (type === 'Double' || type === 'Currency' || type === 'Percent' || type === 'Integer' || type === 'Long') {
            return 'greaterThan';
        }

        if (type === 'Picklist' || type === 'MultiPicklist') {
            return 'equals';
        }

        return 'contains';
    }

    getFieldLabel(fieldName) {
        return this.fieldMetaMap[fieldName] ? this.fieldMetaMap[fieldName].label : fieldName;
    }

    getOperatorLabel(operatorName) {
        if (operatorName === 'greaterThan') return 'greater than';
        if (operatorName === 'lessThan') return 'less than';
        if (operatorName === 'startsWith') return 'starts with';
        return operatorName;
    }
}