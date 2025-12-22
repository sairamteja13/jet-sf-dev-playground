import { LightningElement ,api,wire} from 'lwc';
import chartjs from '@salesforce/resourceUrl/chartJs';
import { loadScript } from 'lightning/platformResourceLoader';
// import getExpenseData from '@salesforce/apex/ExpenseTrackerController.getExpenseData';
import getExpenseData from '@salesforce/apex/ExpenseTrackerController.getTransactionExpensesData';

export default class ExpensesChartjs extends LightningElement {
    error;
    chart;
    chartjsInitialized = false;
    totalExpense = 0;
    isLoading = false;
    @api loggedinUserId
    @api startDate
    @api endDate
    config = {
        type: 'pie',
        data: {
            datasets: [
                {
                    data: [

                    ],
                    backgroundColor: [

                    ],
                    label : [
                        'Total'
                    ]
                }
            ],
            hoverOffset: 4,
            labels: []
        },
        options: {
            responsive: false,
            plugins: {
                legend: {
                    position: 'right'
                }
            },
            animation: {
                animateScale: true,
                animateRotate: true
            }
        }
    };

    async renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        try {
            await loadScript(this, chartjs);
        } catch (error) {
            this.error = error;
        }
    }

    @api getChart(data){
        console.log('called the chart');
        console.log('this.cont',this.loggedinUserId);
        this.isLoading = true;

        if (data) {
                console.log('Data',data);
                this.isLoading = false;
                data.forEach(element => {
                this.config.data.datasets[0].data.push(element.expenseAmount);
                this.config.data.datasets[0].backgroundColor.push(this.getRandomColor()); 
                this.config.data.labels.push(element.Category__c);
                this.totalExpense += element.expenseAmount;
            });
            const canvas = document.createElement('canvas');
            this.template.querySelector('div.chart').appendChild(canvas);
            let totalAmount = document.createElement('h1');
            totalAmount.innerHTML = `Total Expense : ${this.totalExpense}`;
            this.template.querySelector('div.sum').appendChild(totalAmount);
            const ctx = canvas.getContext('2d');
            this.chart = new window.Chart(ctx, this.config);
        }

        // getExpenseData({startDate : this.startDate,endDate: this.endDate,cont:this.loggedinUserId})
        // .then((result) => {

        // })
        // .catch((error) => {
        //     console.error(error);
        //     console.log('error Occured in the data',error)            
        // });
    }

    @api resetConfig(){
        this.config.data.datasets[0].data = [];
        this.config.data.datasets[0].backgroundColor = [];
        this.config.data.labels = [];
        this.totalExpense = 0;
        this.template.querySelector('div.chart').removeChild(this.template.querySelector('canvas'));    
        this.template.querySelector('div.sum').removeChild(this.template.querySelector('h1'));    

    }

    @api removeExpensesChart(){
        console.log('remove called');
    }

    getRandomColor() {
        let letters = '0123456789ABCDEF';
        let color = '#';
        for (let i = 0; i < 6; i++) {
          color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    }
}