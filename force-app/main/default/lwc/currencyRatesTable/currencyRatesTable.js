import { LightningElement } from 'lwc';
import getUsdRates from '@salesforce/apex/OpportunityCurrencyService.getUsdRates';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CurrencyRatesTable extends LightningElement {
    allRows = [];
    filteredRows = [];
    paginatedRows = [];

    searchKey = '';
    isLoading = false;

    pageSize = 10;
    currentPage = 1;
    totalPages = 1;

    columns = [
        { label: 'Currency', fieldName: 'currencyCode', type: 'text' },
        { label: 'Rate vs USD', fieldName: 'rateAgainstUSD', type: 'number' }
    ];

    connectedCallback() {
        this.loadRates();
    }

    loadRates() {
        this.isLoading = true;

        getUsdRates()
            .then(result => {
                this.allRows = (result || []).sort((a, b) =>
                    a.currencyCode.localeCompare(b.currencyCode)
                );

                this.applyFilter();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message:
                            error?.body?.message ||
                            error.message ||
                            'Unable to load currency rates',
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleSearch(event) {
        this.searchKey = event.target.value;
        this.currentPage = 1;
        this.applyFilter();
    }

    handlePageSizeChange(event) {
        this.pageSize = parseInt(event.target.value, 10);
        this.currentPage = 1;
        this.updatePagination();
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePagination();
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePagination();
        }
    }

    applyFilter() {
        let key = this.searchKey.trim().toLowerCase();

        if (!key) {
            this.filteredRows = [...this.allRows];
        } else {
            this.filteredRows = this.allRows.filter(row =>
                row.currencyCode.toLowerCase().includes(key) ||
                String(row.rateAgainstUSD).includes(key)
            );
        }

        this.updatePagination();
    }

    updatePagination() {
        this.totalPages = Math.max(
            1,
            Math.ceil(this.filteredRows.length / this.pageSize)
        );

        if (this.currentPage > this.totalPages) {
            this.currentPage = this.totalPages;
        }

        let start = (this.currentPage - 1) * this.pageSize;
        let end = start + this.pageSize;

        this.paginatedRows = this.filteredRows.slice(start, end);
    }

    get disablePrevious() {
        return this.currentPage === 1;
    }

    get disableNext() {
        return this.currentPage === this.totalPages;
    }

    get pageInfo() {
        return 'Page ' + this.currentPage + ' of ' + this.totalPages;
    }
}