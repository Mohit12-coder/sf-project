import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

import getProducts from '@salesforce/apex/AssetPortalController.getProducts';
import extendWarranty from '@salesforce/apex/AssetPortalController.extendWarranty';
import activateService from '@salesforce/apex/AssetPortalController.activateService';
import createCase from '@salesforce/apex/AssetPortalController.createCase';

export default class MyAssets extends NavigationMixin(LightningElement) {
    products = [];
    services = [];
    error;
    wiredResult;
    isMobile = false;

    showModal = false;
    selectedAssetId;

    showSuccessModal = false;
    createdCaseNumber = '';
    latestCaseNumber ='';

    showPlanModal = false;
    selectedAssetId;
    selectedMonths = 1;
    isServiceFlow = false;

    plans = [
        { label: '1 Month - ₹100', value: 1 },
        { label: '3 Months - ₹250 (Save ₹50)', value: 3 },
        { label: '6 Months - ₹450 (Save ₹150)', value: 6 },
        { label: '12 Months - ₹800 (Best Value )', value: 12 }
    ];

    subject = '';
    description = '';
    priority = 'Low';

    priorityOptions = [ 
        { label: 'Low', value: 'Low' },
        { label: 'Medium', value: 'Medium' },
        { label: 'High', value: 'High' }
    ];

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

    @wire(getProducts)
    wiredAssets(result) {
        this.wiredResult = result;

        const { data, error } = result;

        if (data) {
            const today = new Date();

            const rows = data.map(row => {
                const type = row.Product2?.RecordType?.Name;
                let isExpired = false;

                if (type === 'Product' && row.Warranty_End_Date__c) {
                    isExpired = new Date(row.Warranty_End_Date__c) < today;
                }

                if (type === 'Service' && row.Active_Until__c) {
                    isExpired = new Date(row.Active_Until__c) < today;
                }

                return {
                    ...row,
                    productName: row.Product2?.Name,
                    productType: type,
                    statusLabel: isExpired ? 'Expired' : 'Active',
                    statusStyle: isExpired
                        ? 'background:#ffecec;color:#c62828;'
                        : 'background:#e8f8ef;color:#0d8a45;',
                    showButton: isExpired
                };
            });

            this.products = rows.filter(x => x.productType === 'Product');
            this.services = rows.filter(x => x.productType === 'Service');
        }else if (error){
            console.error(error);
        }
    }

    openCaseModal(event) {
        this.selectedAssetId = event.target.dataset.id;
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
    }

    handleSubject(event) {
        this.subject = event.target.value;
    }

    handleDescription(event) {
        this.description = event.target.value;
    }

    handlePriority(event) {
        this.priority = event.detail.value;
    }

    async saveCase() {
        try {
            const caseNumber = await createCase({
                assetId: this.selectedAssetId,
                subject: this.subject,
                description: this.description,
                priority: this.priority
            });

            this.showModal = false;

            this.createdCaseNumber = caseNumber;
            this.showSuccessModal = true;

            this.latestCaseNumber = caseNumber;

            this.subject = '';
            this.description = '';
            this.priority = 'Medium';

        } catch (error) {
            console.error(error);
        }

    }

    goToMyCases() {
        this.showSuccessModal = false;

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/case-detail?caseNumber=' + this.latestCaseNumber
            }
        });
    }

    closeSuccessModal() {
        this.showSuccessModal = false;
    }

    openWarrantyModal(event) {
        this.selectedAssetId = event.target.dataset.id;
        this.isServiceFlow = false;
        this.showPlanModal = true;
    }

    openServiceModal(event) {
        this.selectedAssetId = event.target.dataset.id;
        this.isServiceFlow = true;
        this.showPlanModal = true;
    }

    handlePlanChange(event) {
        this.selectedMonths = event.detail.value;
    }

    closePlanModal() {
        this.showPlanModal = false;
    }

    async confirmPlan() {

        try {

            if (this.isServiceFlow) {
                await activateService({assetId: this.selectedAssetId,months: this.selectedMonths});
            } else {
                await extendWarranty({ assetId: this.selectedAssetId, months: this.selectedMonths});
            }

            this.showPlanModal = false;

            await refreshApex(this.wiredResult);

        } catch (error) {
            console.error(error);
        }
    }

}