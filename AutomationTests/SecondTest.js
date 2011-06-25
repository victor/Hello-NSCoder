// Comprobamos que en la vista de detalle, la shortdescription sea la que corresponde

var target = UIATarget.localTarget();
var application = target.frontMostApp();
var mainWindow = application.mainWindow();

UIALogger.logStart("Detail View Short Description Test");

// get second cell name
cellName = mainWindow.tableViews()[0].cells()[1].name().split(',')[1].trim();

//tap second cell
mainWindow.tableViews()[0].cells()[1].tap();

shortDescriptionLabelName = mainWindow.scrollViews()[0].staticTexts()[0].name();

// test 
if (cellName != shortDescriptionLabelName)
{
    UIALogger.logError("Expected " + cellName +
    " but received " + shortDescriptionLabelName);
}
else
{
    UIALogger.logPass("Coinciden");
}

