// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

// Get the report ID
List <Report> reportList = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'Transactions_Report_SQY'];
String reportId = (String)reportList.get(0).get('Id');

// Run a report synchronously
Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);

// Get the first down-grouping in the report
Reports.Dimension dim = results.getGroupingsDown();
Reports.GroupingValue groupingVal = dim.getGroupings()[0];
System.debug('Key: ' + groupingVal.getKey());
System.debug('Label: ' + groupingVal.getLabel());
System.debug('Value: ' + groupingVal.getValue());

// Construct a fact map key, using the grouping key value
String factMapKey = groupingVal.getKey() + '!T';

// Get the fact map from the report results
Reports.ReportFactWithDetails factDetails =
    (Reports.ReportFactWithDetails)results.getFactMap().get(factMapKey);

// Get the first summary amount from the fact map
Reports.SummaryValue sumVal = factDetails.getAggregates()[0];
System.debug('Summary Value: ' + sumVal.getLabel());

// Get the field value from the first data cell of the first row of the report
List<Reports.ReportDetailRow> detailRow = factDetails.getRows();

System.debug(detailRow[0].getDataCells()[0].getLabel());


List<Report> reportList = [SELECT Id FROM Report WHERE DeveloperName = 'Transactions_Report_SQY' LIMIT 1];
if (reportList.isEmpty()) {
    throw new AuraHandledException('Report not found.');
}

String reportId = reportList[0].Id;

// Run report synchronously
Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);

// Get grouping information (down-grouped rows)
Reports.Dimension dim = results.getGroupingsDown();
List<Reports.GroupingValue> groupings = dim.getGroupings();

List<List<String>> finalData = new List<List<String>>();

// Optional: Add header row
List<String> header = new List<String>{ 'Group Label', 'Field 1', 'Field 2', 'Field 3' }; // update as needed
finalData.add(header);

for (Reports.GroupingValue groupingVal : groupings) {
    String key = groupingVal.getKey() + '!T';
    Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get(key);

    if (factDetails != null) {
        List<Reports.ReportDetailRow> rows = factDetails.getRows();

        for (Reports.ReportDetailRow row : rows) {
            List<String> rowData = new List<String>();

            // Group label
            rowData.add(groupingVal.getLabel());

            // Data values in row
            for (Reports.ReportDataCell cell : row.getDataCells()) {
                rowData.add(cell.getLabel());
            }
            System.debug(rowData);
            finalData.add(rowData);
        }
    }

    DateTime scheduledTime = System.now().addMinutes(1);

    // Extract the individual time components
    String second = String.valueOf(scheduledTime.second());
    String minute = String.valueOf(scheduledTime.minute());
    String hour = String.valueOf(scheduledTime.hour());
    String dayOfMonth = String.valueOf(scheduledTime.day());
    String month = String.valueOf(scheduledTime.month());
    String year = String.valueOf(scheduledTime.year());

    // Construct the cron expression string
    // The format is: Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
    // Use '?' for Day_of_week when Day_of_month is specified
    String cronExpression = second + ' ' + minute + ' ' + hour + ' ' + dayOfMonth + ' ' + month + ' ? ' + year;

    MoneyManager_PDFNotification myJob = new MoneyManager_PDFNotification();
    System.schedule('Run Once Job Name', cronExpression, myJob);
}