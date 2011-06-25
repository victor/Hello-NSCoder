// Comprobamos que el titulo de la Navigation Bar sea el correcto

var target = UIATarget.localTarget();
var application = target.frontMostApp();
var mainWindow = application.mainWindow();

UIALogger.logStart("Table View Navigation Bar Title Test");

navBar = mainWindow.navigationBar();

if ("NSCoder Events" != navBar.name())
{
    UIALogger.logError("Expected 'NSCoder Events' " +
        "but received " + navBar.name());
}
else
{
    UIALogger.logPass("Navigation Bar Title Test OK");
}
