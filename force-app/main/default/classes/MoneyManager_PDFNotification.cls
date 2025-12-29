public with sharing class MoneyManager_PDFNotification implements Schedulable{

    public void execute(SchedulableContext sc) {

        List<AggregateResult> expenseData = new List<AggregateResult>();
        List<AggregateResult> incomeData = new List<AggregateResult>();

        expenseData = [Select Category__c, SUM(Transaction_Amount__c) expenseAmount 
                    FROM Transaction__c  
                    WHERE Transaction_Date__c = LAST_N_DAYS:30 AND Type_of_Transaction__c = :'Expense'
                    WITH USER_MODE
                    GROUP BY Category__c ];

        incomeData = [Select Category__c, SUM(Transaction_Amount__c) incomeAmount 
                    FROM Transaction__c  
                    WHERE Transaction_Date__c = LAST_N_DAYS:30 AND Type_of_Transaction__c = :'Income'
                    WITH USER_MODE
                    GROUP BY Category__c ];

        System.debug('Expense Data: ' + expenseData);
        System.debug('Income Data: ' + incomeData); 
        // Additional logic to generate PDF and send email notification can be added here
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'sairamteja413@gmail.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Expense and Income Report');
        mail.setPlainTextBody('Please find the attached expense and income report for the last 30 days.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
}