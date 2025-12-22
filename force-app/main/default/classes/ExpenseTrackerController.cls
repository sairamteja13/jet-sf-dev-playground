public with sharing class ExpenseTrackerController {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getExpenseData(Date startDate, Date endDate){
        try {
            return [Select Expense_Type__c, SUM(Expense_Amount__c) expenseAmount 
                    FROM Expense__c 
                    WHERE Expense_Date__c >= :startDate AND Expense_Date__c <= :endDate  WITH USER_MODE
                    GROUP BY Expense_Type__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getTransactionExpensesData(Date startDate, Date endDate,Id cont,String tnxType){
        try {

            Id contactId = [Select contactId from User where Id = :cont LIMIT 1]?.contactId;
            System.debug('Contact Id'+contactId);
            System.debug('startDate'+startDate);
            System.debug('endDate'+endDate);
            return [Select Category__c, SUM(Transaction_Amount__c) expenseAmount 
                    FROM Transaction__c  
                    WHERE Transaction_Date__c  >= :startDate AND Transaction_Date__c <= :endDate AND Type_of_Transaction__c = :tnxType 
                    GROUP BY Category__c ];
                    /*AND Transaction_Owner__c = :contactId*/
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}