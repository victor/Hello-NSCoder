<?

	//call library
 	require_once ('lib/nusoap.php');
 	require_once ('lib/dbConnector.inc');

	$namespace = "http://localhost/nscoder/service.php";
	
	// create a new soap server
	$server = new soap_server();

	$server->soap_defencoding = 'UTF-8';
	
	// configure our WSDL
	$server->configureWSDL("nscoder", $namespace);
	
	// set our namespace
	$server->wsdl->schemaTargetNamespace = $namespace;


									  
	$server->wsdl->addComplexType('eventInfo', 		// Name
								  'complexType', 	// Clase type
								  'struct', 		// PHP type
								  'all', 			// sequence definition type(all|sequence|choice)
								  '', 				// Restricted Base
								  array(
								  	'latitude'	 		=> array('name' => 'latitude',			'type' => 'xsd:float'),
								  	'longitude'	 		=> array('name' => 'longitude',			'type' => 'xsd:float'),
								  	'location'	 		=> array('name' => 'location',			'type' => 'xsd:string'),
								  	'name'		 		=> array('name' => 'name',				'type' => 'xsd:string'),
								  	'startdate'	 		=> array('name' => 'startdate',			'type' => 'xsd:dateTime'),
								  	'shortdescription'	=> array('name' => 'shortdescription',	'type' => 'xsd:string'),
								  	'fulldescription'	=> array('name' => 'fulldescription',	'type' => 'xsd:string')
								  )
								  );
     
	$server->wsdl->addComplexType('eventList', // Nombre
								  'complexType', // Tipo de Clase
								  'array', // Tipo de PHP
								  '', // definición del tipo secuencia(all|sequence|choice)
								  'SOAP-ENC:Array', // Restricted Base
								  array(),
								  array(
								  array('ref' => 'SOAP-ENC:arrayType', 'wsdl:arrayType' => 'tns:eventInfo[]')),
								  'tns:eventInfo'
								  );	
								  
	//Register a method that has parameters and return types
	$server->register(
		// method name:
		'getNearbyEvents',
		// parameter list:
		array('latitude' => 'xsd:float', 'longitude'=>'xsd:float'),
		// return value(s):
		array('return'=>'tns:eventList'),
		// namespace:
		$namespace,
		// soapaction: (use default)
		false,
		// style: rpc or document
		'rpc',
		// use: encoded or literal
		'encoded',
		// description: documentation for the method
		'Get description for Id in a Table');
		
	function getNearbyEvents($latitude, $longitude)
	{
		$resultList = array();
		
		$connector = new dbConnector();
      	
  		$consulta = "SELECT * FROM eventos";  		
		    	
		$getRequest = $connector->query($consulta);
		    
		$nRow = 0;
		
		while ($theRequest =$connector->fetchArray($getRequest)){
			$tableRowType['latitude'] 			= $theRequest['latitude'];
			$tableRowType['longitude'] 			= $theRequest['longitude'];
			$tableRowType['location'] 			= utf8_encode($theRequest['location']);
			$tableRowType['name'] 				= utf8_encode($theRequest['name']);
			$tableRowType['startdate'] 			= $theRequest['startdate'];
			$tableRowType['shortdescription'] 	= utf8_encode($theRequest['shortdescription']);
			$tableRowType['fulldescription']	= utf8_encode($theRequest['fulldescription']);
			$resultList[$nRow] = $tableRowType;
			$nRow++;
		}
		
		return $resultList;

	}
		
	// Get our posted data if the service is being consumed
	// otherwise leave this data blank.
	$POST_DATA = isset($GLOBALS['HTTP_RAW_POST_DATA']) ? $GLOBALS['HTTP_RAW_POST_DATA'] : '';

	// pass our posted data (or nothing) to the soap service
	$server->service($POST_DATA);
	exit(); 

?>