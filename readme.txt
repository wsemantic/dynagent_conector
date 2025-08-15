Los archivos XML declaran la adaptacion de mensajes de un conector XML en formato "dynagent" a otro sistema, como pueda ser Magento o ODOO
Dynagent es una base de datos con un modelo legacy, un programa en java es capaz de leer datos en SQL y escribirlos en el XML de datos, que se adapta con los XSL del proyecto

Este proyecto es para ampliar el conector odoo_to_dynagent. La idea es que algunos almacenes trabajan con stock en consigna, 
y por tanto sus pedidos deben adaptarser a un traspaso o movimiento/transferencia de stock entre pedidos, sin datos de precios. 
En el conector de referencia con Magento, la distinción se hace porque Magento añade un campo "codigo almacen", pero en el caso de ODOO la distincion se realizaria 
en que para cada delegación (asociada a la orden) existe un registro "distribuidor" con el campo rdn coincidente con el rdn de la delegación (rdn es un nombre unico -relative distingihised name-) 

Sin embargo para facilidad del procesamiento los pedidos de distribuidores entraran en ODOO como transferencias entre almacenes stock.picking y las lineas como stock moves
