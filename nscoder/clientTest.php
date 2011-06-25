<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
</head>
<?

 	require_once ('lib/nusoap.php');

	$wsdlEvents = "http://localhost/nscoder/service.php?wsdl";
	
	$eventTable = new nusoap_client($wsdlEvents, 'wsdl', '', '', '', '');

	$err = $eventTable->getError();
	
	if ($err) {
		echo '<h2>Constructor del servicio de Eventos error </h2><pre>' . $err . '</pre>';
	}

	$proxyTables = $eventTable->getProxy();
			
	$response = $proxyTables->getNearbyEvents(41.406927,2.209925);
  
  	echo "<h1>Petición</h1>";
	echo "<pre>" . htmlspecialchars($proxyTables->request, ENT_QUOTES) . "</pre>";
	echo "<br>";
  	echo "<h1>Respuesta</h1>";
	echo "<pre>" . htmlspecialchars($proxyTables->response, ENT_QUOTES) . "</pre>";
	echo "<br>";
	
?>
<body>
	<h1>Servicio tables</h1>
	<table border="1">
		<th>Latitud</th><th>Longitud</th><th>Localización</th><th>Nombre</th><th>Fecha</th><th>Descripción</th>
		<?
			
			foreach($response as $position)
				echo "<tr><td>".$position['latitude']."</td><td>"
					.$position['longitude']."</td><td>"
					.utf8_encode($position['location'])."</td><td>"
					.utf8_encode($position['name'])."</td><td>"
					.$position['startdate']."</td><td>"
					.utf8_encode($position['shortdescription'])."</td></tr>\n";
		?>
	</table>
</body>
</html>