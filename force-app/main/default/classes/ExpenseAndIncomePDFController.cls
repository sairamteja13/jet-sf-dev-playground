public with sharing class ExpenseAndIncomePDFController {
    public List<String> categoryTnx { get; private set; }
    public List<MonthRow> rows { get; private set; }

    public ExpenseAndIncomePDFController() {
        try {
            getExpenseData();
        } catch (Exception ex){
            System.debug('Exception in ExpenseAndIncomePDFController: ' + ex.getMessage());
            System.debug('Stack Trace: ' + ex.getStackTraceString());
        }
    }

    public void getExpenseData(){
        List<String> months = new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
        categoryTnx = new List<String>();
        Map<String, MonthRow> monthvsCategory = new Map<String, MonthRow>();  
        for (String month : months) {
            MonthRow row = new MonthRow(month);
            monthvsCategory.put(month, row);
            rows.add(row);
        }
        List<AggregateResult> expenseData = [SELECT CALENDAR_MONTH(Transaction_Date__c) Month_of_Transaction,Category__c,sum(Transaction_Amount__c) Sum_Transaction_Amount
                FROM Transaction__c 
                WHERE Transaction_Date__c= LAST_FISCAL_YEAR AND Type_of_Transaction__c = 'Debit'
                WITH USER_MODE
                GROUP BY CALENDAR_MONTH(Transaction_Date__c), Category__c
                ORDER BY CALENDAR_MONTH(Transaction_Date__c), Category__c];

        for (AggregateResult expenses : expenseData){
            System.debug('Month: ' + expenses.get('Month_of_Transaction') + ' Category: ' + expenses.get('Category__c') + ' Amount: ' + expenses.get('Sum_Transaction_Amount'));
            String month = months[(Integer)expenses.get('Month_of_Transaction') - 1];
            String category = (String)expenses.get('Category__c');
            Decimal sumCatTnx = (Decimal)expenses.get('Sum_Transaction_Amount');

            categoryTnx.add(category);
            monthvsCategory.get(month)?.values.put(category, sumCatTnx);
            System.debug(monthvsCategory.get(month)?.values);
            System.debug(category);
        }
        categoryTnx = new List<String>(new Set<String>(categoryTnx));
        categoryTnx.sort();
    }

    public class MonthRow {
        public String month { get; private set; }
        public Map<String, Decimal> values { get; private set; }

        public MonthRow(String m) {
            this.month = m;
            this.values = new Map<String, Decimal>();
        }
    }
}
