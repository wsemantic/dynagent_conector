<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no"/>
	<xsl:template match="/">
		<xsl:variable name="inputclass" ><xsl:value-of select="XMLRPC/attribute::clase" /></xsl:variable> 	
		<xsl:variable name="miempresa" >006</xsl:variable> 
		<datos plaindata="true" input="xmlrpc" idconvert="true"><!-- siempre mismo msguid, sera ignorado si vuelve a preguntar  -->	
			<xsl:choose>
				<xsl:when test="exists(XMLRPC/MAP/id)">
					<xsl:attribute name="MSGUID"><xsl:value-of select="concat($inputclass,'#',max(XMLRPC/MAP/id))" /></xsl:attribute>
					<xsl:attribute name="ID"><xsl:value-of select="XMLRPC/MAP/id" /></xsl:attribute>
				</xsl:when>							
			</xsl:choose>
			
			<objects>		
				<xsl:variable name="endpoint"><xsl:value-of select="/XMLRPC/attribute::endpoint" /></xsl:variable>							
				<xsl:variable name="source"><xsl:value-of select="/XMLRPC/attribute::source" /></xsl:variable>	
				<xsl:variable name="origen"><xsl:value-of select="'001'" /></xsl:variable>			
				
				<xsl:if test="$inputclass='CLIENTE'">					
					<xsl:variable name="refcliente"><xsl:value-of select="if(XMLRPC/MAP/ref!='false') then XMLRPC/MAP/ref else concat('SPID',XMLRPC/MAP/id)"/></xsl:variable>				
					<clone>
						<![CDATA[				

							SELECT
							
							case 	when padre.rdn is not null then 'newdir' 
									when clicode is null then 'new' 
									else 'set' end as test,
							del.rdn as del_rdn,
							case when clicode is not null then clicode else ']]><xsl:value-of select="$refcliente" /><![CDATA[' end as rdncliente,
							case when loc."rdn" is not null then loc."rdn" else ']]><xsl:value-of select="XMLRPC/MAP/city" /><![CDATA[' end as localidad,
							case when a.rdn is not null then a.rdn else 'WEB' end as rdnagente,
							case when a.rdn is not null and a.rdn ilike '%Shopi%Detalle%' then 'PVPWEB' else 'MAYOR' end as tarifa,
							case when rcli.rdn is not null then 'false' else NULL end as activo,
							case when ridreg.rdn is null then 'Regimen_General' else ridreg.rdn end as reg_iva,
							padre.rdn as rdnpadre
							
							FROM
	
							"delegación" as del 																																					left join
							(replica_ids as ridreg 	inner join
							"régimen_iva" as regiva on  ridreg.clases='RÉGIMEN_IVA' and
														ridreg."id_ERP"=regiva."tableId"::text and
														ridreg.destinatario =']]><xsl:value-of select="$source" /><![CDATA[')
										on  ridreg.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/property_account_position_id/ITEM[matches(.,'^\d+$')]" /><![CDATA['	  				left join
													  
							(select rdn from localidad where slug(rdn,false,true)=slug(']]><xsl:value-of select="XMLRPC/MAP/city" /><![CDATA[',false,true)	limit 1) as loc 
																			on loc.rdn is not null																			left join
												
							(select "tableId" as cliid,rdn as clicode from cliente_particular as cli 	
							  WHERE  ']]><xsl:value-of select="XMLRPC/MAP/ref" /><![CDATA['= rdn or
									 ']]><xsl:value-of select="XMLRPC/MAP/email" /><![CDATA['=email 
							 order by CASE 
									WHEN ']]><xsl:value-of select="XMLRPC/MAP/ref" /><![CDATA['= rdn THEN 2
									WHEN ']]><xsl:value-of select="XMLRPC/MAP/email" /><![CDATA['=email THEN 1
									ELSE 0
									END DESC
									LIMIT 1) as cliente		on cliid is not null																										left join
							replica_ids as rcli on 	cliid=rcli."id_ERP"::int and
													rcli.clases='CLIENTE_PARTICULAR' and
													rcli.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' and
													rcli.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/id" /><![CDATA['								left join
							(agente_comercial_externo as a 	inner join
							replica_ids as ra			on  ra.clases='AGENTE_COMERCIAL_EXTERNO' and
															a."tableId"=ra."id_ERP"::int and 
															ra."identificador_replicas"=']]><xsl:value-of select="XMLRPC/MAP/user_id/ITEM[matches(.,'^\d+$')]" /><![CDATA['
													) on ra.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' 																left join
							
							
							(replica_ids as rpar 		inner join
							cliente_particular as 	padre on padre."tableId"=rpar."id_ERP"::int and 
													rpar.clases='CLIENTE_PARTICULAR' and
													rpar.destinatario =']]><xsl:value-of select="$source" /><![CDATA['
										) on rpar.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/parent_id/ITEM[matches(.,'^\d+$')]" /><![CDATA['							
										
															   
							where 	del.rdn=']]><xsl:value-of select="$origen" /><![CDATA[' and
									length(']]><xsl:value-of select="XMLRPC/MAP/id" /><![CDATA[')>0
									
									
									
						]]>
					

						<CLIENTE_EMPRESA test="set" action="set" destination="0">
								<xsl:attribute name="rdn">{$rdncliente}</xsl:attribute>
								<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>
						</CLIENTE_EMPRESA>
							
						<CLIENTE_PARTICULAR test="new" action="createINE" >
							<xsl:attribute name="activo">{$activo}</xsl:attribute>
							<xsl:attribute name="rdn">{$rdncliente}</xsl:attribute>
							<xsl:attribute name="nombre"><xsl:value-of select="substring(XMLRPC/MAP/name,1,100)" /></xsl:attribute>
							 <xsl:if test="normalize-space(XMLRPC/MAP/street)">
								<xsl:attribute name="dirección"><xsl:value-of select="XMLRPC/MAP/street" /></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="fecha_alta"><xsl:value-of select="XMLRPC/MAP/create_date" /></xsl:attribute>
							<xsl:attribute name="email"><xsl:value-of select="XMLRPC/MAP/email" /></xsl:attribute>
							<xsl:attribute name="email_notificaciones"><xsl:value-of select="XMLRPC/MAP/email" /></xsl:attribute>
							<xsl:attribute name="teléfono"><xsl:value-of select="XMLRPC/MAP/phone" /></xsl:attribute>
							<xsl:attribute name="NIF-CIF-VAT"><xsl:value-of select="if(not(XMLRPC/MAP/vat) or string-length(XMLRPC/MAP/vat)=0) then '-' else XMLRPC/MAP/vat" /></xsl:attribute>
							<xsl:attribute name="código_postal"><xsl:value-of select="XMLRPC/MAP/zip" /></xsl:attribute>
							<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>
							<xsl:if test="XMLRPC/MAP/city!='false'">
								<LOCALIDAD action="createINE" property="localidad">
									<xsl:attribute name="rdn">{$localidad}</xsl:attribute>
								</LOCALIDAD>		
							</xsl:if>
							<whenc test="setag">
								<AGENTE_COMERCIAL_EXTERNO action="createINE" property="agente_comercial">
									<xsl:attribute name="rdn">{$rdnagente}</xsl:attribute>							
								</AGENTE_COMERCIAL_EXTERNO>
							</whenc>	
							
							<TARIFA_PRECIO action="set" property="tarifa_precio">	
								<xsl:attribute name="rdn">{$tarifa}</xsl:attribute>									
							</TARIFA_PRECIO>
							<RÉGIMEN_IVA action="createINE" property="régimen_iva">	
								<xsl:attribute name="rdn">{$reg_iva}</xsl:attribute>	
							</RÉGIMEN_IVA>
						</CLIENTE_PARTICULAR>
						
						<CLIENTE_EMPRESA test="newdir" action="set" destination="0">
							<xsl:attribute name="rdn">{$rdnpadre}</xsl:attribute>
							<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>
							<DIRECCIÓN  action="createINE" property="dirección_envío"  destination="0">
								<xsl:attribute name="rdn">PEDIDOCLIENTE#{$rdnpadre}</xsl:attribute>	
								<xsl:attribute name="dirección">{$direcc}</xsl:attribute>
								<xsl:attribute name="código_postal">{$postalcode}</xsl:attribute>
								<LOCALIDAD>					
									<xsl:attribute name="action">createINE</xsl:attribute>
									<xsl:attribute name="property">localidad</xsl:attribute>						
									<xsl:attribute name="rdn">{$localidad}</xsl:attribute>									
								</LOCALIDAD>
							</DIRECCIÓN>								
						</CLIENTE_EMPRESA>
							
						<REPLICA_IDS action="createINE" destination="0">									
							<xsl:attribute name="clases">CLIENTE_PARTICULAR</xsl:attribute>							
							<xsl:attribute name="identificador_replicas"><xsl:value-of select="XMLRPC/MAP/id" /></xsl:attribute>
							<xsl:attribute name="rdn">
								<xsl:value-of select="$source" />#CLIENTE_PARTICULAR#MAP<xsl:value-of select="XMLRPC/MAP/id" />
							</xsl:attribute>	
							<xsl:attribute name="destinatario"><xsl:value-of select="$source" /></xsl:attribute>							
							<xsl:attribute name="nombre"><xsl:value-of select="XMLRPC/MAP/name" /></xsl:attribute>							
							<CLIENTE_PARTICULAR property="DATAPROP:id_ERP" action="set">
								<xsl:attribute name="rdn">{$rdncliente}</xsl:attribute>
							</CLIENTE_PARTICULAR>							
						</REPLICA_IDS>						
					</clone>
				</xsl:if>					
				<xsl:if test="$inputclass='PEDIDO_DE_CLIENTE'">													
					<clone>
						<![CDATA[				

							SELECT
							case when rdoc.identificador_replicas is null then 'new' 
								 else 'set' end as test,
							del.rdn as del_rdn,
							c.rdn as rdncliente,
							case when a.rdn is null then 'WEB' else a.rdn end as rdnagente,
							dire."dirección" as direcc,
							dire."código_postal" as postalcode,
							case when loc.rdn is not null then loc.rdn else 'DESCONOCIDO' end as localidad
							
							FROM
							cliente_particular as c																																	left join
							distribuidor as dis	on		dis."tableId"=c.distribuidor																								inner join
							replica_ids as rc			on  rc.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' and
															rc.clases='CLIENTE_PARTICULAR' and
															c."tableId"=rc."id_ERP"::int and 
															rc."identificador_replicas"=']]><xsl:value-of select="XMLRPC/MAP/partner_id/ITEM[matches(.,'^\d+$')]" /><![CDATA['		left join
							(agente_comercial_externo as a 	inner join
							replica_ids as ra			on  ra.clases='AGENTE_COMERCIAL_EXTERNO' and
															a."tableId"=ra."id_ERP"::int and 
															ra."identificador_replicas"=']]><xsl:value-of select="XMLRPC/MAP/user_id/ITEM[matches(.,'^\d+$')]" /><![CDATA['
													) on ra.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' 															inner join
													
							"delegación" as del 		on del.rdn=']]><xsl:value-of select="$origen" /><![CDATA[' 																	left join
												
							(replica_ids as rdoc 	 		inner join
								(
									select "tableId" as id,'PEDIDO_DE_CLIENTE'    as clase from pedido_de_cliente        
									union 
									select "tableId" ,'PEDIDO_TRASPASO_ALMACENES' as clase from pedido_traspaso_almacenes 
								 ) as doc
							     on  doc.id=rdoc."id_ERP"::int and															
								 rdoc.clases=doc.clase
							)	on 						rdoc.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' and
														rdoc.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/id" /><![CDATA['											left join
														 
							"dirección" as dire on c."dirección_envío"=dire."tableId"						left join
							localidad as loc on loc."tableId"=dire.localidad
															
										
									
									
						]]>
						<xsl:variable name="rdntick"><xsl:value-of select="XMLRPC/MAP/name"/></xsl:variable>
						<PEDIDO_DE_CLIENTE  test="set" action="set" >
							<xsl:attribute name="rdn"><xsl:value-of select="$rdntick" /></xsl:attribute>
							<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>
						</PEDIDO_DE_CLIENTE>										
						<PEDIDO_DE_CLIENTE  test="new" action="new" factor_descuento_global="0">
							<xsl:attribute name="rdn"><xsl:value-of select="$rdntick" /></xsl:attribute>
							<xsl:attribute name="fecha"><xsl:value-of select="XMLRPC/MAP/date_order" /></xsl:attribute>
							<xsl:attribute name="importe"><xsl:value-of select="XMLRPC/MAP/amount_total" /></xsl:attribute>
							<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>
														
							<AGENTE_COMERCIAL_EXTERNO action="createINE" property="agente_comercial">
								<xsl:attribute name="rdn">{$rdnagente}</xsl:attribute>							
							</AGENTE_COMERCIAL_EXTERNO>					
							
							<CLIENTE_PARTICULAR action="set" property="cliente">
								<xsl:attribute name="rdn">{$rdncliente}</xsl:attribute>		
								<xsl:if test="XMLRPC/MAP/fiscal_position_id/ITEM[contains(upper-case(.), 'EQUIVALENCIA')]">
									<RÉGIMEN_IVA action="createINE" property="régimen_iva" rdn="Recargo_Equivalencia"/>								
								</xsl:if>
							</CLIENTE_PARTICULAR>
							
							<DELEGACIÓN property="delegación" action="set" >		
								<xsl:attribute name="rdn">{$del_rdn}</xsl:attribute>		
							</DELEGACIÓN>
							<ALMACÉN property="origen" action="set" >		
								<xsl:attribute name="rdn">{$del_rdn}</xsl:attribute>		
							</ALMACÉN>														
							<MI_EMPRESA property="mi_empresa" action="set" >			
								<xsl:attribute name="rdn"><xsl:value-of select="$miempresa" /></xsl:attribute>
							</MI_EMPRESA>
							<DIRECCIÓN action="createINE" property="dirección_envío"  destination="0">
								<xsl:attribute name="rdn"><xsl:value-of select="concat($rdntick,'#PEDIDOCLIENTE')" /></xsl:attribute>	
								<xsl:attribute name="dirección">{$direcc}</xsl:attribute>
								<xsl:attribute name="código_postal">{$postalcode}</xsl:attribute>
								<LOCALIDAD>					
									<xsl:attribute name="action">createINE</xsl:attribute>
									<xsl:attribute name="property">localidad</xsl:attribute>						
									<xsl:attribute name="rdn">{$localidad}</xsl:attribute>									
								</LOCALIDAD>
							</DIRECCIÓN>
						</PEDIDO_DE_CLIENTE>
						
						<REPLICA_IDS action="createINE" destination="0">									
							<xsl:attribute name="clases">PEDIDO_DE_CLIENTE</xsl:attribute>							
							<xsl:attribute name="identificador_replicas"><xsl:value-of select="XMLRPC/MAP/id" /></xsl:attribute>
							<xsl:attribute name="rdn">
								<xsl:value-of select="$source" />#PEDIDO_DE_CLIENTE#<xsl:value-of select="XMLRPC/MAP/id" />
							</xsl:attribute>	
							<xsl:attribute name="destinatario"><xsl:value-of select="$source" /></xsl:attribute>							
							<xsl:attribute name="nombre"><xsl:value-of select="XMLRPC/MAP/name" /></xsl:attribute>							
							<PEDIDO_DE_CLIENTE property="DATAPROP:id_ERP" action="set">
								<xsl:attribute name="rdn"><xsl:value-of select="$rdntick" /></xsl:attribute>
							</PEDIDO_DE_CLIENTE>							
						</REPLICA_IDS>						
					</clone>
				</xsl:if>	
				<xsl:if test="$inputclass='LÍNEA_ARTÍCULOS'">		
					<xsl:variable name="idproducto"><xsl:value-of select="XMLRPC/MAP/product_id/ITEM[matches(.,'^\d+$')]" /></xsl:variable>
					<xsl:variable name="refproducto"><xsl:value-of select="XMLRPC/MAP/product_id/ITEM[string-length(normalize-space(.)) >= 10]" /></xsl:variable>
					<clone>
						<![CDATA[				

							SELECT distinct
							case when doc.rdn is null then 'saltar'
								 when rlin.identificador_replicas is null then 'new' 
								 else 'set' end as test,											 
							
							doc.rdn as docrdn,
							g."rdn" as prodrdn,
							d.rdn as deleg_rdn,
							g.pvp_promocion as pvppromo,
							g.pvp_iva_incluido_promocion as pvppromoii,
							g.rdn as clave_producto,
							case when tiva.rdn is null then 'General21' else tiva.rdn end as tiva
							FROM																												
												
							replica_ids as rdoc																												left join
							pedido_de_cliente as doc on doc."tableId"=rdoc."id_ERP"::int 																	left join
														
							"delegación" as d 	on 		d."tableId"=doc."delegación"																		left join
							
							("línea_artículos_materia" as lin 	inner join 
							replica_ids as rlin on 		lin."tableId"=rlin."id_ERP"::int and
														rlin.clases='LÍNEA_ARTÍCULOS_MATERIA' and
														rlin.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' and
														rlin.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/id" /><![CDATA['
							) on "pedido_de_clienteId"=doc."tableId"
							
							,
							"género" as g																																						left join
							(replica_ids as ridtax 		inner join
							"tipo_iva" as tiva on  	ridtax.clases='TIPO_IVA' and
													ridtax."id_ERP"=tiva."tableId"::text and
													ridtax.destinatario =']]><xsl:value-of select="$source" /><![CDATA[')
										on  ridtax.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/tax_id/ITEM[matches(., '^\d+$') and . != '66']" /><![CDATA['	  			left join							
							replica_ids as rvar 		on 
														rvar.clases='VARIANTE' and
														rvar.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' and
														rvar.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/product_id/ITEM[matches(.,'^\d+$')]" /><![CDATA['	and
														g.rdn~('(?i)^'||rvar."id_ERP"||'(s?)$')
														
							
							
															   
							WHERE 
								  rdoc.clases='PEDIDO_DE_CLIENTE' and
								  rdoc.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' and
								  rdoc.identificador_replicas=']]><xsl:value-of select="XMLRPC/MAP/order_id/ITEM[matches(.,'^\d+$')]" /><![CDATA['	 and
								  (
									']]><xsl:value-of select="XMLRPC/MAP/product_id/ITEM[matches(.,'[a-zA-Z]')]" /><![CDATA[' ~ '(?i)Personalizado|Estandar|Estándar|Envio|Envío|Expres|Exprés' and g.rdn='8500000000' or
									']]><xsl:value-of select="XMLRPC/MAP/product_id/ITEM[matches(.,'[a-zA-Z]')]" /><![CDATA[' ~ '(?i)loyalt' and g.rdn='80000' or
									rvar.rdn is not null
								  )
								
									
									
						]]>
						
						<xsl:variable name="tipolinea">LÍNEA_ARTÍCULOS_MATERIA</xsl:variable>
						
						<xsl:variable name="tipoproducto">GÉNERO</xsl:variable>
						
						
						<xsl:variable name="rdnlin">ODOO<xsl:value-of select="$endpoint"/>#<xsl:value-of select="XMLRPC/MAP/id" /></xsl:variable>
						
						<whenc test="set">
							<xsl:element name="{$tipolinea}">								
								<xsl:attribute name="action">set</xsl:attribute>						
								<xsl:attribute name="rdn"><xsl:value-of select="$rdnlin" /></xsl:attribute>
								<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>	
							</xsl:element>
						</whenc>
						
						<whenc test="new">
							<xsl:element name="{$tipolinea}">								
								<xsl:attribute name="action">new</xsl:attribute>						
								<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>						
								<xsl:attribute name="fecha"><xsl:value-of select="XMLRPC/MAP/create_date" /></xsl:attribute>
								<xsl:attribute name="rdn"><xsl:value-of select="$rdnlin" /></xsl:attribute>
								<xsl:attribute name="cantidad"><xsl:value-of select="XMLRPC/MAP/product_uom_qty" /></xsl:attribute>
								<xsl:attribute name="precio"><xsl:value-of select="number(XMLRPC/MAP/price_unit)" /></xsl:attribute>
								<xsl:attribute name="descuento"><xsl:value-of select="number(XMLRPC/MAP/discount)" /></xsl:attribute>
								<!--<xsl:attribute name="precio_iva_incluido"><xsl:value-of select="XMLRPC/MAP/price_total" /></xsl:attribute>-->
								<xsl:attribute name="importe"><xsl:value-of select="XMLRPC/MAP/price_subtotal" /></xsl:attribute>
								<xsl:attribute name="importe_con_iva"><xsl:value-of select="XMLRPC/MAP/price_total" /></xsl:attribute>
								<xsl:attribute name="clave_producto">{$clave_producto}</xsl:attribute>
								<xsl:attribute name="reservado">true</xsl:attribute>	
															
								<xsl:element name="{$tipoproducto}">									
									<xsl:attribute name="action">createINE</xsl:attribute>						
									<xsl:attribute name="property">producto</xsl:attribute>														
									<xsl:attribute name="rdn">{$prodrdn}</xsl:attribute>							
								</xsl:element>					

								<TIPO_IVA action="set" property="iva">
									<xsl:attribute name="rdn">{$tiva}</xsl:attribute>
								</TIPO_IVA>								
								<MI_EMPRESA property="mi_empresa" action="set">			
									<xsl:attribute name="rdn"><xsl:value-of select="$miempresa" /></xsl:attribute>
								</MI_EMPRESA>	
								<PEDIDO_DE_CLIENTE action="set" property="línea">
									<xsl:attribute name="rdn">{$docrdn}</xsl:attribute>
								</PEDIDO_DE_CLIENTE>				
							</xsl:element>
							
							<STOCK action="createINE">
								<xsl:attribute name="destination">{$deleg_rdn}</xsl:attribute>									
								<xsl:attribute name="stock_reservado">
									<xsl:value-of select="concat('+',+1*number(XMLRPC/MAP/product_uom_qty))"/>								
								</xsl:attribute>
								<xsl:attribute name="stock_disponible">
									<xsl:value-of select="concat('+',-1*number(XMLRPC/MAP/product_uom_qty))"/>
								</xsl:attribute>
								
								<xsl:attribute name="rdn">{$deleg_rdn}#{$clave_producto}</xsl:attribute>			
								
								<xsl:attribute name="clave_producto">{$clave_producto}</xsl:attribute>	
								
								<xsl:attribute name="fecha_modificación">
									<xsl:value-of select="XMLRPC/MAP/create_date"/>
								</xsl:attribute>
								
								<GÉNERO property="producto" action="createINE">
									<xsl:attribute name="rdn">{$prodrdn}</xsl:attribute>
								</GÉNERO>
							
								<ALMACÉN property="almacén_stock" action="set">				
									<xsl:attribute name="rdn">{$deleg_rdn}</xsl:attribute>
								</ALMACÉN>
							</STOCK>
							
							<REPLICA_IDS action="createINE" destination="0">																	
								<xsl:attribute name="clases">LÍNEA_ARTÍCULOS_MATERIA</xsl:attribute>							
								<xsl:attribute name="identificador_replicas"><xsl:value-of select="XMLRPC/MAP/id" /></xsl:attribute>
								
								<xsl:attribute name="rdn"><xsl:value-of select="$source" />#LÍNEA_ARTÍCULOS_MATERIA#<xsl:value-of select="XMLRPC/MAP/id" /></xsl:attribute>	
								
								<xsl:attribute name="destinatario"><xsl:value-of select="$source" /></xsl:attribute>
								<xsl:attribute name="nombre"><xsl:value-of select="XMLRPC/MAP/name" /></xsl:attribute>	
								
								<xsl:element name="{$tipolinea}">
									<xsl:attribute name="property">DATAPROP:id_ERP</xsl:attribute>
									<xsl:attribute name="action">set</xsl:attribute>							
									<xsl:attribute name="rdn"><xsl:value-of select="$rdnlin" /></xsl:attribute>
								</xsl:element>							
							</REPLICA_IDS>
						</whenc>
					</clone>
				</xsl:if>
				<xsl:if test="$inputclass='GÉNERO'">		
					<xsl:variable name="idproducto"><xsl:value-of select="XMLRPC/MAP/id" /></xsl:variable>
					<xsl:if test="XMLRPC/MAP/default_code='false'">
							<GÉNERO  action="set" >
								<xsl:attribute name="rdn">#SALTAR#</xsl:attribute>
								<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>
							</GÉNERO>
						</xsl:if>
					<clone>
						<![CDATA[				

							SELECT
							case 
								 when rvar.identificador_replicas is not null then 'saltar'
								 when g.rdn is not null and rvar.identificador_replicas is null then 'new' 
								 else 'set' end as test,											 
							
							upper(case when g."rdn" is not null then g.rdn 
									   when ']]><xsl:value-of select="XMLRPC/MAP/default_code" /><![CDATA['='false' then ']]><xsl:value-of select="XMLRPC/MAP/product_variant_id/ITEM[matches(.,'[a-zA-Z]')]" /><![CDATA['
									   else ']]><xsl:value-of select="XMLRPC/MAP/default_code" /><![CDATA[' 
									   end 
									) as prodrdn,
							d.rdn as deleg_rdn,
							g.rdn as clave_producto
							FROM																												
												
							"delegación" as d 																					left join							
							"género" as g			on 	g.rdn ilike (case when ']]><xsl:value-of select="XMLRPC/MAP/default_code" /><![CDATA['='false' then ']]><xsl:value-of select="XMLRPC/MAP/product_variant_id/ITEM[matches(.,'[a-zA-Z]')]" /><![CDATA[' 
																          else  ']]><xsl:value-of select="XMLRPC/MAP/default_code" /><![CDATA[' end)	left join							
							replica_ids as rvar 		on 
														rvar.clases='VARIANTE' and
														rvar.destinatario =']]><xsl:value-of select="$source" /><![CDATA[' and
														rvar.identificador_replicas=']]><xsl:value-of select="$idproducto" /><![CDATA['	and
														g.rdn~('(?i)^'||rvar."id_ERP"||'(s?)$')																												
															   
							WHERE d.rdn=']]><xsl:value-of select="$origen" /><![CDATA[' 
																										
						]]>

						<xsl:variable name="tipoproducto">GÉNERO</xsl:variable>
						<whenc test="saltar">
							<GÉNERO  action="set" >
								<xsl:attribute name="rdn">#SALTAR#</xsl:attribute>
								<xsl:attribute name="destination"><xsl:value-of select="$source" /></xsl:attribute>
							</GÉNERO>
						</whenc>
						<whenc test="new">
							<REPLICA_IDS action="createINE" destination="0">																	
								<xsl:attribute name="clases">VARIANTE</xsl:attribute>							
								<xsl:attribute name="identificador_replicas"><xsl:value-of select="$idproducto" /></xsl:attribute>
								<xsl:attribute name="id_ERP">{$prodrdn}</xsl:attribute>
								<xsl:attribute name="rdn"><xsl:value-of select="$source" />#VARIANTE#MAP<xsl:value-of select="$idproducto" /></xsl:attribute>	
								
								<xsl:attribute name="destinatario"><xsl:value-of select="$source" /></xsl:attribute>								
						
							</REPLICA_IDS>
						</whenc>
					</clone>
				</xsl:if>
						
			</objects>
		</datos>
	</xsl:template>			
	<xsl:template name="stock">
		<xsl:param name = "central" />			
		<xsl:param name = "signoreserva"/>
		<xsl:param name = "cantidad"/>
		<xsl:param name = "product_reference"/>
		<xsl:element name="STOCK">			
			<!--ojo de la web si viene info fictitica de talla y color y aqui se construye stock y SKU-->
			<xsl:attribute name="action">createINE</xsl:attribute>
			<xsl:attribute name="destination"><xsl:value-of select="$central"/></xsl:attribute>	
			
			<xsl:attribute name="cantidad" select="concat('+',$cantidad)"/>
														
			<xsl:attribute name="stock_reservado" select="concat('+',number($signoreserva)*$cantidad)"/>
			<xsl:attribute name="stock_disponible" select="concat('+',-number($signoreserva)*$cantidad)"/>
			
			<xsl:attribute name="rdn">
				<xsl:value-of select="concat($central,'#',$product_reference)"/>					
			</xsl:attribute>			
			<xsl:attribute name="clave_producto">
				<xsl:value-of select="$product_reference"/>					
			</xsl:attribute>					
			<GÉNERO property="producto" action="createINE">
				<xsl:attribute name="rdn"><xsl:value-of select="$product_reference" /></xsl:attribute>
			</GÉNERO>
			<ALMACÉN property="almacén_stock" action="set">				
				<xsl:attribute name="rdn"><xsl:value-of select="$central" /></xsl:attribute>
			</ALMACÉN>
		</xsl:element>	
	</xsl:template>
</xsl:stylesheet>