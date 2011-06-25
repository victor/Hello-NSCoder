var target = UIATarget.localTarget();
var application = target.frontMostApp();
var mainWindow = application.mainWindow();

UIALogger.logStart("Log Element Tree Example");
mainWindow.logElementTree();
UIALogger.logPass("OK");