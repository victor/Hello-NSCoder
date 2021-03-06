<?php
	/*******************************************************************************/
	/*  Clase: dbConnector                                                         */
	/*  Descripci�n: Conectar a la base de datos MySql                             */
	/*                                                                             */
	/*******************************************************************************/
	
	class dbConnector  {
	
	    var $theQuery;
	    var $link;
	
		/*******************************************************************************/
		/*  Funci�n: dbConnector                                                       */
		/*  Descripci�n: Conectar a la base de datos                                   */
		/*  Parametros:                                                                */
		/*             No se definen                                                   */
		/*  Resultados:                                                                */
		/*             No se definen                                                   */
		/*                                                                             */
		/*******************************************************************************/
	    function dbConnector() {
	
	
	        //Establecemos la configuraci�n principal
	        $host = 'localhost';
	        $user = 'nsuser';
	        $pass = 'nscodernights';
	        $db = 'nscoder';
	        
	        //Conectamos con la base de datos
	        $this->link = mysql_connect($host, $user, $pass) or die("No ha sido posible conectar: " . mysql_error());
	        
	        mysql_select_db($db) or die("Error al seleccionar la base de datos: " . mysql_error());
	        register_shutdown_function(array($this, 'close'));
	    }
	    
		/*******************************************************************************/
		/*  Funci�n: query                                                             */
		/*  Descripci�n:  Ejecutar una consulta en la B.D.D.                           */
		/*  Parametros:                                                                */
		/*             $query: Consulta SQL                                            */
		/*  Resultados:                                                                */
		/*             Registros obtenidos en forma de matriz                          */
		/*                                                                             */
		/*******************************************************************************/
	    function query($query)
	    {
	        $this->theQuery = $query;
	        $result = mysql_query($query, $this->link) ;

	        return $result;
	    }
	
		/*******************************************************************************/
		/*  Funci�n: getQuery                                                          */
		/*  Descripci�n: Retornar el texto de la consulta                              */
		/*  Parametros:                                                                */
		/*             No se definen                                                   */
		/*  Resultados:                                                                */
		/*             Texto de la consulta                                            */
		/*                                                                             */
		/*******************************************************************************/
		function getQuery() 
		{
			return $this->theQuery;
		}
	
		/*******************************************************************************/
		/*  Funci�n: getNumRows                                                        */
		/*  Descripci�n: Obtener el n�mero de filas obtenidas.                         */
		/*  Parametros:                                                                */
		/*                                                     */
		/*  Resultados:                                                                */
		/*             Numero de registros                                             */
		/*                                                                             */
		/*******************************************************************************/
		function getNumRows($result)
		{
			return mysql_num_rows($result);
		}
	
		/*******************************************************************************/
		/*  Funci�n: fetchArray                                                        */
		/*  Descripci�n: Obtener la lista de resultados                                */
		/*  Parametros:                                                                */
		/*             $result: Matriz de datos                                        */
		/*  Resultados:                                                                */
		/*             No se definen                                                   */
		/*                                                                             */
		/*******************************************************************************/
	    function fetchArray($result)
	    {
	        return mysql_fetch_array($result);
	    }
	
		/*******************************************************************************/
		/*  Funci�n: close                                                             */
		/*  Descripci�n: finalizar la conexi�n                                         */
		/*  Parametros:                                                                */
		/*             No se definen                                                   */
		/*  Resultados:                                                                */
		/*             Resultado del cierre                                            */
		/*                                                                             */
		/*******************************************************************************/
	    function close()
	    {
	        return mysql_close($this->link);
	    }
		/*******************************************************************************/
		/*  Funci�n: lastId                                                            */
		/*  Descripci�n: obtener el Id del �ltimo registro insertado                   */
		/*  Parametros:                                                                */
		/*             No se definen                                                   */
		/*  Resultados:                                                                */
		/*             id del �tlimo registro insertado                                */
		/*                                                                             */
		/*******************************************************************************/
	    function lastId()
	    {
	    	return mysql_insert_id ($this->link);
	    }
	}
?>
