public with sharing class MoneyManager_PDFNotification implements Schedulable{

    public void execute(SchedulableContext sc) {
        // Additional logic to generate PDF and send email notification can be added here

        ApexPages.PageReference expensepdfPage = Page.ExpenseAndIncomeReportPDF;
        Blob pdfBlob = expensepdfPage.getContentAsPDF();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'sairamteja413@gmail.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Year-End Expense and Income Report');
        mail.setPlainTextBody('Please find attached the year-end customer performance report.');
        mail.setHtmlBody(pdfPage.getContent().toString());
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Year_End_Expense_Report.pdf');
        attachment.setBody(pdfBlob);

        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {emailAttaachment});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
    }
}