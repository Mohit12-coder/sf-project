import { LightningElement, wire } from 'lwc';
import getCaseDetail from '@salesforce/apex/AssetPortalController.getCaseDetail';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

export default class CaseDetail extends NavigationMixin(LightningElement) {

    caseNumber;
    caseData;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.caseNumber = currentPageReference.state?.caseNumber;

            if (this.caseNumber) {
                this.loadCase();
            }
        }
    }

    async loadCase() {
        this.caseData = await getCaseDetail({
            caseNumber: this.caseNumber
        });
    }

    goToMyCases() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/my-cases'
            }
        });
    }

    get timelineSteps() {

        if (!this.caseData) return [];

        const status = this.caseData.Status;

        const steps = [
            { label: 'Case Created', value: 'New' },
            { label: 'Assigned', value: 'Assigned' },
            { label: 'In Progress', value: 'Working' },
            { label: 'Resolved', value: 'Closed' }
        ];

        return steps.map(step => {

            let isCompleted = false;

            if (status === 'Closed') {
                isCompleted = true;
            } else if (status === 'Working') {
                isCompleted = step.value !== 'Closed';
            } else if (status === 'Assigned') {
                isCompleted = step.value === 'New' || step.value === 'Assigned';
            } else if (status === 'New') {
                isCompleted = step.value === 'New';
            }

            return {
                ...step,
                isCompleted,
                cssClass: isCompleted ? 'step done' : 'step'
            };
        });
    }

}