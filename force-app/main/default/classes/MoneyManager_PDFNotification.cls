public with sharing class MoneyManager_PDFNotification implements Schedulable{

    public void execute(SchedulableContext sc) {
        // Additional logic to generate PDF and send email notification can be added here

        ApexPages.PageReference pdfPage = Page.ExpenseAndIncomeReportPDF; // Assuming you have a Visualforce page named ExpenseIncomeReportPDF
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'sairamteja413@gmail.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Expense and Income Report');
        mail.setHtmlBody(pdfPage.getContent().toString());
        Messaging.EmailFileAttachment emailAttaachment= new Messaging.EmailFileAttachment();
        emailAttaachment.setFileName('ExpenseAndIncomeReport.pdf');
        emailAttaachment.setBody(pdfPage.getContentAsPDF());

        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {emailAttaachment});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
    }
}