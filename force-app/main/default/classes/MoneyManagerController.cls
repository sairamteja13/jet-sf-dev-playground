public with sharing class MoneyManagerController {
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

        // return [Select Transaction_Date__c,Transaction_Amount__c,Category__c,Description__c,Type_of_Transaction__c
        // FROM Transaction__c ];
    }
}