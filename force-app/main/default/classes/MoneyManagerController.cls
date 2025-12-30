public with sharing class MoneyManagerController {


    public List<AggregateResult> getExpenseData(){
        return [SELECT CALENDAR_MONTH(Transaction_Date__c) Month_of_Transaction,Category__c,sum(Transaction_Amount__c) Transaction_Amount
                FROM Transaction__c 
                WHERE Transaction_Date__c= THIS_YEAR
                WITH USER_MODE
                GROUP BY CALENDAR_MONTH(Transaction_Date__c), Category__c
                ORDER BY CALENDAR_MONTH(Transaction_Date__c), Category__c];
    }

    // Return a list of data points for a chart
    public List<Data> getData() {
        return MoneyManagerController.getChartData();
    }
    
    public static List<Data> getChartData() {
        List<Data> data = new List<Data>();
        data.add(new Data('Jan', 30, 90, 55));
        data.add(new Data('Jan', 99, 22, 44));
        data.add(new Data('Feb', 44, 15, 65));
        data.add(new Data('Mar', 25, 32, 75));
        data.add(new Data('Apr', 74, 28, 85));
        data.add(new Data('May', 65, 51, 95));
        data.add(new Data('Jun', 33, 45, 99));
        data.add(new Data('Jul', 92, 82, 30));
        data.add(new Data('Aug', 87, 73, 45));
        data.add(new Data('Sep', 34, 65, 55));
        data.add(new Data('Oct', 78, 66, 56));
        data.add(new Data('Nov', 80, 67, 53));
        data.add(new Data('Dec', 17, 70, 70));
        return data;
    }
    
    // Wrapper class
    public class Data {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Integer data2 { get; set; }
        public Integer data3 { get; set; }
        public Data(String name, Integer data1, Integer data2, Integer data3) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
    }

    @AuraEnabled
    public static List<Transaction__c> getTransactionData(String typeofTab,Integer year, Integer monthNbr){
        System.debug('getting expense Data');
        List<Transaction__c> transactionList = new List<Transaction__c>();
        String query = 'SELECT Transaction_Date__c,Transaction_Amount__c,Category__c,Description__c,Type_of_Transaction__c';

        if (typeofTab == 'All Time') {
            query = query + ' FROM Transaction__c ORDER BY Transaction_Date__c DESC';
        }else if (typeofTab == 'Yearly') { 
            query = query + ' FROM Transaction__c WHERE CALENDAR_YEAR(Transaction_Date__c) =: year ORDER BY Transaction_Date__c DESC';
        }else {
            query = query + ' FROM Transaction__c WHERE CALENDAR_MONTH(Transaction_Date__c) =: monthNbr AND CALENDAR_YEAR(Transaction_Date__c) =: year ORDER BY Transaction_Date__c DESC';
        }

        transactionList =  Database.query(query);
        return transactionList;
    }
}