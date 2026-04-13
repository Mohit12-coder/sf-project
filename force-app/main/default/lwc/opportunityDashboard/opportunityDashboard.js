import { LightningElement, wire } from 'lwc';
import getAllOpportunityList from '@salesforce/apex/OpportunityDashboardController.getAllOpportunityList';
import { refreshApex } from '@salesforce/apex';

export default class OpportunityDashboard extends LightningElement {
    allRecords = [];
    filteredRecords = [];
    pageRecords = [];

    filterRows = [];
    searchTerm = '';

    pageSize = 5;
    pageNumber = 1;
    totalPages = 0;

    showMenu = false;
    isLoading = true;

    wiredResult;

    @wire(getAllOpportunityList)
    wiredOpps(result) {
        this.wiredResult = result;

        if (result.data) {
            this.allRecords = result.data.map(item => {
                return {
                    Id: item.Id,
                    Name: item.Name,
                    StageName: item.StageName,
                    Amount: item.Amount,
                    Probability: item.Probability,
                    CloseDate: item.CloseDate,
                    Type: item.Type,
                    LeadSource: item.LeadSource,
                    Description: item.Description,
                    AccountId: item.AccountId,
                    accountName: item.Account && item.Account.Name? item.Account.Name : ''
                };
            });

            this.isLoading = false;
            this.refreshView();
        }
    }

    handleToggleMenu() {
        this.showMenu = !this.showMenu;
    }

    handleSearchChange(event) {
        this.searchTerm = event.detail ? event.detail.toLowerCase() : '';
        this.pageNumber = 1;
        this.refreshView();
    }

    handleApplyFilter(event) {
        this.filterRows = [...this.filterRows, event.detail];
        this.pageNumber = 1;
        this.refreshView();
    }

    handleRemoveFilter(event) {
        const rowId = String(event.detail);

        this.filterRows = this.filterRows.filter(row => String(row.id) !== rowId);

        this.pageNumber = 1;
        this.refreshView();
    }

    handleClearAll() {
        this.filterRows = [];
        this.pageNumber = 1;
        this.refreshView();
    }

    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.refreshView();
        }
    }

    handleNext() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber++;
            this.refreshView();
        }
    }

    handleDataRefresh() {
        refreshApex(this.wiredResult);
    }

    refreshView() {
        let data = [...this.allRecords];

        data = this.applyFilters(data);
        data = this.applySearch(data);

        this.filteredRecords = data;

        this.totalPages = Math.ceil(data.length / this.pageSize);

        if (this.totalPages === 0) {
            this.totalPages = 1;
        }

        const start = (this.pageNumber - 1) * this.pageSize;
        const end = start + this.pageSize;

        this.pageRecords = data.slice(start, end);
    }

    applySearch(data) {
        if (!this.searchTerm || this.searchTerm.length < 3) {
            return data;
        }

        return data.filter(item => {
            let name = item.Name ? item.Name.toLowerCase() : '';
            let stage = item.StageName ? item.StageName.toLowerCase() : '';

            return (
                name.includes(this.searchTerm) ||
                stage.includes(this.searchTerm)
            );
        });
    }

    applyFilters(data) {
    return data.filter(item => {
        return this.filterRows.every(row => {
            const fieldValue = item[row.fieldApiName];

            return this.matchesFilter(fieldValue, row.fieldType, row.operator, row.value);
        });
    });
}

matchesFilter(fieldValue, fieldType, operator, filterValue) {
    if (fieldValue == null) {
        return false;
    }

    if (fieldType === 'Boolean') {
        const left = String(fieldValue).toLowerCase();
        const right = String(filterValue).toLowerCase();
        return left === right;
    }

    if (fieldType === 'Date' || fieldType === 'DateTime') {
        const leftDate = new Date(fieldValue);
        const rightDate = new Date(filterValue);

        if (operator === 'equals') return leftDate.toDateString() === rightDate.toDateString();
        if (operator === 'before') return leftDate < rightDate;
        if (operator === 'after') return leftDate > rightDate;
        return true;
    }

    if (fieldType === 'Double' || fieldType === 'Currency' || fieldType === 'Percent' || fieldType === 'Integer' || fieldType === 'Long') {
        const leftNum = Number(fieldValue);
        const rightNum = Number(filterValue);

        if (operator === 'greaterThan') return leftNum > rightNum;
        if (operator === 'lessThan') return leftNum < rightNum;
        if (operator === 'equals') return leftNum === rightNum;
        return true;
    }

    const leftText = String(fieldValue).toLowerCase();
    const rightText = String(filterValue).toLowerCase();

    if (operator === 'contains') return leftText.includes(rightText);
    if (operator === 'startsWith') return leftText.startsWith(rightText);
    if (operator === 'equals') return leftText === rightText;

    return true;
}
}