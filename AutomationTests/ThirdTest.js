// Comprobamos que la coordenada y de la posicion de la imagen de la vista de detalle sea la correcta
// Precondicion : accessibility label en la imagen = nscoderimg

var target = UIATarget.localTarget();
var application = target.frontMostApp();
var mainWindow = application.mainWindow();

UIALogger.logStart("Detail View Image origin.y Test");

//tap second cell
mainWindow.tableViews()[0].cells()[1].tap();

mainWindow.logElementTree();
UIALogger.logDebug(mainWindow.scrollViews()[0].images()["nscoderimg"].rect().origin.y);
nscoderImgY = mainWindow.scrollViews()[0].images()["nscoderimg"].rect().origin.y;

// captura de imagen en dispositivo
//target.captureScreenWithName("TestingCapture");


// test 
if (69 != nscoderImgY)
{
    UIALogger.logError("Expected 69" +
    " but received " + nscoderImgY);
}
else
{
    UIALogger.logPass("Coinciden");
}

