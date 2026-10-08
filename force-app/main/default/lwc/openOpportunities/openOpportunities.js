import { LightningElement, wire } from 'lwc';
import getOpenOpportunities from '@salesforce/apex/OpportunityController.getOpenOpportunities';
import getPipelineTotalInr from '@salesforce/apex/OpportunityController.getPipelineTotalInr';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Stage', fieldName: 'StageName' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' },
    { label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
];

export default class OpenOpportunities extends LightningElement {
    columns = COLUMNS;
    searchKey = '';
    opportunities = [];
    totalInr;
    errorMessage;
    delayTimeout;

    // Re-runs automatically whenever searchKey changes
    @wire(getOpenOpportunities, { searchKey: '$searchKey' })
    wiredOpportunities({ data, error }) {
        if (data) {
            this.opportunities = data;
            this.errorMessage = undefined;
        } else if (error) {
            this.opportunities = [];
            this.errorMessage = error.body ? error.body.message : 'Something went wrong';
        }
    }

    get hasData() {
        return this.opportunities && this.opportunities.length > 0;
    }

    // Debounce: wait 300ms after typing stops before querying
    handleSearch(event) {
        const value = event.target.value;
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.searchKey = value;
        }, 300);
    }

    // Imperative Apex call (used because the method makes a callout)
    async handleTotal() {
        try {
            const total = await getPipelineTotalInr();
            this.totalInr = new Intl.NumberFormat('en-IN', {
                style: 'currency',
                currency: 'INR'
            }).format(total || 0);
            this.errorMessage = undefined;
        } catch (error) {
            this.totalInr = undefined;
            this.errorMessage = error.body ? error.body.message : 'Could not fetch the total';
        }
    }
}
