import { LightningElement } from 'lwc';
import Id from '@salesforce/user/Id';
import Name from '@salesforce/schema/User.Name'; //this scoped module imports the current user full name
import getExpenseData from '@salesforce/apex/ExpenseTrackerController.getTransactionExpensesData';


export default class TrackExpenseByDate extends LightningElement {
    date = new Date();
    startDate = new Date(this.date.getFullYear(), this.date.getMonth()-1, this.date.getDate()).toISOString();
    endDate = this.date.toISOString();
    showChart = false;
    count = 0;
    tnxType = 'Debit';

    get Tnxoptions() {
        return [
            { label: 'Debit', value: 'Debit' },
            { label: 'Credit', value: 'Credit' },
        ];
    }

    handleTypTranx(event) {
        this.tnxType = event.detail.value;
    }

    get userId() {
        console.log('Current User',Id,Id.substring(0, 15));
        return Id;
    }

    get userName() {
        console.log('Current User',Name);
        return `Track Expenses`;
    }

    handleDate(event){
        if(event.target.label=='Start Date'){
            console.log(event.target.label,event.target.value);
            this.startDate = event.target.value;
        }
        else if(event.target.label=='End Date'){
            console.log(event.target.label,event.target.value);
            this.endDate = event.target.value;
        }
        console.log(this.startDate, this.endDate);
        
    }

    handleNext(){
        console.log(this.startDate, this.endDate);
        this.showChart = this.startDate !==null && this.endDate !==null ? true : false;
        getExpenseData({startDate : this.startDate,endDate: this.endDate,cont:this.loggedinUserId,tnxType:this.tnxType})
        .then((result) => {
            console.log('Result',result);
            this.template.querySelector('c-expenses-chartjs').getChart(result);            
        }).catch((error)=>{
            console.log('error',error);
        });
        if (this.count !== 0) {
            this.template.querySelector('c-expenses-chartjs').resetConfig();            
        }
        this.count++;
    }
}