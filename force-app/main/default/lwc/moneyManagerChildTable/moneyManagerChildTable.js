import { LightningElement } from 'lwc';
import { api,track,wire } from 'lwc';
import getTransactionData from '@salesforce/apex/MoneyManagerController.getTransactionData';


const columns = [ { label: 'Date', fieldName: 'Transaction_Date__c',type:'date-local', sortable: "true",editable:true},
                  { label: 'Amount', fieldName: 'Transaction_Amount__c', type: 'currency',sortable: "true",cellAttributes: { alignment: 'left' },editable:true},
                  { label: 'Category', fieldName: 'Category__c', type: 'text', sortable: "true",editable:true},
                  { label: 'Description', fieldName: 'Description__c', type: 'text',editable:true},
                  { label: 'Type', fieldName: 'Type_of_Transaction__c', type: 'text', sortable: "true",editable:true},];

const monthNames = ["January", "February", "March","April", "May", "June","July", "August", "September","October", "November", "December"];

export default class MoneyManagerChildTable extends LightningElement {
    @api typeofTab;
    @api activeTab;
    isLoading = true;
    currentDate = new Date();
    @track yearVal = this.currentDate.getFullYear();
    @track monthVal = this.currentDate.getMonth()+1;

    @track yearOptions = [];
    @track monthOptions = [];

    @track data = [];
    columns = columns;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    income = 0;
    expense = 0;
    balance = 0;

    get isActiveTab() {
        return this.typeofTab === this.activeTab;
    }

    get isYearlyTab() {
        return this.typeofTab === 'Yearly';
    }

    get isMonthlyTab() {
        return this.typeofTab === 'Monthly';
    }

    get isAllTimeTab() {
        return this.typeofTab === 'All Time';
    }

    get yearOptions() {
        let options = [];

        return options;
    }

    handleYearChange(event) {        
        this.yearVal = parseInt(event.target.value);
        this.resetData();
        this.loadTransactionData();
    }

    handleMonthChange(event) {
        this.monthVal = parseInt(event.detail.value);
        this.resetData();
        this.loadTransactionData();
    }

    connectedCallback() {
        console.log('Connected comp');
        for (let i = this.currentDate.getFullYear(); i >= 2023; i--) {
            this.yearOptions.push({ label: i, value: i });
        }
        for (let i = 1; i <= 12; i++) {
            this.monthOptions.push({ label: monthNames[i-1], value: i });
        }
        this.loadTransactionData();
    }

    async loadTransactionData() {
        await getTransactionData({typeofTab:this.typeofTab,year:this.yearVal,monthNbr:this.monthVal})
        .then(result => {
            this.isLoading = false;
            this.data = result;
            this.data.forEach(element => {
                if (element.Type_of_Transaction__c  === 'Credit') {
                    this.income = this.income + element.Transaction_Amount__c;
                } else {
                    this.expense = this.expense + element.Transaction_Amount__c;
                }
                this.balance = this.income - this.expense;
            })
        }).catch(error => {
            console.log('Error recieved',JSON.stringify(error));
            this.error = error;
        });
    }
    
    


    // Sorting Logic
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.data];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.data = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    resetData() {
        this.income = 0;
        this.expense = 0;
        this.balance = 0;
    }
    
}