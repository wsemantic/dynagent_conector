Conector basado en un programa java que convierte datos a XML y usa una trasnformacion XSL y SQL

Los archivos XSL declaran la adaptacion de mensajes de un conector XML en formato "dynagent" a otro sistema, como pueda ser Magento o ODOO
Dynagent es una base de datos con un modelo legacy, un programa en java es capaz de leer datos en SQL y escribirlos en el XML de datos, que se adapta con los XSL del proyecto


En el caso de conector que captura datos de ODOO y los importa a Dynagent (XSL odoo_to_dynagent.xsl) , el programa java que lo gestiona primero captura los datos XMLRP de ODOO, 
y con esos datos crea un fichero de datos bajo un root XMLRPC (por ejemplo el partner capturado lo incluyen en XMLRPC/MAP/partner_id), 
con ese XML de datos ejecuta la transformacion XSL, y despues el programa java que lo gestiona ejecuta el SQL y reemplaza los valores obtenidos por los marcadores de sintaxis {$campo}

Este proyecto es para ampliar el conector odoo_to_dynagent. La idea es que algunos almacenes trabajan con stock en consigna, 
y por tanto sus pedidos deben adaptarser a un traspaso o movimiento/transferencia de stock entre pedidos, sin datos de precios. 
En el conector de referencia con Magento, la distinción se hace porque Magento añade un campo "codigo almacen", pero en el caso de ODOO la distincion se realizaria 
en que para cada delegación (asociada a la orden) existe un registro "distribuidor" con el campo rdn coincidente con el rdn de la delegación (rdn es un nombre unico -relative distingihised name-) 

Ademas el proceso SQL en java usa el patron de marcadores whenc que permite resolver test despues de la trasnformacion XSL, y en java se adapta el XML en ciertos casos simples