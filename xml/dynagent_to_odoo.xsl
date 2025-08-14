<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no"/>
	<xsl:variable name="empresaclp" >'001','006'</xsl:variable>
	<xsl:variable name="empresaclp2" >005</xsl:variable>
	<xsl:variable name="almcentral" >001</xsl:variable>
	<xsl:variable name="euros" >1</xsl:variable><!--124 para vers sh 16.0-->
	
	<xsl:variable name="diarioventas" >1</xsl:variable><!--local 4, CLP 18, sh 16.0 el 9-->
	<xsl:variable name="diariobanco" >7</xsl:variable><!--local 4, CLP 18, sh el 14-->
	<xsl:variable name="discountproduct" >14</xsl:variable><!--local 4, CLP 18-->
	<xsl:variable name="otroproduct" >17023</xsl:variable>
	<xsl:variable name="defteam" >1</xsl:variable>
	<xsl:variable name="location" >8</xsl:variable>
	<xsl:variable name="globalaction"><xsl:value-of select="if(/datos[@action]) then /datos/attribute::action else 'NA'" /></xsl:variable>
	<xsl:template match="/">
		
		<datos plaindata="true" output="Odoo" idconvert="true">
			<objects>				
				
				<xsl:variable name="gconfig_de_img_src"><xsl:value-of select="(//IMAGEN[matches(@rdn,'MAG')]/GÉNERO[string-length(@rdn)=5] | //IMAGEN[matches(@rdn,'MAG')]/parent::GÉNERO[string-length(@rdn)=5])/attribute::tableId" separator=","/></xsl:variable>
				<xsl:variable name="g_de_img_src"><xsl:value-of select="(//IMAGEN[matches(@rdn,'MAG')]/GÉNERO[string-length(@rdn)=10] | //IMAGEN[matches(@rdn,'MAG')]/parent::GÉNERO[string-length(@rdn)=10])/attribute::tableId" separator=","/></xsl:variable>				
				
				<xsl:variable name="gconfig_de_cat_src"><xsl:value-of select="(//CATEGORIA_ARTICULO[matches(@rdn,'MAG')]/GÉNERO[string-length(@rdn)=5 or string-length(@rdn)=10] | //CATEGORIA_ARTICULO[matches(@rdn,'MAG')]/parent::GÉNERO[string-length(@rdn)=5 or string-length(@rdn)=10])/attribute::tableId" separator=","/></xsl:variable>
				
				
				<xsl:variable name="coloridsrc"><xsl:value-of select="datos/objects/COLOR[matches(@rdn,'MAG') and @action='set' and matches(attribute::descripción,'\D{3,}')]/attribute::tableId" separator=","/></xsl:variable>
				<xsl:variable name="modelofvarnewsrc"><xsl:value-of select="datos/objects/STOCK[matches(@rdn,'001#([A-Z]|\d){10}$') and @action='new']/substring(attribute::rdn,5,5)" separator="','"/></xsl:variable>				
				
				<xsl:variable name="generotmplsrc"><xsl:value-of select="datos/objects/GÉNERO[matches(@rdn,'^([A-Z]|\d){10}$') and @action='new']/attribute::rdn" separator="','"/></xsl:variable>
				<xsl:variable name="servicetmplsrc"><xsl:value-of select="datos/objects/SERVICIO[@action='new' or @action='set']/attribute::tableId" separator=","/></xsl:variable>
			
				<xsl:variable name="gensetsrc">   <xsl:value-of select="datos/objects/GÉNERO[matches(@rdn,'^\d+$') and @action='set' and @campo_aux1]/attribute::rdn" separator="','"/></xsl:variable>
				<xsl:variable name="gendescsrc"><xsl:value-of select="datos/objects/GÉNERO[matches(@rdn,'^([A-Z]|\d){10}$') and @visible_web='false']/attribute::tableId" separator=","/></xsl:variable><!-- por defecto es true, solo atiendo a false porque este dato se envia masivamente aunque no haya cambiado, cuando se crea excel visibilidad otras redees como franquicia-->		
				
				<xsl:variable name="repoffsrc"><xsl:value-of select="datos/objects/REPLICA_IDS[@activo='false']/attribute::tableId" separator=","/></xsl:variable>	
				
				<xsl:variable name="stock_new_idsrc"><xsl:value-of select="datos/objects/STOCK[matches(@rdn,'001#([A-Z]|\d){10}$') and ($globalaction='new' or @action='new')]/attribute::tableId" separator=","/></xsl:variable>			

				<xsl:variable name="stock_y_quant_set_idsrc"><xsl:value-of select="datos/objects/STOCK[matches(@rdn,concat('^',$almcentral,'R?#([A-Z]|\d){10}')) and (@action='set' or @action='new')]/attribute::tableId" separator=","/></xsl:variable>	
				
				
				<xsl:if test="string-length($servicetmplsrc)&gt;0">
					<xsl:call-template name="services">
						<xsl:with-param name="servicetmpl" select = "$servicetmplsrc" />
					</xsl:call-template>
				</xsl:if>
				
				<xsl:variable name="cliente_potencial_src"><xsl:value-of select="//CLIENTE_POTENCIAL/attribute::tableId" separator=","/></xsl:variable>											

				<xsl:variable name="colorids">
					<xsl:value-of select="if(string-length($coloridsrc)=0) then 0 else $coloridsrc"/>
				</xsl:variable>
																					
				<xsl:variable name="gconfig_de_img_id">
					<xsl:value-of select="if(string-length($gconfig_de_img_src)=0) then 0 else $gconfig_de_img_src"/>
				</xsl:variable>					

				<xsl:variable name="g_de_img_id">
					<xsl:value-of select="if(string-length($g_de_img_src)=0) then 0 else $g_de_img_src"/>
				</xsl:variable>					

				<xsl:variable name="gconfig_de_cat_id">
					<xsl:value-of select="if(string-length($gconfig_de_cat_src)=0) then 0 else $gconfig_de_cat_src"/>
				</xsl:variable>	
				
				<xsl:variable name="stock_new_ids">
					<xsl:value-of select="if(string-length($stock_new_idsrc)=0) then 0 else $stock_new_idsrc"/>
				</xsl:variable>	
				
				<xsl:variable name="gendesc_id">
					<xsl:value-of select="if(string-length($gendescsrc)=0) then 0 else $gendescsrc"/>
				</xsl:variable>	
				
				<xsl:if test="string-length($gensetsrc)&gt;0">					
					<xsl:call-template name="genero">
						<xsl:with-param name="genset" select = "concat('''',$gensetsrc,'''')" />
					</xsl:call-template>
				</xsl:if>	
				
				<xsl:if test="$stock_new_ids!='0' or string-length($generotmplsrc)&gt;0 ">
					<xsl:call-template name="stocknew">
						<xsl:with-param name="stock_new_ids" select = "$stock_new_ids" />	
						<xsl:with-param name="gconfig_de_img_id" select = "$gconfig_de_img_id" />
						<xsl:with-param name="g_de_img_id" select = "$g_de_img_id" />
						<xsl:with-param name="gconfig_de_cat_id" select = "$gconfig_de_cat_id" />
						<xsl:with-param name="coloridsparam" select = "$colorids" />	
						<xsl:with-param name="modelofvarnew" select = "concat('''',$modelofvarnewsrc,'''')" />
						<xsl:with-param name="generotmpl" select = "concat('''',$generotmplsrc,'''')" />
					</xsl:call-template>
				</xsl:if>
				
				<xsl:variable name="stock_y_quant_set_ids ">
					<xsl:value-of select="if(string-length($stock_y_quant_set_idsrc)=0) then 0 else $stock_y_quant_set_idsrc"/>
				</xsl:variable>			
				
				<xsl:if test="$stock_y_quant_set_ids!='0' or string-length($stock_y_quant_set_ids)&gt;0">
					<xsl:call-template name="stock_y_quant_set">
						<xsl:with-param name="stock_y_quant_set_ids" select = "$stock_y_quant_set_ids" />	
					</xsl:call-template>
				</xsl:if>
						

				<xsl:for-each select="datos/objects/*[@action='new' and name()='TIPO_IVA' 
													or 
													@action='set' and name()='GÉNERO' and (@pvp or @descripción or @visible_web or @pvp_promocion) 
													or name()='PRECIO']">											
					<xsl:call-template name="anynode"/>
				</xsl:for-each>
			</objects>
		</datos>
	</xsl:template>
	
	<xsl:template name="anynode">	
		<xsl:variable name="action"><xsl:value-of select="if(/datos[@action]) then /datos/attribute::action else attribute::action" /></xsl:variable>
		<xsl:choose>			
			<xsl:when test="self::CATEGORIA_ARTICULO and ($action='new' or $action='set') and starts-with(attribute::rdn,'MAG')">				
				<clone>
					<![CDATA[	
						select 
							case when rcat.identificador_replicas is null then 'new' else 'set' end as test,
							endpoint."página_web" as urldest,
							rcat.identificador_replicas as idrep,
							endpoint.rdn as endpointdest,
							slug(rcat."descripción",true,false) as catname,
							slug(rcat.nombre,false,false)  as catslug,
							case when rcat.campo_aux1='LEVEL0' then 1 else NULL end as isroot,
							case when rsup.identificador_replicas is not null and rsup.identificador_replicas ~'\d+' and rsup.identificador_replicas::int>0 then rsup.identificador_replicas else NULL end as idrepsup
						from 							
							
							replica_ids as rcat 																						left join
							replica_ids as rsup on	rsup.clases='CATEGORIA_ARTICULO' and 
													rsup.destinatario like '$ENDPOINT$%'  and
													rsup."id_ERP"~('^|(\{|\,)'||rcat."id_ERP_parent"||'(\}|\,|$)')
													,
							"delegación" as endpoint 																					
						where ('$ENDPOINT$'='*' or '$ENDPOINT$' like endpoint.rdn||'%' ) and
								rcat.identificador_replicas is null and 
								not(rsup.rdn is not null and rsup.identificador_replicas is null) and
								rcat.clases='CATEGORIA_ARTICULO' and 
								rcat."id_ERP"~('(^|\{|\,)'||]]><xsl:value-of select="attribute::tableId" /><![CDATA[||'(\}|\,|$)')	 	and
								rcat.destinatario like '$ENDPOINT$%' and								
								rcat.campo_aux1 in('LEVEL1','LEVEL2')
						order by endpoint.rdn
					]]>
					<atom http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>		
						<xsl:attribute name="slug">{$catslug}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="rdnreplicas">{$endpointdest}#categ#<xsl:value-of select="name(.)" />#{$catslug}</xsl:attribute>
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>product.category</par>	
							<par>create</par>
							<list>							
								<dict>
									<name>{$catname}</name>
									<parent_id>1</parent_id><!--de momento categoria padre 1-->
								</dict>	
							</list>
						</list>
					</atom>
				</clone>
			</xsl:when>			
			<xsl:when test="self::TIPO_IVA and attribute::action='new'">
				<clone>
				<!-- la operacion xmlrpc 'search' indica que no se va crear ningun dato en remoto (post) sino capturar su ID para replicaids
				Y la busqueda en remoto se hace por el campo name que está hardodeado de los ivas de ODOO-->
				<![CDATA[	
						select
						endpoint."página_web" as urldest,
						endpoint."rdn" as endpointdest,
						ti.porcentaje_iva as piva,
						ri.identificador_replicas as ridiva,
						rpais.identificador_replicas as ridpais,
						rempresa.identificador_replicas as ridempresa,
						
						case when rtaxgr ilike '%ventas%' then 'sale' else 'purchase' end as taxuse,
						case 
							when rtaxgr ilike '%ventas%' and ti.rdn='General21' then 'IVA 21% (Bienes)'
							when rtaxgr ilike '%compra%' and ti.rdn='General21' then '21% IVA soportado (bienes corrientes)'							
							when rtaxgr ilike '%ventas%' and ti.rdn='Exento_Intracomunitario' then 'IVA 0% Entregas Intracomunitarias exentas'
							when rtaxgr ilike '%compra%' and ti.rdn='Iva_Intracomunitario' then 'IVA 21% Adquisición Intracomunitaria. Bienes corrientes'
							when rtaxgr ilike '%ventas%' and ti.rdn='Exento' then 'IVA Exento Repercutido Sujeto'
							when rtaxgr ilike '%compra%' and ti.rdn='Exento' then 'IVA Soportado exento (operaciones corrientes)'
							
							else NULL end as name,
						
						ti.rdn||'-'||rtaxgr as slug
						

						from 									
						tipo_iva as ti																				left join
						replica_ids as ri on 		ri.destinatario='$ENDPOINT$' and
													ri.clases='TIPO_IVA' and "id_ERP"=ti."tableId"::text 	,			
						unnest(ARRAY['ventas','compras']) as rtaxgr ,
						"delegación" as endpoint																	inner join
						"mi_empresa" as m on m."tableId"="empresaMI_EMPRESA"										inner join
						replica_ids as rpais on 	rpais.destinatario='$ENDPOINT$' and
													rpais.clases='PAÍS' and													
													rpais."id_ERP"::int=m."país"									inner join
						replica_ids as rempresa on 	rempresa.destinatario='$ENDPOINT$' and
													rempresa.clases='MI_EMPRESA'
								
					where 
							
							('$ENDPOINT$'='*' or '$ENDPOINT$' like endpoint.rdn||'%' ) and
							ti.rdn in('General21','Iva_Intracomunitario','Exento_Intracomunitario','Exento') 
							and not (ti.rdn='Iva_Intracomunitario' and rtaxgr ilike '%ventas%')  and not(ti.rdn='Exento_Intracomunitario' and rtaxgr ilike '%compras%')
							and ti.porcentaje_iva is not null and ti."tableId"=']]><xsl:value-of select="attribute::tableId" /><![CDATA[']]>
					
					<atom http="POST" new_field_response="" action="set" >	
						<xsl:copy-of select="@*[name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="groupby">{$name}</xsl:attribute>	
						<xsl:attribute name="slug">{$slug}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>							
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.tax</par>	
							<par>search</par>							
							<list>																							
								<list>															
									<list>
										<par>name</par>								
										<par>=</par>
										<par>{$name}</par>
									</list>
								</list>								
							</list>
						</list>
					</atom>
					<!-- En vez de crear con usage, ya existen tanto de ventas (gracias a localiza española y AET) como de compras y debo capturar
					<atom http="POST" new_field_response="" >	
						<xsl:copy-of select="@*[name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="slug">{$slug}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>							
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.tax</par>	
							<par>create</par>
							<list>							
								<dict>
									<name>{$name}</name>
									<amount>{$piva}</amount>
									<amount_type>percent</amount_type>
									<country_id>{$ridpais}</country_id>
									<company_id>{$ridempresa}</company_id>
									<tax_group_id>{$idrtaxgr}</tax_group_id>
									<type_tax_use>{$taxuse}</type_tax_use>
								</dict>	
							</list>
						</list>
					</atom>		-->					
					
				</clone>
			</xsl:when>
			<xsl:when test="self::ALMACÉN and attribute::action='new'">
				<clone>
				<![CDATA[	
						select
						endpoint."página_web" as urldest,
						endpoint."rdn" as endpointdest,
						
						alm.nombre,
						rempresa.identificador_replicas as ridempresa						

						from 									
						"almacén" as alm																		left join
						replica_ids as ra on 	ra.destinatario='$ENDPOINT$' and
												ra.clases='ALMACÉN' and "id_ERP"=alm."tableId"::text ,
						"delegación" as endpoint																inner join
						"mi_empresa" as m on m."tableId"="empresaMI_EMPRESA"									inner join
						replica_ids as rempresa on 	rempresa.destinatario='$ENDPOINT$' and
													rempresa.clases='MI_EMPRESA'															
								
					where ('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$') and alm."tableId"=']]><xsl:value-of select="attribute::tableId" /><![CDATA[']]>
					<atom http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="slug"><xsl:value-of select="attribute::rdn" /></xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>stock.warehouse</par>	
							<par>create</par>
							<list>							
								<dict>
									<name>{$nombre}</name>
									<code>text:<xsl:value-of select="attribute::rdn" /></code>																		
									<company_id>{$ridempresa}</company_id>
									<delivery_steps>ship_only</delivery_steps>
									<!--reception_steps:one_step-->
								</dict>	
							</list>
						</list>
					</atom>
				</clone>
			</xsl:when>	

			<xsl:when test="self::PEDIDO_DE_CLIENTE ">				
				<clone>
					<![CDATA[
						select distinct
							case 								
								when rdoc.rdn is null then 'new'
								when rdoc.rdn is not null and rlin.identificador_replicas is null and rvar.identificador_replicas is not null then 'newlin' 
								when rdoc.rdn is not null and rlin.identificador_replicas is not null and rvar.identificador_replicas is not null then 'setlin' 
								else 'NA'
								end as test,
								
							endpoint."página_web" as urldest,
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,
							rtar.identificador_replicas as ridtarifacli,
							
							rcli.identificador_replicas as idrcliente,
													
							rdoc.identificador_replicas as rpedid,
							
							c.nombre as clinombre,
							c."tableId" as clitid,
							round(doc.base::numeric,3) as base,
							round(doc.importe::numeric,3) as importe,
							round(doc.total_iva::numeric,3) as total_iva,							
							doc.cantidad_total,
							doc."tableId" as tid_tick,							
							rmon.identificador_replicas as idrmon,
							ralm.identificador_replicas as ridwareh,
							ragente.identificador_replicas as idragente,
							endpoint.rdn as endpointdest,	
							lin."tableId" as tidlin,
							rlin.identificador_replicas as rlinid,
							lin.cantidad,
							s.stock_disponible,
							lin.precio,
							(lin.importe_con_iva-lin.importe) as lineaiva,
							lin.descuento,
							
							riva.identificador_replicas as ridtax,
							rvar.identificador_replicas as rvarianteid,
							g.rdn as sku,							
							
							array_agg('{'||rp.identificador_replicas||','||gconfig."descripción"||','||lin.cantidad||','||lin.precio||','||lin.precio_iva_incluido||','||ralm.identificador_replicas||'}') OVER (PARTITION BY doc.rdn) as linea
						from 							
							pedido_de_cliente as doc																					inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c on "clienteCLIENTE_PARTICULAR"=c."tableId"										inner join
							
							replica_ids as ralm 	on	ralm.clases='ALMACÉN' and
														ralm.destinatario='$ENDPOINT$' and
														ralm."id_ERP"=doc.origen::text													inner join

							replica_ids as rempresa on 	rempresa.destinatario='$ENDPOINT$' and
														rempresa.clases='MI_EMPRESA'	and
														rempresa."id_ERP"=emp."tableId"::text											inner join 
							replica_ids as rcli on 		rcli.destinatario = '$ENDPOINT$' and
														rcli.clases='CLIENTE_PARTICULAR' and
														rcli."id_ERP"::int=c."tableId"													inner join
							"línea_artículos_materia" as lin on lin."pedido_de_clienteId"=doc."tableId"									inner join
							"género" as g 			on g."tableId"=producto 															inner join
							"género" as gconfig 	on gconfig.rdn=substring(g.rdn,1,5)													inner join
							stock as s 				on	s.producto=g."tableId" and 	
														doc.origen="almacén_stock" 														inner join 															
							
							replica_ids as rp 		on  rp.destinatario='$ENDPOINT$' and 
														rp.clases='GÉNERO' and
														rp."id_ERP"=gconfig.rdn															left join
							replica_ids as rvar on 		rvar.clases='VARIANTE' and rvar.destinatario='$ENDPOINT$' and
														rvar."id_ERP"=g.rdn																left join
							replica_ids as rlin on 		rlin.clases='LÍNEA_ARTÍCULOS_MATERIA' and 
														rlin.destinatario='$ENDPOINT$' and
														rlin."id_ERP"::int=lin."tableId"												left join
							replica_ids as riva on 	riva.destinatario='$ENDPOINT$' and
													riva.clases='TIPO_IVA' and
													riva."id_ERP"=lin.iva::text															left join
													
							distribuidor as dis 	on	dis."tableId"=doc."agente_comercialDISTRIBUIDOR"								left join										
							
							replica_ids as ragente	on 	ragente."id_ERP"=dis."tableId"::text 	and
														ragente.clases='AGENTE' 				and
														ragente.destinatario ='$ENDPOINT$'												left join
														
							replica_ids as rdoc on 	rdoc.clases='PEDIDO_DE_CLIENTE' and  
														doc."tableId"=rdoc."id_ERP"::int and 
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 															left join
							
							(tarifa_precio as tar 										 	inner join
							replica_ids as rtar on 		rtar.destinatario='$ENDPOINT$' and
														rtar.clases='TARIFA_PRECIO'	and
														rtar."id_ERP"=tar."tableId"::text
							) on tar."tableId"=c.tarifa_precio	
														,																				
							"delegación" as endpoint
																
															   
							where 	doc.base is not null and doc."tableId"=]]><xsl:value-of select="attribute::tableId" /><![CDATA[ and									
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
							
						order by endpoint.rdn
					]]>
							
					<atom test="new" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="groupby"><xsl:value-of select="attribute::rdn" /></xsl:attribute>	
						<xsl:attribute name="slug"><xsl:value-of select="attribute::rdn" /></xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
																																		
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>sale.order</par>	
							<par>create</par>
							<list>							
								<dict>
									<picking_policy>direct</picking_policy>									
									<name>text:<xsl:value-of select="attribute::rdn" /></name>																							
									<company_id>{$ridempresa}</company_id>
									<date_order>{$fecha}</date_order>
									<partner_id>{$idrcliente}</partner_id>
									<pricelist_id>{$ridtarifacli}</pricelist_id>
									<warehouse_id>{$ridwareh}</warehouse_id>	
									<amount_total>{$importe}</amount_total>
									<amount_tax>{$total_iva}</amount_tax>
									<amount_untaxed>{$base}</amount_untaxed>
									<state>sale</state><!--draft significa presupuesto, sale es tras darle a confirmar el presupuesto que pasa a pedido y se crea un picking id-->									
								</dict>	
							</list>
						</list>
					</atom>			
					<atom test="newlin" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn']"/>
						<xsl:attribute name="groupby">{$sku}</xsl:attribute>	
						<xsl:attribute name="tableId">{$tidlin}</xsl:attribute>		
						<xsl:attribute name="slug">{$sku}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class">LÍNEA_ARTÍCULOS_MATERIA</xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>sale.order.line</par>								
							<par>create</par>
							<list>		
								<dict>
									<product_uom_qty>{$cantidad}</product_uom_qty>									
									<order_id>{$rpedid}</order_id>														
									<price_unit>{$precio}</price_unit>
									<price_tax>{$lineaiva}</price_tax>
									<discount>{$descuento}</discount>
									<tax_id>
										<list>
											<par>{$ridtax}</par>
										</list>
									</tax_id>
									<product_id>{$rvarianteid}</product_id>
									<customer_lead></customer_lead>
								</dict>	
							</list>
						</list>
					</atom>			
					<!--<atom test="setlin" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn']"/>
						<xsl:attribute name="groupby">{$sku}</xsl:attribute>	
						<xsl:attribute name="tableId">{$tidlin}</xsl:attribute>		
						<xsl:attribute name="slug">{$sku}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class">LÍNEA_ARTÍCULOS_MATERIA</xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>sale.order.line</par>								
							<par>write</par>
							<list>								
								<list>
									<par>{$rlinid}</par>
								</list>															
								<dict>
									<product_uom_qty>{$cantidad}</product_uom_qty>									
									<order_id>{$rpedid}</order_id>														
									<price_unit>{$precio}</price_unit>
									<price_tax>{$lineaiva}</price_tax>
									<discount>{$descuento}</discount>
									<tax_id>
										<list>
											<par>{$ridtax}</par>
										</list>
									</tax_id>
									<product_id>{$rvarianteid}</product_id>
									<customer_lead></customer_lead>																			
									<qty_available_today>{$stock_disponible}</qty_available_today>
									<free_qty_today>{$stock_disponible}</free_qty_today>
								</dict>	
							</list>
						</list>
					</atom>			-->				
					<!-- stock move agrupa por lotes  
						<atom test="new" http="POST" new_field_response="">
					-->
				</clone>
			</xsl:when>	
			<!--<xsl:when test="self::ALBARÁN_CLIENTE">				
				<clone>
					<![CDATA[
						select distinct
							case 								
							
								when rmove.identificador_replicas is not null and rmvlin.identificador_replicas is null then 'newlin' 
								else 'NA'
								end as test,
								
							endpoint."página_web" as urldest,
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,
							
							
							rcli.identificador_replicas as idrcliente,
													
							ralm.identificador_replicas as locationid,
							
							c.nombre as clinombre,
							c."tableId" as clitid,
							round(doc.base::numeric,3) as base,
							round(doc.importe::numeric,3) as importe,
							round(doc.total_iva::numeric,3) as total_iva,							
							doc.cantidad_total,
							doc."tableId" as tid_tick,							
							rdoc.identificador_replicas as pickid,
							
							endpoint.rdn as endpointdest,	
							lin."tableId" as tidlin,
							rmove.identificador_replicas as rmoveid,
							lin.cantidad,
							s.stock_disponible,
							lin.precio,
							(lin.importe_con_iva-lin.importe) as lineaiva,
							lin.descuento,
							
							riva.identificador_replicas as ridtax,
							rvar.identificador_replicas as rvarianteid,
							g.rdn as sku,							
							
							array_agg('{'||rp.identificador_replicas||','||gconfig."descripción"||','||lin.cantidad||','||lin.precio||','||lin.precio_iva_incluido||','||ralm.identificador_replicas||'}') OVER (PARTITION BY doc.rdn) as linea
						from 							
							"albarán_cliente" as doc																					inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c on "clienteCLIENTE_PARTICULAR"=c."tableId"										inner join
							
							replica_ids as ralm 	on	ralm.clases='ALMACÉN' and
														ralm.destinatario='$ENDPOINT$' and
														ralm."id_ERP"=]]><xsl:value-of select="$almcentral" /><![CDATA[			inner join

							replica_ids as rempresa on 	rempresa.destinatario='$ENDPOINT$' and
														rempresa.clases='MI_EMPRESA'	and
														rempresa."id_ERP"=emp."tableId"::text											inner join 
							replica_ids as rcli on 		rcli.destinatario = '$ENDPOINT$' and
														rcli.clases='CLIENTE_PARTICULAR' and
														rcli."id_ERP"::int=c."tableId"													inner join
							"línea_artículos_materia" as lin on lin."albarán_clienteId"=doc."tableId"									inner join
							"género" as g 			on g."tableId"=producto 															inner join
							"género" as gconfig 	on gconfig.rdn=substring(g.rdn,1,5)													inner join
							stock as s 				on	s.producto=g."tableId" and 	
														doc."origenALMACÉN"="almacén_stock" 											inner join 															
							
							replica_ids as rp 		on  rp.destinatario='$ENDPOINT$' and 
														rp.clases='GÉNERO' and
														rp."id_ERP"=gconfig.rdn															left join
							replica_ids as rvar on 		rvar.clases='VARIANTE' and rvar.destinatario='$ENDPOINT$' and
														rvar."id_ERP"=g.rdn																left join
							replica_ids as rmove on 		rmove.clases='STOCK_MOVE' and 
														rmove.destinatario='$ENDPOINT$' and
														rmove."id_ERP"::int=lin."tableId"												inner join
														
							replica_ids as rped on 		rped.clases='PEDIDO_DE_CLIENTE'	and
														rped."id_ERP"::int=lin."pedido_de_clienteId" and 
														rped.destinatario ='$ENDPOINT$													left join
							
							replica_ids as rdoc on 		rdoc.clases='ALBARÁN_CLIENTE' and 
														rdoc.parent=rped.identificador_replicas and
														rdoc.destinatario ='$ENDPOINT$' 												left join

							replica_ids as rmvlin on 	rmvlin.clases='STOCK_MOVE_LINE' and 
														rmvlin.destinatario='$ENDPOINT$' and
														rmvlin."id_ERP"::int=lin."tableId"											left join
														
							replica_ids as riva on 		riva.destinatario='$ENDPOINT$' and
														riva.clases='TIPO_IVA' and
														riva."id_ERP"::int=lin.iva																	

														,																				
							"delegación" as endpoint
																
															   
							where 	doc.base is not null and doc."tableId"=]]><xsl:value-of select="attribute::tableId" /><![CDATA[ and									
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						order by endpoint.rdn
					]]>
								
	
					<atom test="newlin" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn']"/>
						<xsl:attribute name="groupby">{$sku}</xsl:attribute>	
						<xsl:attribute name="tableId">{$tidlin}</xsl:attribute>		
						<xsl:attribute name="slug">{$sku}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class">STOCK_MOVE_LINE</xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>stock.move.line</par>								
							<par>create</par>
							<list>																							
								<dict>
									<company_id>{$ridempresa}</company_id>
									<move_id>{$rmoveid}</move_id>
									<picking_id>{$pickid}</picking_id>
									<product_id>{$rvarianteid}</product_id>
									<product_uom_qty>{$cantidad}</product_uom_qty>
									<qty_done>{$cantidad}</qty_done>	
									<product_uom_id>1</product_uom_id>
									<product_uom_category_id>1</product_uom_category_id>
									<location_id>8</location_id>
									<location_dest_id>5</location_dest_id>
								</dict>	
							</list>
						</list>
					</atom>	
					 stock move agrupa por lotes  
						<atom test="new" http="POST" new_field_response="">
						array_agg('{'||riva.identificador_replicas||'}') OVER(PARTITION BY g.rdn) as ridtaxarr,
					
				</clone>
			</xsl:when>		-->
			<xsl:when test="self::FACTURA_A_CLIENTE or self::FACTURA_RECTIFICATIVA_VENTAS or self::ALBARÁN-FACTURA_CLIENTE"><!-- ADAPTAR A PEDIDOS -->
				<clone>
					<![CDATA[
						select distinct
							case 								
								
								when rdoc.rdn is null then 'new'																																
								when rdoc.campo_aux1='draft' then 'post'
								else 'NA'
								end as test,
								

							endpoint."página_web" as urldest,							
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,							
							
							rcli.identificador_replicas as idrcliente,
							NULL as teamid,
							
							rdoc.identificador_replicas as rpedid,
					
							
							doc."tableId" as doctid,
							case 	when (doc.idto in(124,319) or doc.base>0) and RIGHT(doc.rdn, 1) = '0' THEN SUBSTRING(doc.rdn FROM 1 FOR LENGTH(doc.rdn) - 1)
									ELSE doc.rdn end  as docrdn,
							rmon.identificador_replicas as idrmon,
							
							
							endpoint.rdn as endpointdest,	
							lin."tableId"::text as tidlin,
							null as rlinid,																				  																				

							-(case when doc.idto=249 or doc.base<0 then -1 else 1 end) as cantidad,														
							
							round(lin.importe::numeric,2) as precio,								
	
							0.0 as descuento,
							riva.identificador_replicas as ridtax,
							case when regiva.rdn ~ '(?i)Recargo' then riva_rec.identificador_replicas else NULL end as ridtaxrec,
							']]><xsl:value-of select="$discountproduct" /><![CDATA[' as rvarianteid,
							'DESCUENTO'  as sku,
							'DESCUENTO '||lin.porcentaje::text as prodescr,

							raccvmerc.identificador_replicas as account_venta_mercaderia,
							
							doc.rdn,
							
							0 as siiregkey,
							null as move_type,
							'0' as posfiscal,
							'DESCUENTO' as claselinea,
							3 as orderrow
						from 							
							v_factura as doc																							inner join
							descuento_global as lin on (doc."tableId",doc.idto) in(	
															(lin."factura_a_clienteId",124),
															(lin."factura_rectificativa_ventasId",249),
															(lin."albarán-factura_clienteId",319),
															(lin."ticket_ventaId",125))													inner join
							"delegación" as del 	on doc."delegación"=del."tableId"													inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c 
								on(  																
									']]><xsl:value-of select="name(.)" /><![CDATA['='TICKET_VENTA' and c.rdn=del.rdn	or
									"cliente"=c."tableId" and "clienteIdto"=485
								  )																										inner join
									
															
							replica_ids as rempresa on 				rempresa.destinatario='$ENDPOINT$' and
																	rempresa.clases='MI_EMPRESA'	and
																	rempresa."id_ERP"::int=emp."tableId"								inner join 
							replica_ids as rcli on 					rcli.destinatario = '$ENDPOINT$' and
																	rcli.clases='CLIENTE_PARTICULAR' and
																	rcli."id_ERP"=c."tableId"::text	and
																	rcli.identificador_replicas ~'^\d+$'								inner join 
							desglose_iva as div			on   																						
															(doc."tableId",doc.idto) in(	
															(div."factura_a_clienteId",124),
															(div."factura_rectificativa_ventasId",249),
															(div."albarán-factura_clienteId",319),
															(div."ticket_ventaId",125))													inner join
							tipo_iva as iva			on iva."tableId"=div.iva															left join
							replica_ids as riva on 	riva.destinatario='$ENDPOINT$' and
													riva.clases='TIPO_IVA' and
													riva."id_ERP"=div.iva::text	and
													riva."descripción" like '%venta%' and
													riva.nombre not ilike '%Recargo%' 													left join
							replica_ids as riva_rec on 	riva_rec.destinatario='$ENDPOINT$' and
														riva_rec.clases='TIPO_IVA' and
														riva_rec."id_ERP"=div.iva::text	and
														riva_rec."descripción" like '%venta%' 	and
														riva_rec.nombre ilike '%Recargo%'												left join
														
							replica_ids as rdoc on 		rdoc.clases=']]><xsl:value-of select="name(.)" /><![CDATA[' and 
														doc."tableId"=rdoc."id_ERP"::int and
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 															inner join																											
							régimen_iva as regiva		on c."régimen_iva"=regiva."tableId"																inner join
													
							replica_ids as raccvmerc on raccvmerc.destinatario='$ENDPOINT$' and
														raccvmerc.clases='CUENTA_CONTABLE' and 
														((regiva.rdn ilike '%r%gim%gener%' or regiva.rdn ilike '%carg%Equ%') and raccvmerc.nombre='Ventas de mercaderías en España'	or 
														regiva.rdn ilike '%ntrac%' and raccvmerc.nombre='Ventas de mercaderías Intracomunitarias'	or
														regiva.rdn ilike '%export%' and raccvmerc.nombre='Ventas de mercaderías Exportación'
														)																									
														,																				
							"delegación" as endpoint
																
															   
							where 	(']]><xsl:value-of select="name(.)" /><![CDATA[',]]><xsl:value-of select="attribute::tableId" /><![CDATA[,doc.idto) in(
													('FACTURA_A_CLIENTE',doc."tableId",124),
													('FACTURA_RECTIFICATIVA_VENTAS',doc."tableId",249),
													('ALBARÁN-FACTURA_CLIENTE',doc."tableId",319),
													('TICKET_VENTA',doc."tableId",125)) and
									emp.rdn in(]]><xsl:value-of select="$empresaclp" /><![CDATA[) and doc.base is not null and
									(regiva.rdn ilike '%ntrac%' and regiva.rdn is null or regiva.rdn is not null) and
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						union					
						select distinct
							case 								
								when rvar.identificador_replicas is null then 'ERROR falta cargo '||gf.rdn
								when rdoc.rdn is null then 'new'
								when rdoc.rdn is not null and rlin.identificador_replicas is null and rvar.identificador_replicas is not null then 'newlin1' 																								
								when rdoc.campo_aux1='draft' then 'post'
								else 'NA'
								end as test,
								
							endpoint."página_web" as urldest,
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,
							
							
							rcli.identificador_replicas as idrcliente,
							NULL as teamid,
							
							rdoc.identificador_replicas as rpedid,
							
							doc."tableId" as doctid,
							case 	when (doc.idto in(124,319) or doc.base>0) and RIGHT(doc.rdn, 1) = '0' THEN SUBSTRING(doc.rdn FROM 1 FOR LENGTH(doc.rdn) - 1)
									ELSE doc.rdn end  as docrdn,
							rmon.identificador_replicas as idrmon,
							
							
							endpoint.rdn as endpointdest,	
							lin."tableId"::text as tidlin,
							rlin.identificador_replicas as rlinid,																				  																				

							case when doc.idto=249 or doc.base<0 then -1 else 1 end as cantidad,														
							round(lin.importe::numeric,2) as precio,								
							0.0 as descuento,
														
							
							riva.identificador_replicas as ridtax,
							case when regiva.rdn ~ '(?i)Recargo' then riva_rec.identificador_replicas else NULL end as ridtaxrec,
							rvar.identificador_replicas as rvarianteid,
							case when gf.rdn is null then 'CARGO' else gf.rdn end as sku,
							case when lin."descripción" is null then 'CARGO' else btrim(lin."descripción") end as prodescr,
							raccvmerc.identificador_replicas as account_venta_mercaderia,

							doc.rdn,
							
							null::int as siiregkey,
							case when doc.idto=249 or doc.base<0 then 'out_refund' else 'out_invoice' end as move_type,
							rregiva.identificador_replicas as posfiscal,
							'CARGO' as claselinea,
							2 as orderrow
							
						from 							
							v_factura as doc																							inner join
							"delegación" as del 	on doc."delegación"=del."tableId"													inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c 
								on(  																
									']]><xsl:value-of select="name(.)" /><![CDATA['='TICKET_VENTA' and c.rdn=del.rdn	or
									"cliente"=c."tableId" and "clienteIdto"=485
								  )																										inner join
									
															
							replica_ids as rempresa on 				rempresa.destinatario='$ENDPOINT$' and
																	rempresa.clases='MI_EMPRESA'	and
																	rempresa."id_ERP"::int=emp."tableId"								inner join 
							replica_ids as rcli on 					rcli.destinatario = '$ENDPOINT$' and
																	rcli.clases='CLIENTE_PARTICULAR' and
																	rcli."id_ERP"=c."tableId"::text	and
																	rcli.identificador_replicas ~'^\d+$'								inner join
																  
							"cargo" as lin on 		(doc.idto=124 and "factura_a_clienteId"=doc."tableId" or 
													 doc.idto=249 and "factura_rectificativa_ventasId"=doc."tableId" or 
													 doc.idto=319 and "albarán-factura_clienteId"=doc."tableId" or
													 doc.idto=125 and "ticket_ventaId"=doc."tableId")									left join
													 
							tipo_cargo as gf 		on gf."tableId"=lin.tipo_cargo	 													inner join 
							desglose_iva as div			on   							
															div.iva=lin.iva and 
															(doc."tableId",doc.idto) in(	
															(div."factura_a_clienteId",124),
															(div."factura_rectificativa_ventasId",249),
															(div."albarán-factura_clienteId",319),
															(div."ticket_ventaId",125))													inner join
							tipo_iva as iva			on iva."tableId"=div.iva															inner join		
							
							replica_ids as rp 		on  rp.destinatario='$ENDPOINT$' and 
														rp.clases='GÉNERO' and
														rp."id_ERP"='CARGO'																left join
							replica_ids as rvar on 		rvar.clases='VARIANTE' and rvar.destinatario='$ENDPOINT$' and
														rvar."id_ERP"='CARGO'															left join
							replica_ids as rlin on 		rlin.clases='CARGO' and 
														rlin.destinatario='$ENDPOINT$' and
														rlin."id_ERP"::int=lin."tableId"												left join
							replica_ids as riva on 	riva.destinatario='$ENDPOINT$' and
													riva.clases='TIPO_IVA' and
													riva."id_ERP"=lin.iva::text	and
													riva."descripción" like '%venta%' and
													riva.nombre not ilike '%Recargo%' 													left join
							replica_ids as riva_rec on 	riva_rec.destinatario='$ENDPOINT$' and
														riva_rec.clases='TIPO_IVA' and
														riva_rec."id_ERP"=lin.iva::text	and
														riva_rec."descripción" like '%venta%' 	and
														riva_rec.nombre ilike '%Recargo%'												left join
														
							replica_ids as rdoc on 		rdoc.clases=']]><xsl:value-of select="name(.)" /><![CDATA[' and 
														doc."tableId"=rdoc."id_ERP"::int and
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 															inner join																											
							régimen_iva as regiva		on c."régimen_iva"=regiva."tableId"																inner join
							replica_ids as rregiva	on 	rregiva.destinatario='$ENDPOINT$' and
														rregiva.clases='RÉGIMEN_IVA'	and
														rregiva."id_ERP"=regiva."tableId"::text 																inner join
													
							replica_ids as raccvmerc on raccvmerc.destinatario='$ENDPOINT$' and
														raccvmerc.clases='CUENTA_CONTABLE' and 
														((regiva.rdn ilike '%r%gim%gener%' or regiva.rdn ilike '%carg%Equ%') and raccvmerc.nombre='Ventas de mercaderías en España'	or 
														regiva.rdn ilike '%ntrac%' and raccvmerc.nombre='Ventas de mercaderías Intracomunitarias'	or
														regiva.rdn ilike '%export%' and raccvmerc.nombre='Ventas de mercaderías Exportación'
														)																													
														,																				
							"delegación" as endpoint
																
															   
							where 	(']]><xsl:value-of select="name(.)" /><![CDATA[',]]><xsl:value-of select="attribute::tableId" /><![CDATA[,doc.idto) in(
													('FACTURA_A_CLIENTE',doc."tableId",124),
													('FACTURA_RECTIFICATIVA_VENTAS',doc."tableId",249),
													('ALBARÁN-FACTURA_CLIENTE',doc."tableId",319),
													('TICKET_VENTA',doc."tableId",125)) and
									emp.rdn in (]]><xsl:value-of select="$empresaclp" /><![CDATA[) and doc.base is not null and
									(regiva.rdn ilike '%ntrac%' and regiva.rdn is null or regiva.rdn is not null) and
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						union
						select distinct
							case 					
								
								when rdoc.rdn is null then 'new'
								when rdoc.rdn is not null and rlin.identificador_replicas is null and rvar.identificador_replicas is not null then 'newlin1' 																								
								when rdoc.campo_aux1='draft' then 'post'
								else 'NA'
								end as test,
								
							endpoint."página_web" as urldest,
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,
														
							rcli.identificador_replicas as idrcliente,
							case when rteam.identificador_replicas is null then ']]><xsl:value-of select="$defteam" /><![CDATA[' else rteam.identificador_replicas end  as teamid,
													
							rdoc.identificador_replicas as rpedid,					
							
							doc."tableId" as doctid,
							case 	when (doc.idto in(124,319) or doc.base>0) and RIGHT(doc.rdn, 1) = '0' THEN SUBSTRING(doc.rdn FROM 1 FOR LENGTH(doc.rdn) - 1)
									ELSE doc.rdn end  as docrdn,
							rmon.identificador_replicas as idrmon,							
							
							endpoint.rdn as endpointdest,	
							lin."tableId"::text as tidlin,
							rlin.identificador_replicas as rlinid,

							case when doc.idto=249 or doc.base<0 then -lin.cantidad else lin.cantidad end as cantidad,														
														
							round(lin.precio::numeric,(case when doc.idto=125 then 4 else 2 end)) as precio,		
							
							case when lin.descuento is null then 0.0 else lin.descuento end as descuento,
																					
							riva.identificador_replicas as ridtax,
							case when regiva.rdn ~ '(?i)Recargo' then riva_rec.identificador_replicas else NULL end as ridtaxrec,
							
							case when rvar.identificador_replicas is null then ']]><xsl:value-of select="$otroproduct" /><![CDATA[' else rvar.identificador_replicas end as rvarianteid,
							gf.rdn as sku,
							btrim(gf."descripción")||(case when lin.concepto is not null then ' '||lin.concepto else '' end) as prodescr,
							raccvmerc.identificador_replicas as account_venta_mercaderia,
							
							doc.rdn,
							
							case when racciva.nombre is not null and racciva.nombre ilike 'Ventas de mercaderías Exportación%' then 2 else 1 end as siiregkey,
							case when doc.idto=249 or doc.base<0 then 'out_refund' else 'out_invoice' end as move_type,
							rregiva.identificador_replicas as posfiscal,
							clslin.rdn as claselinea,
							1 as orderrow
								 
							
						from 							
							"v_factura" as doc																					inner join
							"delegación" as del 	on doc."delegación"=del."tableId"													inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
															
							replica_ids as rempresa on 				rempresa.destinatario='$ENDPOINT$' and
																	rempresa.clases='MI_EMPRESA'	and
																	rempresa."id_ERP"::int=emp."tableId"								inner join
							"v_cliente" as c 
								on(  			
									']]><xsl:value-of select="name(.)" /><![CDATA['='TICKET_VENTA' and c.rdn=del.rdn	or
									"cliente"=c."tableId" and "clienteIdto"=485
								  )																										inner join 
																	
							replica_ids as rcli on 					rcli.destinatario = '$ENDPOINT$' and
																	rcli.clases='CLIENTE_PARTICULAR' and
																	rcli."id_ERP"=c."tableId"::text	and
																	rcli.identificador_replicas ~'^\d+$'								left join
							
							replica_ids as rteam on 				rteam.destinatario = '$ENDPOINT$' and
																	rteam.clases='SALETEAM' and
																	doc.idto=125 and rteam.nombre=del.rdn								inner join
																	
							"v_factura#línea_artículos" as vfl on "facturaId"=doc."tableId" and
																  "facturaIdto"=doc.idto												inner join
																  
							clase as clslin					on clslin.id= vfl."línea_artículosIdto"										INNER JOIN
																  
							"v_línea_artículos" as lin on 	vfl."línea_artículosId"=lin."tableId" and
															clslin.id=lin.idto															inner join
															
							"v_artículo" as gf 		on gf."tableId"=producto and gf.idto="productoIdto"									inner join
							clase as clsart			on clsart.id=gf.idto																inner join
							tipo_iva as iva			on iva."tableId"=lin.iva															left join		
							
							replica_ids as rp 		on  rp.destinatario='$ENDPOINT$' and 
														rp.clases=clsart.rdn and
														rp."id_ERP"=(case when clsart.rdn='GÉNERO'   then substring(gf.rdn,1,5) 
																		  else gf."tableId"::text end)											left join
							replica_ids as rvar on 		rvar.clases=(case when clsart.rdn='GÉNERO'   then 'VARIANTE' 
																		  when clsart.rdn='SERVICIO' then 'VARIANTESERV'
																		  else '-' end) and rvar.destinatario='$ENDPOINT$' and
														rvar."id_ERP"=(case when clsart.rdn='GÉNERO'   then gf.rdn 
																		    else gf."tableId"::text end)										left join
							replica_ids as rlin on 		rlin.clases=clslin.rdn and 
														rlin.destinatario='$ENDPOINT$' and
														rlin."id_ERP"::int=lin."tableId"														left join
							replica_ids as riva on 	riva.destinatario='$ENDPOINT$' and
													riva.clases='TIPO_IVA' and
													riva."id_ERP"=lin.iva::text	and													
													riva."descripción" like '%venta%' and
													riva.nombre not ilike '%Recargo%' 													left join
							replica_ids as riva_rec on 	riva_rec.destinatario='$ENDPOINT$' and
														riva_rec.clases='TIPO_IVA' and
														riva_rec."id_ERP"=lin.iva::text	and
														riva_rec."descripción" like '%venta%' 	and
														riva_rec.nombre ilike '%Recargo%'												left join
														
							replica_ids as rdoc on 		rdoc.clases=']]><xsl:value-of select="name(.)" /><![CDATA[' and 
														doc."tableId"=rdoc."id_ERP"::int and
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 																					inner join																											
							régimen_iva as regiva		on c."régimen_iva"=regiva."tableId"																inner join
							replica_ids as rregiva	on 	rregiva.destinatario='$ENDPOINT$' and
														rregiva.clases='RÉGIMEN_IVA'	and
														rregiva."id_ERP"=regiva."tableId"::text 																inner join
													
							replica_ids as raccvmerc on raccvmerc.destinatario='$ENDPOINT$' and
														raccvmerc.clases='CUENTA_CONTABLE' and 
														((regiva.rdn ilike '%r%gim%gener%' or regiva.rdn ilike '%carg%Equ%') and raccvmerc.nombre='Ventas de mercaderías en España'	or 
														regiva.rdn ilike '%ntrac%' and raccvmerc.nombre='Ventas de mercaderías Intracomunitarias'	or
														regiva.rdn ilike '%export%' and raccvmerc.nombre='Ventas de mercaderías Exportación'
														)																								left join
							replica_ids as racciva on 	racciva.destinatario='$ENDPOINT$' and
														racciva.clases='CUENTA_CONTABLE'  and 
														(regiva.rdn ilike '%r%gim%gener%' and racciva.nombre ilike 'Hacienda Pública. IVA repercutido%' or
														regiva.rdn ilike '%export%'       and racciva.nombre ilike 'Ventas de mercaderías Exportación%' or
														regiva.rdn ilike '%carg%Equ%'	  and racciva.nombre ilike 'Hacienda Pública. IVA repercutido%' 
														)
														,																				
							"delegación" as endpoint
																
															   
							where 	(']]><xsl:value-of select="name(.)" /><![CDATA[',]]><xsl:value-of select="attribute::tableId" /><![CDATA[,doc.idto) in(
													('FACTURA_A_CLIENTE',doc."tableId",124),
													('FACTURA_RECTIFICATIVA_VENTAS',doc."tableId",249),
													('ALBARÁN-FACTURA_CLIENTE',doc."tableId",319),
													('TICKET_VENTA',doc."tableId",125)) and
									emp.rdn in(]]><xsl:value-of select="$empresaclp" /><![CDATA[) and doc.base is not null and
									(regiva.rdn ilike '%ntrac%' and regiva.rdn is null or regiva.rdn is not null) and
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						order by urldest,fecha ,doctid desc, orderrow													
					]]>
							
					<atom test="new" http="POST" new_field_response="$rpedid">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="order">{$docrdn}#1</xsl:attribute>	
						<xsl:attribute name="groupby">{$docrdn}</xsl:attribute>	
						<xsl:attribute name="slug">{$docrdn}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						<xsl:attribute name="new_field_aux1">draft</xsl:attribute>
																																		
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.move</par>	
							<par>create</par>
							<list>							
								<dict>
									<move_type>{$move_type}</move_type>
									<currency_id><xsl:value-of select="$euros" /></currency_id>
									<journal_id><xsl:value-of select="$diarioventas" /></journal_id>
									<date>{$fecha}</date>
									<invoice_date>{$fecha}</invoice_date>
									<state>draft</state>
																				
									<name>text:{$docrdn}</name>												
									<company_id>{$ridempresa}</company_id>
									
									<partner_id>{$idrcliente}</partner_id>
									<team_id>{$teamid}</team_id>
									
									<sii_registration_key>{$siiregkey}</sii_registration_key>
									<!--<fiscal_position_id>{$posfiscal}</fiscal_position_id>	lo dejo vacio para que aplique la del client que es revisada-->
								</dict>	
							</list>
						</list>
					</atom>		
										
					<!--apunte producto-->
					<atom test="new" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn']"/>
						<xsl:attribute name="order">{$docrdn}#2</xsl:attribute>	
						<xsl:attribute name="groupby">{$docrdn}.{$sku}</xsl:attribute>	
						<xsl:attribute name="tableId">{$tidlin}</xsl:attribute>		
						<xsl:attribute name="slug">{$sku}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class">{$claselinea}</xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>																																								
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<xsl:attribute name="new_field_aux1">1-venta-merc</xsl:attribute>
						<xsl:attribute name="rdnreplicas">{$endpointdest}#{$claselinea}#{$tidlin}</xsl:attribute>
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.move.line</par>								
							<par>create</par>
							<list>		
								<dict>
									<move_id>{$rpedid}</move_id>										
									<quantity>{$cantidad}</quantity>																											
									<price_unit>{$precio}</price_unit>
									<discount>{$descuento}</discount>
									<product_id>{$rvarianteid}</product_id>									
									<account_id>{$account_venta_mercaderia}</account_id>																		
									<name>{$sku}-{$prodescr}</name>	
									<currency_id><xsl:value-of select="$euros" /></currency_id>
									<!-- no necesario
										<product_uom_id>1</product_uom_id>		
										<partner_id>{$idrcliente}</partner_id>
										<journal_id><xsl:value-of select="$diarioventas" /></journal_id>	
										<price_subtotal>{$base_linea}</price_subtotal>
										<price_total>{$total_linea}</price_total>
										<amount_currency>{$total_linea}</amount_currency>
										-->
									<!--V16-->
										<blocked>true</blocked>											
									<tax_ids>
										<list>											
											<par>{$ridtax}</par>											
											<par>{$ridtaxrec}</par>
										</list>
									</tax_ids>								
								</dict>	
							</list>							
						</list>
					</atom>													
					
					<atom test="new" http="POST" >
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="order">{$docrdn}#6</xsl:attribute>	
						<xsl:attribute name="groupby">{$docrdn}POST</xsl:attribute>	
						<xsl:attribute name="slug"><xsl:value-of select="attribute::rdn" /></xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						<xsl:attribute name="new_field_aux1">posted</xsl:attribute>
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.move</par>	
							<par>write</par>
							<list>				
								<list>
									<par>{$rpedid}</par>
								</list>							
								<dict>							
									<state>posted</state>
								</dict>	
							</list>
						</list>
					</atom>	
				</clone>
			</xsl:when>				
			
			<!--<xsl:when test="self::FACTURA_A_CLIENTE or self::FACTURA_RECTIFICATIVA_VENTAS or self::TICKET_VENTA or self::ALBARÁN-FACTURA_CLIENTE">				-->
			<xsl:when test="self::TICKET_VENTA">				
				<clone>
					<![CDATA[
						select distinct
							case 								
								
								when rdoc.rdn is null then 'new'																																
								when rdoc.campo_aux1='draft' then 'post'
								else 'NA'
								end as test,
								

							endpoint."página_web" as urldest,							
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,							
							
							rcli.identificador_replicas as idrcliente,
							NULL as teamid,
							
							rdoc.identificador_replicas as rpedid,
					
							
							doc."tableId" as doctid,
							case 	when (doc.idto in(124,319) or doc.base>0) and RIGHT(doc.rdn, 1) = '0' THEN SUBSTRING(doc.rdn FROM 1 FOR LENGTH(doc.rdn) - 1)
									ELSE doc.rdn end  as docrdn,
							rmon.identificador_replicas as idrmon,
							
							
							endpoint.rdn as endpointdest,	
							lin."tableId"::text as tidlin,
							null as rlinid,																				  																				

							-(case when doc.idto=249 or doc.base<0 then -1 else 1 end) as cantidad,														
							
							round(lin.importe::numeric,2) as precio,								
	
							0.0 as descuento,
							riva.identificador_replicas as ridtax,
							case when regiva.rdn ~ '(?i)Recargo' then riva_rec.identificador_replicas else NULL end as ridtaxrec,
							']]><xsl:value-of select="$discountproduct" /><![CDATA[' as rvarianteid,
							'DESCUENTO'  as sku,
							'DESCUENTO '||lin.porcentaje::text as prodescr,

							raccvmerc.identificador_replicas as account_venta_mercaderia,
							
							doc.rdn,
							
							0 as siiregkey,
							null as move_type,
							'0' as posfiscal,
							'DESCUENTO' as claselinea,
							3 as orderrow
						from 							
							v_factura as doc																							inner join
							descuento_global as lin on (doc."tableId",doc.idto) in(	
															(lin."factura_a_clienteId",124),
															(lin."factura_rectificativa_ventasId",249),
															(lin."albarán-factura_clienteId",319),
															(lin."ticket_ventaId",125))													inner join
							"delegación" as del 	on doc."delegación"=del."tableId"													inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c 
								on(  																
									']]><xsl:value-of select="name(.)" /><![CDATA['='TICKET_VENTA' and c.rdn=del.rdn	or
									"cliente"=c."tableId" and "clienteIdto"=485
								  )																										inner join
									
															
							replica_ids as rempresa on 				rempresa.destinatario='$ENDPOINT$' and
																	rempresa.clases='MI_EMPRESA'	and
																	rempresa."id_ERP"::int=emp."tableId"								inner join 
							replica_ids as rcli on 					rcli.destinatario = '$ENDPOINT$' and
																	rcli.clases='CLIENTE_PARTICULAR' and
																	rcli."id_ERP"=c."tableId"::text	and
																	rcli.identificador_replicas ~'^\d+$'								inner join 
							desglose_iva as div			on   																						
															(doc."tableId",doc.idto) in(	
															(div."factura_a_clienteId",124),
															(div."factura_rectificativa_ventasId",249),
															(div."albarán-factura_clienteId",319),
															(div."ticket_ventaId",125))													inner join
							tipo_iva as iva			on iva."tableId"=div.iva															left join
							replica_ids as riva on 	riva.destinatario='$ENDPOINT$' and
													riva.clases='TIPO_IVA' and
													riva."id_ERP"=div.iva::text	and
													riva.campo_aux1=emp.rdn and
													riva."descripción" like '%venta%' and
													riva.nombre not ilike '%Recargo%' 													left join
							replica_ids as riva_rec on 	riva_rec.destinatario='$ENDPOINT$' and
														riva_rec.clases='TIPO_IVA' and
														riva_rec."id_ERP"=div.iva::text	and
														riva_rec.campo_aux1=emp.rdn and
														riva_rec."descripción" like '%venta%' 	and
														riva_rec.nombre ilike '%Recargo%'												left join
														
							replica_ids as rdoc on 		rdoc.clases=']]><xsl:value-of select="name(.)" /><![CDATA[' and 
														doc."tableId"=rdoc."id_ERP"::int and
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 															inner join																											
							régimen_iva as regiva		on c."régimen_iva"=regiva."tableId"																inner join
													
							replica_ids as raccvmerc on raccvmerc.destinatario='$ENDPOINT$' and
														raccvmerc.clases='CUENTA_CONTABLE' and 
														((regiva.rdn ilike '%r%gim%gener%' or regiva.rdn ilike '%carg%Equ%') and raccvmerc.nombre='Ventas de mercaderías en España'	or 
														regiva.rdn ilike '%ntrac%' and raccvmerc.nombre='Ventas de mercaderías Intracomunitarias'	or
														regiva.rdn ilike '%export%' and raccvmerc.nombre='Ventas de mercaderías Exportación'
														)																									
														,																				
							"delegación" as endpoint
																
															   
							where 	(']]><xsl:value-of select="name(.)" /><![CDATA[',]]><xsl:value-of select="attribute::tableId" /><![CDATA[,doc.idto) in(
													('FACTURA_A_CLIENTE',doc."tableId",124),
													('FACTURA_RECTIFICATIVA_VENTAS',doc."tableId",249),
													('ALBARÁN-FACTURA_CLIENTE',doc."tableId",319),
													('TICKET_VENTA',doc."tableId",125)) and
									emp.rdn in (]]><xsl:value-of select="$empresaclp" /><![CDATA[) and doc.base is not null and
									(regiva.rdn ilike '%ntrac%' and regiva.rdn is null or regiva.rdn is not null) and
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						union					
						select distinct
							case 								
								when rvar.identificador_replicas is null then 'ERROR falta cargo '||gf.rdn
								when rdoc.rdn is null then 'new'
								when rdoc.rdn is not null and rlin.identificador_replicas is null and rvar.identificador_replicas is not null then 'newlin1' 																								
								when rdoc.campo_aux1='draft' then 'post'
								else 'NA'
								end as test,
								
							endpoint."página_web" as urldest,
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,
							
							
							rcli.identificador_replicas as idrcliente,
							NULL as teamid,
							
							rdoc.identificador_replicas as rpedid,
							
							doc."tableId" as doctid,
							case 	when (doc.idto in(124,319) or doc.base>0) and RIGHT(doc.rdn, 1) = '0' THEN SUBSTRING(doc.rdn FROM 1 FOR LENGTH(doc.rdn) - 1)
									ELSE doc.rdn end  as docrdn,
							rmon.identificador_replicas as idrmon,
							
							
							endpoint.rdn as endpointdest,	
							lin."tableId"::text as tidlin,
							rlin.identificador_replicas as rlinid,																				  																				

							case when doc.idto=249 or doc.base<0 then -1 else 1 end as cantidad,														
							round(lin.importe::numeric,2) as precio,								
							0.0 as descuento,
														
							
							riva.identificador_replicas as ridtax,
							case when regiva.rdn ~ '(?i)Recargo' then riva_rec.identificador_replicas else NULL end as ridtaxrec,
							rvar.identificador_replicas as rvarianteid,
							case when gf.rdn is null then 'CARGO' else gf.rdn end as sku,
							case when lin."descripción" is null then 'CARGO' else btrim(lin."descripción") end as prodescr,
							raccvmerc.identificador_replicas as account_venta_mercaderia,

							doc.rdn,
							
							null::int as siiregkey,
							case when doc.idto=249 or doc.base<0 then 'out_refund' else 'out_invoice' end as move_type,
							rregiva.identificador_replicas as posfiscal,
							'CARGO' as claselinea,
							2 as orderrow
							
						from 							
							v_factura as doc																							inner join
							"delegación" as del 	on doc."delegación"=del."tableId"													inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c 
								on(  																
									']]><xsl:value-of select="name(.)" /><![CDATA['='TICKET_VENTA' and c.rdn=del.rdn	or
									"cliente"=c."tableId" and "clienteIdto"=485
								  )																										inner join
									
															
							replica_ids as rempresa on 				rempresa.destinatario='$ENDPOINT$' and
																	rempresa.clases='MI_EMPRESA'	and
																	rempresa."id_ERP"::int=emp."tableId"								inner join 
							replica_ids as rcli on 					rcli.destinatario = '$ENDPOINT$' and
																	rcli.clases='CLIENTE_PARTICULAR' and
																	rcli."id_ERP"=c."tableId"::text	and
																	rcli.identificador_replicas ~'^\d+$'								inner join
																  
							"cargo" as lin on 		(doc.idto=124 and "factura_a_clienteId"=doc."tableId" or 
													 doc.idto=249 and "factura_rectificativa_ventasId"=doc."tableId" or 
													 doc.idto=319 and "albarán-factura_clienteId"=doc."tableId" or
													 doc.idto=125 and "ticket_ventaId"=doc."tableId")									left join
													 
							tipo_cargo as gf 		on gf."tableId"=lin.tipo_cargo	 													inner join 
							desglose_iva as div			on   							
															div.iva=lin.iva and 
															(doc."tableId",doc.idto) in(	
															(div."factura_a_clienteId",124),
															(div."factura_rectificativa_ventasId",249),
															(div."albarán-factura_clienteId",319),
															(div."ticket_ventaId",125))													inner join
							tipo_iva as iva			on iva."tableId"=div.iva															inner join		
							
							replica_ids as rp 		on  rp.destinatario='$ENDPOINT$' and 
														rp.clases='GÉNERO' and
														rp."id_ERP"='CARGO'																left join
							replica_ids as rvar on 		rvar.clases='VARIANTE' and rvar.destinatario='$ENDPOINT$' and
														rvar."id_ERP"='CARGO'															left join
							replica_ids as rlin on 		rlin.clases='CARGO' and 
														rlin.destinatario='$ENDPOINT$' and
														rlin."id_ERP"::int=lin."tableId"												left join
							replica_ids as riva on 	riva.destinatario='$ENDPOINT$' and
													riva.clases='TIPO_IVA' and
													riva."id_ERP"=lin.iva::text	and
													riva."descripción" like '%venta%' and
													riva.nombre not ilike '%Recargo%' 													left join
							replica_ids as riva_rec on 	riva_rec.destinatario='$ENDPOINT$' and
														riva_rec.clases='TIPO_IVA' and
														riva_rec."id_ERP"=lin.iva::text	and
														riva_rec."descripción" like '%venta%' 	and
														riva_rec.nombre ilike '%Recargo%'												left join
														
							replica_ids as rdoc on 		rdoc.clases=']]><xsl:value-of select="name(.)" /><![CDATA[' and 
														doc."tableId"=rdoc."id_ERP"::int and
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 															inner join																											
							régimen_iva as regiva		on c."régimen_iva"=regiva."tableId"																inner join
							replica_ids as rregiva	on 	rregiva.destinatario='$ENDPOINT$' and
														rregiva.clases='RÉGIMEN_IVA'	and
														rregiva."id_ERP"=regiva."tableId"::text 																inner join
													
							replica_ids as raccvmerc on raccvmerc.destinatario='$ENDPOINT$' and
														raccvmerc.clases='CUENTA_CONTABLE' and 
														((regiva.rdn ilike '%r%gim%gener%' or regiva.rdn ilike '%carg%Equ%') and raccvmerc.nombre='Ventas de mercaderías en España'	or 
														regiva.rdn ilike '%ntrac%' and raccvmerc.nombre='Ventas de mercaderías Intracomunitarias'	or
														regiva.rdn ilike '%export%' and raccvmerc.nombre='Ventas de mercaderías Exportación'
														)																													
														,																				
							"delegación" as endpoint
																
															   
							where 	(']]><xsl:value-of select="name(.)" /><![CDATA[',]]><xsl:value-of select="attribute::tableId" /><![CDATA[,doc.idto) in(
													('FACTURA_A_CLIENTE',doc."tableId",124),
													('FACTURA_RECTIFICATIVA_VENTAS',doc."tableId",249),
													('ALBARÁN-FACTURA_CLIENTE',doc."tableId",319),
													('TICKET_VENTA',doc."tableId",125)) and
									emp.rdn in (]]><xsl:value-of select="$empresaclp" /><![CDATA[) and doc.base is not null and
									(regiva.rdn ilike '%ntrac%' and regiva.rdn is null or regiva.rdn is not null) and
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						union
						select distinct
							case 																
								when rdoc.rdn is null then 'new'
								when rdoc.rdn is not null and rlin.identificador_replicas is null and rvar.identificador_replicas is not null then 'newlin1' 																								
								when rdoc.campo_aux1='draft' then 'post'
								else 'NA'
								end as test,
								
							endpoint."página_web" as urldest,
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,
														
							rcli.identificador_replicas as idrcliente,
							case when rteam.identificador_replicas is null then ']]><xsl:value-of select="$defteam" /><![CDATA[' else rteam.identificador_replicas end  as teamid,
													
							rdoc.identificador_replicas as rpedid,					
							
							doc."tableId" as doctid,
							case 	when (doc.idto in(124,319) or doc.base>0) and RIGHT(doc.rdn, 1) = '0' THEN SUBSTRING(doc.rdn FROM 1 FOR LENGTH(doc.rdn) - 1)
									ELSE doc.rdn end  as docrdn,
							rmon.identificador_replicas as idrmon,							
							
							endpoint.rdn as endpointdest,	
							lin."tableId"::text as tidlin,
							rlin.identificador_replicas as rlinid,

							case when doc.idto=249 or doc.base<0 then -lin.cantidad else lin.cantidad end as cantidad,														
														
							round(lin.precio::numeric,(case when doc.idto=125 then 4 else 2 end)) as precio,		
							
							case when lin.descuento is null then 0.0 else lin.descuento end as descuento,
																					
							riva.identificador_replicas as ridtax,
							case when regiva.rdn ~ '(?i)Recargo' then riva_rec.identificador_replicas else NULL end as ridtaxrec,
							
							case when rvar.identificador_replicas is null then ']]><xsl:value-of select="$otroproduct" /><![CDATA[' else rvar.identificador_replicas end as rvarianteid,
							gf.rdn as sku,
							btrim(gf."descripción")||(case when lin.concepto is not null then ' '||lin.concepto else '' end) as prodescr,
							raccvmerc.identificador_replicas as account_venta_mercaderia,
							
							doc.rdn,
							
							case when racciva.nombre is not null and racciva.nombre ilike 'Ventas de mercaderías Exportación%' then 2 else 1 end as siiregkey,
							case when doc.idto=249 or doc.base<0 then 'out_refund' else 'out_invoice' end as move_type,
							rregiva.identificador_replicas as posfiscal,
							claselin.rdn as claselinea,
							1 as orderrow
								 
							
						from 							
							v_factura as doc																							inner join
							"delegación" as del 	on doc."delegación"=del."tableId"													inner join
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c 
								on(  			
									']]><xsl:value-of select="name(.)" /><![CDATA['='TICKET_VENTA' and c.rdn=del.rdn	or
									"cliente"=c."tableId" and "clienteIdto"=485
								  )																										inner join
									
															
							replica_ids as rempresa on 				rempresa.destinatario='$ENDPOINT$' and
																	rempresa.clases='MI_EMPRESA'	and
																	rempresa."id_ERP"::int=emp."tableId"								inner join 
																	
							replica_ids as rcli on 					rcli.destinatario = '$ENDPOINT$' and
																	rcli.clases='CLIENTE_PARTICULAR' and
																	rcli."id_ERP"=c."tableId"::text	and
																	rcli.identificador_replicas ~'^\d+$'								left join
							
							replica_ids as rteam on 				rteam.destinatario = '$ENDPOINT$' and
																	rteam.clases='SALETEAM' and
																	doc.idto=125 and rteam.nombre=del.rdn								inner join
																	
							"v_factura#línea_artículos" as vfl on "facturaId"=doc."tableId" and
																  "facturaIdto"=doc.idto												inner join
																  
							"v_línea_artículos" as lin on 	vfl."línea_artículosId"=lin."tableId" and
															vfl."línea_artículosIdto"=lin.idto											inner join
							clase as claselin 			on claselin.id=lin.idto 														inner join
							
							"v_artículo" as gf 			on gf.idto="productoIdto" and gf."tableId"=producto 							inner join
							clase as clsart				on clsart.id=gf.idto															inner join 
							desglose_iva as div			on   
															div.iva=lin.iva and 
															(doc."tableId",doc.idto) in(	
															(div."factura_a_clienteId",124),
															(div."factura_rectificativa_ventasId",249),
															(div."albarán-factura_clienteId",319),
															(div."ticket_ventaId",125))													inner join
							tipo_iva as iva			on iva."tableId"=div.iva															left join		
							
							replica_ids as rp 		on  rp.destinatario='$ENDPOINT$' and 
														rp.clases='GÉNERO' and
														rp."id_ERP"=(case when clsart.rdn='GÉNERO'   then substring(gf.rdn,1,5) 
																		  else gf."tableId"::text end)													left join
							replica_ids as rvar on 		rvar.clases=(case when clsart.rdn='GÉNERO'   then 'VARIANTE' 
																		  when clsart.rdn='SERVICIO' then 'VARIANTESERV'
																		  else '-' end) and rvar.destinatario='$ENDPOINT$' and
														rvar."id_ERP"=(case when clsart.rdn='GÉNERO' then gf.rdn else gf."tableId"::text end)	left join
							replica_ids as rlin on 		rlin.clases=claselin and 
														rlin.destinatario='$ENDPOINT$' and
														rlin."id_ERP"::int=lin."tableId"														left join
							replica_ids as riva on 	riva.destinatario='$ENDPOINT$' and
													riva.clases='TIPO_IVA' and
													riva."id_ERP"=lin.iva::text	and
													riva.campo_aux1=emp.rdn and
													riva."descripción" like '%venta%' and
													riva.nombre not ilike '%Recargo%' 													left join
							replica_ids as riva_rec on 	riva_rec.destinatario='$ENDPOINT$' and
														riva_rec.clases='TIPO_IVA' and
														riva_rec."id_ERP"=lin.iva::text	and
														riva_rec.campo_aux1=emp.rdn and
														riva_rec."descripción" like '%venta%' 	and
														riva_rec.nombre ilike '%Recargo%'												left join
														
							replica_ids as rdoc on 		rdoc.clases=']]><xsl:value-of select="name(.)" /><![CDATA[' and 
														doc."tableId"=rdoc."id_ERP"::int and
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 																					inner join																											
							régimen_iva as regiva		on c."régimen_iva"=regiva."tableId"																inner join
							replica_ids as rregiva	on 	rregiva.destinatario='$ENDPOINT$' and
														rregiva.clases='RÉGIMEN_IVA'	and
														rregiva."id_ERP"=regiva."tableId"::text 																inner join
													
							replica_ids as raccvmerc on raccvmerc.destinatario='$ENDPOINT$' and
														raccvmerc.clases='CUENTA_CONTABLE' and 
														((regiva.rdn ilike '%r%gim%gener%' or regiva.rdn ilike '%carg%Equ%') and raccvmerc.nombre='Ventas de mercaderías en España'	or 
														regiva.rdn ilike '%ntrac%' and raccvmerc.nombre='Ventas de mercaderías Intracomunitarias'	or
														regiva.rdn ilike '%export%' and raccvmerc.nombre='Ventas de mercaderías Exportación'
														)																								left join
							replica_ids as racciva on 	racciva.destinatario='$ENDPOINT$' and
														racciva.clases='CUENTA_CONTABLE'  and 
														(regiva.rdn ilike '%r%gim%gener%' and racciva.nombre ilike 'Hacienda Pública. IVA repercutido%' or
														regiva.rdn ilike '%export%'       and racciva.nombre ilike 'Ventas de mercaderías Exportación%' or
														regiva.rdn ilike '%carg%Equ%'	  and racciva.nombre ilike 'Hacienda Pública. IVA repercutido%' 
														)
														,																				
							"delegación" as endpoint
																
															   
							where 	(']]><xsl:value-of select="name(.)" /><![CDATA[',]]><xsl:value-of select="attribute::tableId" /><![CDATA[,doc.idto) in(
													('FACTURA_A_CLIENTE',doc."tableId",124),
													('FACTURA_RECTIFICATIVA_VENTAS',doc."tableId",249),
													('ALBARÁN-FACTURA_CLIENTE',doc."tableId",319),
													('TICKET_VENTA',doc."tableId",125)) and
									emp.rdn in (]]><xsl:value-of select="$empresaclp" /><![CDATA[) and doc.base is not null and
									(regiva.rdn ilike '%ntrac%' and regiva.rdn is null or regiva.rdn is not null) and
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						order by urldest,fecha ,doctid desc, orderrow													
					]]>
							
					<atom test="new" http="POST" new_field_response="$rpedid">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="order">{$docrdn}#1</xsl:attribute>	
						<xsl:attribute name="groupby">{$docrdn}</xsl:attribute>	
						<xsl:attribute name="slug">{$docrdn}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						<xsl:attribute name="new_field_aux1">draft</xsl:attribute>
																																		
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.move</par>	
							<par>create</par>
							<list>							
								<dict>
									<move_type>{$move_type}</move_type>
									<currency_id><xsl:value-of select="$euros" /></currency_id>
									<journal_id><xsl:value-of select="$diarioventas" /></journal_id>
									<date>{$fecha}</date>
									<invoice_date>{$fecha}</invoice_date>
									<state>draft</state>
																				
									<name>text:{$docrdn}</name>												
									<company_id>{$ridempresa}</company_id>
									
									<partner_id>{$idrcliente}</partner_id>
									<team_id>{$teamid}</team_id>
									
									<sii_registration_key>{$siiregkey}</sii_registration_key>
									<!--<fiscal_position_id>{$posfiscal}</fiscal_position_id>	lo dejo vacio para que aplique la del client que es revisada-->
								</dict>	
							</list>
						</list>
					</atom>		
										
					<!--apunte producto-->
					<atom test="new" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn']"/>
						<xsl:attribute name="order">{$docrdn}#2</xsl:attribute>	
						<xsl:attribute name="groupby">{$docrdn}.{$sku}</xsl:attribute>	
						<xsl:attribute name="tableId">{$tidlin}</xsl:attribute>		
						<xsl:attribute name="slug">{$sku}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class">{$claselinea}</xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>																																								
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<xsl:attribute name="new_field_aux1">1-venta-merc</xsl:attribute>
						<xsl:attribute name="rdnreplicas">{$endpointdest}#{$claselinea}#{$tidlin}</xsl:attribute>
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.move.line</par>								
							<par>create</par>
							<list>		
								<dict>
									<move_id>{$rpedid}</move_id>										
									<quantity>{$cantidad}</quantity>																											
									<price_unit>{$precio}</price_unit>
									<discount>{$descuento}</discount>
									<product_id>{$rvarianteid}</product_id>									
									<account_id>{$account_venta_mercaderia}</account_id>																		
									<name>{$sku}-{$prodescr}</name>	
									<currency_id><xsl:value-of select="$euros" /></currency_id>
									<!-- no necesario
										<product_uom_id>1</product_uom_id>		
										<partner_id>{$idrcliente}</partner_id>
										<journal_id><xsl:value-of select="$diarioventas" /></journal_id>	
										<price_subtotal>{$base_linea}</price_subtotal>
										<price_total>{$total_linea}</price_total>
										<amount_currency>{$total_linea}</amount_currency>
										-->
									<!--V16-->
										<blocked>true</blocked>											
									<tax_ids>
										<list>											
											<par>{$ridtax}</par>											
											<par>{$ridtaxrec}</par>
										</list>
									</tax_ids>								
								</dict>	
							</list>							
						</list>
					</atom>													
					
					<atom test="new" http="POST" >
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="order">{$docrdn}#6</xsl:attribute>	
						<xsl:attribute name="groupby">{$docrdn}POST</xsl:attribute>	
						<xsl:attribute name="slug"><xsl:value-of select="attribute::rdn" /></xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						<xsl:attribute name="new_field_aux1">posted</xsl:attribute>
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.move</par>	
							<par>write</par>
							<list>				
								<list>
									<par>{$rpedid}</par>
								</list>							
								<dict>							
									<state>posted</state>
								</dict>	
							</list>
						</list>
					</atom>	
				</clone>
			</xsl:when>				
			<xsl:when test="self::COBRO_VENCIMIENTO">				
				<clone>
					<![CDATA[
						select distinct
							case 																
								when rpay.rdn is null then 'new'								
								else 'new2'
								end as test,								
							
							endpoint."página_web" as urldest,							
							
							rempresa.identificador_replicas as ridempresa,
							to_timestamp(doc.fecha)::timestamp as fecha,							
							
							rcli.identificador_replicas as idrcliente,
													
							rdoc.identificador_replicas as rdocid,																								
							doc.rdn as docrdn,
							rmon.identificador_replicas as idrmon,							
							
							endpoint.rdn as endpointdest,																					
									
							pay.rdn as payrdn,
							importe_asignado as importe,
							asig.rdn as asigrdn,
							
							case when doc.idto in(124,125) then 'out_invoice' else 'out_refund' end as move_type,
							rapcli.identificador_replicas as rapcliid,
							rpaylin.identificador_replicas as rappayid,
							racccli.identificador_replicas	as destin_acc_id,
							rpay.identificador_replicas as rpayid
																				
						from 							
							cobro_vencimiento as pay																											inner join
							"asignación_vencimiento_cobro" as asig	on "cobro_vencimientoId"=pay."tableId"														inner join
							vencimiento_de_cobro as venc on venc."tableId"="vencimiento_de_cobroId"																inner join
							v_factura as doc	
								on (doc.idto,doc."tableId") in(
									(124,"factura_a_clienteId"),
									(249,"factura_rectificativa_ventasId"))																inner join
							clase on clase.id=doc.idto																					inner join
																																		
							mi_empresa as emp		on 	emp."tableId"=doc."mi_empresa"													inner join
							"cliente_particular" as c 
								on("clienteIdto"=485 and "cliente"=c."tableId" )								  						inner join
							replica_ids as racccli on 	racccli.destinatario='$ENDPOINT$' and
														racccli.clases='CUENTA_CONTABLE' and racccli."id_ERP"=emp.rdn||'#'||c.rdn		left join
														
							replica_ids as rpay on 		rpay.clases=']]><xsl:value-of select="name(.)" /><![CDATA[' and 
														pay."tableId"=rpay."id_ERP"::int and
														rpay.destinatario ='$ENDPOINT$' 												inner join
								
							replica_ids as rapcli on 		rapcli.clases='APUNTE_CLIENTE' and 
														rapcli.destinatario='$ENDPOINT$' and
														rapcli."id_ERP"::int=doc."tableId" and
														rapcli."descripción" like clase.rdn||'#%' 											left join
														
							replica_ids as rpaylin on 	rpaylin.clases='PAYMENT_LINE' and 
														rpaylin.destinatario='$ENDPOINT$' and
														rpaylin.parent=rpay.identificador_replicas and
														rpaylin.campo_aux1 = racccli.identificador_replicas						 		inner join
															
							replica_ids as rempresa on 				rempresa.destinatario='$ENDPOINT$' and
																	rempresa.clases='MI_EMPRESA'	and
																	rempresa."id_ERP"::int=emp."tableId"								inner join 
							replica_ids as rcli on 					rcli.destinatario = '$ENDPOINT$' and
																	rcli.clases='CLIENTE_PARTICULAR' and
																	rcli."id_ERP"::int=c."tableId"	and
																	rcli.identificador_replicas ~'^\d+$'								left join
														
							replica_ids as rdoc on 		rdoc.clases=clase.rdn and 
														doc."tableId"=rdoc."id_ERP"::int and
														rdoc.destinatario ='$ENDPOINT$' 												left join 
							replica_ids as rmon on 		rmon.destinatario = '$ENDPOINT$' and
														rmon.clases='MONEDA' 															
														,																				
							"delegación" as endpoint
																
															   
							where 	]]><xsl:value-of select="attribute::tableId" /><![CDATA[= pay."tableId" and
									emp.rdn in (]]><xsl:value-of select="$empresaclp" /><![CDATA[) and 
									('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$')
						order by urldest,fecha  desc													
					]]>
							
					<atom test="new" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>						
						<xsl:attribute name="groupby">{$asigrdn}</xsl:attribute>	
						<xsl:attribute name="slug">{$asigrdn}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						<xsl:attribute name="new_field_aux1">draft</xsl:attribute>
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.payment</par>	
							<par>create</par>
							<list>							
								<dict>
																		
									<payment_type>inbound</payment_type>
									<!--<move_id>{$rdocid}</move_id>-->
									<!--<name>FactCli {$docrdn} {$fecha}</name>-->
									<partner_type>customer</partner_type>
									<partner_id>{$idrcliente}</partner_id>
									<move_type>{$move_type}</move_type>
									<currency_id><xsl:value-of select="$euros" /></currency_id>									
									
									<journal_id><xsl:value-of select="$diariobanco" /></journal_id>
									
									<destination_account_id>{$destin_acc_id}</destination_account_id>
									
									<payment_method_id>1</payment_method_id>
									<payment_method_line_id>3</payment_method_line_id>
									
									<date>{$fecha}</date>
									
									<ref>{$payrdn}-{$importe}</ref>										
									<company_id>{$ridempresa}</company_id>
																											
									<amount>{$importe}</amount>																		
									<display_name>{$descrip}</display_name>	
									<state>draft</state>
								</dict>	
							</list>
						</list>
					</atom>		
					
					<atom test="new2" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>						
						<xsl:attribute name="groupby">{$asigrdn}</xsl:attribute>	
						<xsl:attribute name="slug">{$asigrdn}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>												
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.partial.reconcile</par>	
							<par>create</par>
							<list>							
								<dict>
																										
									<debit_move_id>{$rapcliid}</debit_move_id>
									<credit_move_id>{$rappayid}</credit_move_id>
																		
									<company_id>{$ridempresa}</company_id>
																											
									<amount>{$importe}</amount>				
									<credit_amount_currency>{$importe}</credit_amount_currency>
									<debit_amount_currency>{$importe}</debit_amount_currency>
									<display_name>{$descrip}</display_name>	
									
								</dict>	
							</list>
						</list>
					</atom>
					<atom test="new2" http="POST">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>						
						<xsl:attribute name="groupby">{$asigrdn}#ESTADO</xsl:attribute>	
						<xsl:attribute name="slug">{$asigrdn}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class"><xsl:value-of select="name(.)" /></xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>												
																																			
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.payment</par>	
							<par>write</par>
							<list>		
								<list>
									<par>{$rpayid}</par>
								</list>								
								<dict>													
									<state>posted</state>
								</dict>	
							</list>
						</list>
					</atom>									
				</clone>
			</xsl:when>						
			<xsl:when test="self::PRECIO">		
				<clone>
				<![CDATA[	
					select 
						 
						max(case 	when rpri.identificador_replicas is null then 'new'
								when rpri.identificador_replicas is not null then 'set'							
								else 'NA' end)as test,
										 
						max(case when rpri."id_ERP" is null  then 'create' else 'write' end) as apiaction,
						rtar.identificador_replicas as rtarid,
						max(round(pri.precio::numeric,5)) as price,
						endpoint."rdn" as endpointdest,						
						max(endpoint."página_web") as urldest,
						rtmpl.identificador_replicas as rprotmplid,						
						max(gconfig.rdn||'#'||tar.rdn) as descr
					from 
						"género" as gconfig																										inner join															
						"género" as g 			on(length(g.rdn)=10 and gconfig.rdn=substr(g.rdn, 1, 5))										inner join
						precio as pri 			on 	pri."géneroId"=g."tableId"																	inner join 
						tarifa_precio as tar	on tar."tableId"=pri.tarifa_precio																inner join
						
						replica_ids as rtmpl on 	rtmpl.clases='GÉNERO' and rtmpl.destinatario='$ENDPOINT$' and
													rtmpl."id_ERP"=gconfig.rdn																	inner join 
						
						replica_ids as rtar on 		rtar.clases='TARIFA_PRECIO' and rtar.destinatario='$ENDPOINT$' and
													rtar."id_ERP"=tar."tableId"::text															left join	
						
						replica_ids as rpri on 		rpri.clases='PRECIO' and rpri.destinatario='$ENDPOINT$' and
													rpri."id_ERP"=gconfig.rdn||'#'||tar.rdn				
						

						,"delegación" as endpoint											
							
					where 	
						pri."tableId"=]]><xsl:value-of select="attribute::tableId" /><![CDATA[ 							 
						and endpoint.rdn='$ENDPOINT$'		and
						pri.fecha_fin	is null
					
					group by endpoint."rdn",rtar.identificador_replicas ,rtmpl.identificador_replicas,gconfig.rdn,tar.rdn
					order by endpoint."rdn",gconfig.rdn,tar.rdn
							
					
					]]>																									

					
				<atom http="POST" test="new or set">	<!-- uso process_response solo para variacion usada en creacion producto por ser obligatoria, en siguientes usa new_field_aux1-->														
					<xsl:attribute name="groupby">{$descr}</xsl:attribute>
					<xsl:attribute name="url">{$urldest}</xsl:attribute>										
					<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>												
					
					<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>										
					<xsl:attribute name="method">execute_kw</xsl:attribute>								
							
					<xsl:attribute name="new_field_response"></xsl:attribute>	
					
					<xsl:attribute name="class">PRECIO</xsl:attribute>					
					<xsl:attribute name="tableId">{$descr}</xsl:attribute>
					<xsl:attribute name="slug">{$descr}</xsl:attribute>	
					<list>
						<par>db</par>	
						<par>uid</par>	
						<par>pwd</par>	
						<par>product.pricelist.item</par>	
						<par>{$apiaction}</par>
						<list>							
							<dict>
								<pricelist_id>{$rtarid}</pricelist_id>
								<base>list_price</base>
								<product_tmpl_id>{$rprotmplid}</product_tmpl_id>
								<compute_price>fixed</compute_price>	
								<applied_on>1_product</applied_on>
								<fixed_price>{$price}</fixed_price>
							</dict>	
						</list>
					</list>
					
				</atom>
			</clone>		
			</xsl:when>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="clientes">
		<xsl:param name = "clientes" />					
				<clone>
				<![CDATA[	
						select
						
						case when rccobro.identificador_replicas is null or rcpago.identificador_replicas is null then 'newccobro'
							 when rc.identificador_replicas is null then 'newcli'
							 else 'NA' end as test,
						endpoint."página_web" as urldest,
						endpoint."rdn" as endpointdest,
						
						c.rdn as cliref,
						c.nombre,
						c."NIF-CIF-VAT" as nif,
						c."teléfono" as tfno,
						c."móvil" as movil,
						c."email_notificaciones" as email,
						c."dirección" as direcc,
						c."tableId" as rclitid,
						local.rdn as city,
						rprov.identificador_replicas as state_id,
						rpais.identificador_replicas as country_id,
						to_timestamp(c.fecha_alta) as fechaalta,
						c."código_postal" as zip,
						'430'||lpad(c.rdn,9,'0') as ccode,
						rc.identificador_replicas as ridcli,
						rccobro.identificador_replicas as ridccobro,					
						rcpago.identificador_replicas as ridcpago,					
						rtar.identificador_replicas as ridtar,
						'asset_receivable' as actipo,
						rempresa.identificador_replicas as ridempresa,
						case when cc."tableId" is not null then cc."tableId" else 0 end as tidccobro,
						m.rdn||'#'||c.rdn as tid_cc_parent,
						case when  rc.identificador_replicas is null and exists(SELECT * FROM v_factura_a_cliente as vf WHERE vf.cliente=c."tableId" and vf."clienteIdto"=485) THEN rregiva.identificador_replicas 
									else null end as posfiscal,
						case 	when regiva.rdn ilike '%ntrac%' or c."NIF-CIF-VAT" ~ '^B.\d+'  then 'true' else 'false' end as iscompany,
						case when pais."código_pais" is null or pais."código_pais"<>'ES' then true else false end as noval,
						case 	when regiva.rdn ilike '%export%' then '06' else null end as tipo_id_fiscal_sii						
						
						from 									
						cliente_particular as c																				inner join 
						"régimen_iva" as regiva on regiva."tableId"="régimen_iva" 											inner join
						replica_ids as rregiva	on rregiva.destinatario='$ENDPOINT$' and
												rregiva.clases='RÉGIMEN_IVA'	and
												rregiva."id_ERP"=regiva."tableId"::text 									left join
						localidad as local 		on local."tableId"=c.localidad												left join
						provincia				on provincia."tableId"=c."provinciaPROVINCIA"								left join
						"país" as pais 			on pais."tableId"=c."país"													left join
						replica_ids as rpais	on rpais.destinatario='$ENDPOINT$' and
												rpais.clases='PAÍS'	and
												rpais."id_ERP"=pais."tableId"::text											left join
						replica_ids as rprov	on rprov.destinatario='$ENDPOINT$' and
												rprov.clases='PROVINCIA'	and
												rprov."id_ERP"=provincia."tableId"::text							 		left join
						"cliente_particular#cuenta_contable"	as clic on clic."cliente_particularId"=c."tableId"			left join
						cuenta_contable as cc	on cc."tableId"="cuenta_contableId" 										left join
						
						replica_ids as rc on 	rc.destinatario='$ENDPOINT$' and
												rc.clases='CLIENTE_PARTICULAR'	and
												rc."id_ERP"::int=c."tableId" 												left join
						tarifa_precio as tar 	on tar."tableId"=tarifa_precio												left join
						replica_ids as rtar on 	rtar.destinatario='$ENDPOINT$' and
												rtar.clases='TARIFA_PRECIO'	and
												rtar."id_ERP"=tar."tableId"::text 																					inner join
													
						replica_ids as rcpago on 	rcpago.destinatario='$ENDPOINT$' and
													rcpago.clases='CUENTA_CONTABLE' and rcpago.nombre='Acreedores por prestaciones de servicios (euros)'			inner join																							
						"delegación" as endpoint	on 	endpoint.rdn='$ENDPOINT$' 																					inner join
						"mi_empresa" as m 			on m."tableId"=endpoint."empresaMI_EMPRESA"																		inner join
						replica_ids as rempresa on 	rempresa.destinatario='$ENDPOINT$' and
													rempresa.clases='MI_EMPRESA' 																					left join
						replica_ids as rccobro on 	rccobro.destinatario='$ENDPOINT$' and
													rccobro.clases='CUENTA_CONTABLE' and rccobro."id_ERP"=m.rdn||'#'||c.rdn							
								
					where m.rdn in (]]><xsl:value-of select="$empresaclp" /><![CDATA[) and c."tableId" in( ]]><xsl:value-of select="$clientes" /><![CDATA[ ) ]]>
					<atom http="POST" test="newccobro" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn']"/>
						<xsl:attribute name="slug">text:{$ccode}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class">CUENTA_CONTABLE</xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						<xsl:attribute name="tableId">{$tid_cc_parent}</xsl:attribute>																																				
						<xsl:attribute name="method">execute_kw</xsl:attribute>									
						
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>account.account</par>	
							<par>create</par>
							<list>							
								<dict>
									<code>text:{$ccode}</code>
									<name>Cliente {$cliref} {$nombre}</name>																							
									<company_id>{$ridempresa}</company_id>
									<account_type>{$actipo}</account_type>
									<reconcile>true</reconcile>
								</dict>	
							</list>
						</list>
					</atom>
					<atom test="newcli" http="POST" new_field_response="">
						<xsl:copy-of select="@*[name(.)='action' or name(.)='rdn' or name(.)='tableId']"/>
						<xsl:attribute name="slug">text:{$cliref}</xsl:attribute>	
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
						<xsl:attribute name="url">{$urldest}</xsl:attribute>
						<xsl:attribute name="class">CLIENTE_PARTICULAR</xsl:attribute>	
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>						
						<xsl:attribute name="tableId">{$rclitid}</xsl:attribute>																													
						<xsl:attribute name="method">execute_kw</xsl:attribute>							
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>res.partner</par>	
							<par>create</par>
							<list>							
								<dict>
									<ref>text:{$cliref}</ref>
									<name>{$nombre}</name>																								
									<company_id>{$ridempresa}</company_id>
									<property_product_pricelist>{$ridtar}</property_product_pricelist>
									<phone>text:{$tfno}</phone>
									<mobile>text:{$movil}</mobile>
									<vat>text:{$nif}</vat>
									<email>{$email}</email>
									<lang>es_ES</lang>
									<street>{$direcc}</street>
									<city>{$city}</city>
									<state_id>{$state_id}</state_id>
									<zip>{$zip}</zip>
									<country_id>{$country_id}</country_id>									
									<property_account_position_id>{$posfiscal}</property_account_position_id>
									<create_date>{$fechaalta}</create_date>
									<customer_rank>1</customer_rank><!--indica es cliente-->
									<property_account_payable_id>{$ridcpago}</property_account_payable_id>
									<property_account_receivable_id>{$ridccobro}</property_account_receivable_id>
									<is_company>{$iscompany}</is_company>
									<!--<followup_reminder_type>manual</followup_reminder_type>-->
									<!--<aeat_identification_type>text:{$tipo_id_fiscal_sii}</aeat_identification_type>-->
									<!--reception_steps:one_step-->
								</dict>	
							</list>
							<dict>
								<context>
									<dict>
										<no_vat_validation>{$noval}</no_vat_validation>
									</dict>
								</context>									
							</dict>	
						</list>
					</atom>
				</clone>					
	</xsl:template>
	<xsl:template name="genero">
		<xsl:param name = "genset" />							
			<clone>
				<![CDATA[	
					select distinct 
					'setvar' as test,
					rp.identificador_replicas as idreppro,
					
					
					max(round(g.pvp_iva_incluido_promocion::Numeric,2) )  OVER(PARTITION BY substr(g.rdn, 1, 5)) as pvpii,
					max(round(g.campo_aux1::Numeric,2) )  OVER(PARTITION BY substr(g.rdn, 1, 5)) as precio,
					round(g.coste::Numeric,2) as coste,					
					upper(substring(btrim(g."descripción"),1,1))||lower(substring(btrim(g."descripción"),2)) as descr, 
					substr(g.rdn, 1, 5) as skuprod,
					
					endpoint.rdn as endpointdest,
					endpoint."página_web" as urldest
					
					from 
					"género" as g																			inner join
					unnest(ARRAY[]]><xsl:value-of select="$genset" /><![CDATA[]) as propro 					
									on substr(g.rdn,1,5) =substr(propro,1,5)								inner join
					"delegación" as endpoint 	on ('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$') 			inner join
					mi_empresa as m 
							on	m."tableId"=g."empresaMI_EMPRESA" 
								and m.rdn in('001','006') 																	inner join																																																											
					replica_ids as rp on (rp.clases='GÉNERO' and rp."id_ERP"=substr(g.rdn, 1, 5) and rp.destinatario=endpoint.rdn)									
							
					where  g.campo_aux1 is not null  order by endpoint.rdn]]>

					<atom http="POST" test="setvar">	<!-- uso process_response solo para variacion usada en creacion producto por ser obligatoria, en siguientes usa new_field_aux1-->									
						<xsl:attribute name="groupby">{$idreppro}</xsl:attribute>
						<xsl:attribute name="class">GÉNERO</xsl:attribute>																	

						<xsl:attribute name="url">{$urldest}</xsl:attribute>										
						<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>												
						
						<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>										
						<xsl:attribute name="method">execute_kw</xsl:attribute>											
						<list>
							<par>db</par>	
							<par>uid</par>	
							<par>pwd</par>	
							<par>product.template</par>	
							<par>write</par>
							<list>			
								<list>
									<par>{$idreppro}</par>
								</list>
								<dict>
									<list_price>{$pvpii}</list_price>	
									<wholesale_price>{$precio}</wholesale_price>									
								</dict>	
							</list>
						</list>					
					</atom>
			</clone>				
	</xsl:template>
	
	<xsl:template name="replicaoff">
		<xsl:param name = "replist" />							
			<clone>
					<![CDATA[							
						select distinct rp.identificador_replicas as idreppro,					
						
						endpoint."página_web" as urldest,
						endpoint."rdn" as endpointdest,
						
						rp."tableId" as rid
						
						from 
						replica_ids as roff																		inner join
						"género" as g	on 	roff.destinatario='MAG' and 
											roff.clases='STOCK' and 
											length(roff.nombre)=5 and
											g.rdn=roff.nombre and
											not roff.activo														inner join
						replica_ids as rmagnew on 	roff.destinatario=rmagnew.destinatario and
													roff.clases=rmagnew.clases and
													roff.nombre= rmagnew.nombre and
													rmagnew."tableId">roff."tableId" and
													(rmagnew.activo is null or rmagnew.activo) 						inner join
						"delegación" as endpoint 	on ('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$') 				inner join
						mi_empresa as m 
								on	m."tableId"=g."empresaMI_EMPRESA" and g.rdn ~'^\d{5}$'
									and m.rdn in('001','006')													inner join
						replica_ids as rp 
							on (rp."id_ERP"=substr(g.rdn, 1, 5) and rp.clases='GÉNERO' and rp.destinatario='$ENDPOINT$' )						 					
								
						where  rmagnew."tableId">rp."tableId" and roff."tableId" in(]]><xsl:value-of select="$replist"/><![CDATA[) and (rp.activo is null or rp.activo) ]]>
						<atom http="DELETE"><!--producto set precio a todas variaciones-->		
							<xsl:attribute name="groupby">{$idreppro}</xsl:attribute>
							<xsl:attribute name="class">GÉNERO</xsl:attribute>
							<xsl:attribute name="url">{$urldest}</xsl:attribute>														
							<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
							<xsl:attribute name="path">products/{$idreppro}.json</xsl:attribute>																					
							<xsl:attribute name="rid">{$rid}</xsl:attribute><!--usado para eliminar replica_ids-->	
						</atom>
				</clone>				
	</xsl:template>	
	
	<xsl:template name="stockset">
		<xsl:param name = "stock_set_ids" />	
		<xsl:param name = "gendesc_id" />			
			<clone>
			<![CDATA[	
				select 
					case 	
							when rp."id_ERP" is not null and rs."id_ERP" is not null then 'setvar'							
							else 'NA' end as test,						
					case when g.visible_web is not null and not g.visible_web then 'archived' 
						 when pro is null then 'archived'
						 when endpoint.rdn in('0023','0032') then NULL
						 else 'active' end as active,							
					case 
						when g.visible_web is not null and not g.visible_web then 0
						when round(s.stock_disponible)>10 then 6 
						when round(s.stock_disponible)<=3 then 0
						else round(s.stock_disponible)-3 end as cantidad,
					rp.identificador_replicas as idreppro,		
					rs.identificador_replicas as idrepstock,	
					s."tableId" as stocktid,
					endpoint."página_web" as urldest,
					endpoint."rdn" as endpointdest,
					rs.campo_aux1 as rstockaux1,
					ralm.identificador_replicas as locationid,
					case when g.campo_aux1 is null then NULL else g.campo_aux1::double precision*1.1 end as coste	
					
				from 
					stock as s																									inner join
					"almacén" as a on "almacén_stock"=a."tableId" and 
									  a.rdn=']]><xsl:value-of select="$almcentral" /><![CDATA['									inner join
					"género" as g 			on(g."tableId"=s.producto)															inner join
					"delegación" as endpoint 	on ('$ENDPOINT$'='*' or endpoint.rdn='$ENDPOINT$') 								left join
					(	select distinct substring(g2.rdn,1,5) as pro,"almacén_stock" from 
						stock as s2 inner join 
						"género" as g2 on s2.producto=g2."tableId" 
						where s2.stock_disponible>3) 
														as d on pro=substring(g.rdn,1,5)										inner join
					replica_ids as ralm 	on	ralm.clases='ALMACÉN' and
												ralm.destinatario=endpoint.rdn 													inner join
										
					replica_ids as rp on 	rp.clases='GÉNERO' and rp.destinatario=endpoint.rdn and
											rp."id_ERP"=substr(g.rdn, 1, 5) 													inner join
					replica_ids as rs on 	rs.clases='STOCK' and rs.destinatario=endpoint.rdn and
											s."tableId"=rs."id_ERP"::int														
				where (s."tableId" in(]]><xsl:value-of select="$stock_set_ids" /><![CDATA[) or g."tableId" in(]]><xsl:value-of select="$gendesc_id" /><![CDATA[)) and (rs.activo is null or rs.activo)  ]]>									
			
			<atom test="setvar" http="POST"> 
				<xsl:attribute name="groupby">{$rstockaux1}</xsl:attribute>	
				<xsl:attribute name="url">{$urldest}</xsl:attribute>
				<xsl:attribute name="path">inventory_levels/set.json</xsl:attribute>	
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
				<xsl:attribute name="location_id">{$locationid}</xsl:attribute>
				<xsl:attribute name="inventory_item_id">{$rstockaux1}</xsl:attribute>
				<xsl:attribute name="available">{$cantidad}</xsl:attribute>	
				<xsl:attribute name="cost">double:{$coste}</xsl:attribute>						
			</atom>
			
			<atom test="setvar" http="PUT">	
				<xsl:attribute name="class">GÉNERO</xsl:attribute>						
				<xsl:attribute name="test">{$active}</xsl:attribute>			
				<xsl:attribute name="groupby">{$idreppro}</xsl:attribute>
				<xsl:attribute name="url">{$urldest}</xsl:attribute>										
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
				<xsl:attribute name="class">GÉNERO</xsl:attribute>									
				<xsl:attribute name="path">products/{$idreppro}.json</xsl:attribute>				
				<product>																				
					<xsl:attribute name="status">{$active}</xsl:attribute>
					<xsl:attribute name="id">{$idreppro}</xsl:attribute>
				</product>				
			</atom>
		</clone>				
	</xsl:template>	
		
	<xsl:template name="stocknew">
		<xsl:param name = "stock_new_ids" />	
		<xsl:param name = "gconfig_de_img_id" />
		<xsl:param name = "g_de_img_id" />
		<xsl:param name = "gconfig_de_cat_id" />
		<xsl:param name = "coloridsparam" />		
		<xsl:param name = "modelofvarnew" />
		<xsl:param name = "generotmpl" />
		<!--PRODUCTO -->
				<clone>
	<![CDATA[	
				select 
					distinct 
					case 	when rt.identificador_replicas is null then 'newtalla'
							when rc.identificador_replicas is null then 'newcolor'
							when rtmpl."id_ERP" is null then 'newtmpl' 	
							when ratrlinet.rdn is null then 'newatlinet' 
							when ratrlinec.rdn is null then 'newatlinec'
							when rvar."id_ERP" is null then 'setlinetc' 									
							when rvar."id_ERP" is not null then 'setvar' 																		
							when rvar."id_ERP" is not null then 'setpro'							
							else 'NA' end as test,
									 
					case when rtmpl."id_ERP" is null or  rvar."id_ERP" is null then 'create' else 'write' end as apiaction,

					
					upper(substring(btrim(g."descripción"),1,1))||lower(substring(btrim(g."descripción"),2)) as descr, 
					case when g."específicaciones" is not null and length(g."específicaciones")>0 then upper(substring(btrim(g."específicaciones"),1,1))||lower(substring(btrim(g."específicaciones"),2))
							 else upper(substring(btrim(g."descripción"),1,1))||lower(substring(btrim(g."descripción"),2))
							 end
							 as especif, 
					
					substr(g.rdn, 9) as tallaref,
					substr(g.rdn, 6, 3) as colorref,
					round(g.pvp_iva_incluido_promocion::numeric,3) as pvp_promoii,
					  
					max(round((case when g.campo_aux1 is null then g.pvp else g.campo_aux1::double precision end)::Numeric,2))  OVER(PARTITION BY substr(g.rdn, 1, 5)) as preciomayor,
					round(g.coste::numeric,3) as coste,
					case when rtmpl."id_ERP" is null then 'true' else NULL::text end as visible_web,

					case when rcat.identificador_replicas is null then '1' else rcat.identificador_replicas end as ridcat,
					

					upper(substr(g.rdn, 9)) as term_prod_talla,
					substr(g.rdn, 6, 3) as term_prod_color,
					substr(g.rdn, 6, 3) as prod_color_name,
					
					rmetat.identificador_replicas as attid_talla,  
					rmetac.identificador_replicas as attid_color,

					substr(g.rdn, 1, 5) as skuprod,
					g.rdn as sku,
					
					case when (count(substring(g.rdn from 6 for 3)) OVER(PARTITION BY g.rdn))  =1 then rc.nombre else NULL end as color_default,
					endpoint."página_web" as urldest,
					endpoint."rdn" as endpointdest,
					
					array_agg('{'||rtax.identificador_replicas||'}') OVER(PARTITION BY g.rdn) as ridtax,	
					rtmpl.identificador_replicas as ridprotmpl,
					array_agg('{'||rt.identificador_replicas||'}')  OVER(PARTITION BY substr(g.rdn, 1, 5)) as ridtalla,
					array_agg('{'||rc.identificador_replicas||'}') OVER(PARTITION BY substr(g.rdn, 1, 5)) as ridcolor,
					ratrlinet.identificador_replicas as ridatlinet,
					ratrlinec.identificador_replicas as ridatlinec,
					rvar.identificador_replicas as idrvar
				from 
					
					"género" as g 																											inner join
					unnest(ARRAY[]]><xsl:value-of select="$generotmpl" /><![CDATA[]) as propro 
						on substr(g.rdn,1,5) =substr(propro,1,5)																			inner join
					tipo_iva as iva 		on g.iva=iva."tableId"																			left join					
					
					"género#categoria_articulo" as gcat  on	g."tableId"=gcat."géneroId"														left join 										
					"categoria_articulo" as cat on cat."tableId"= "categoria_articuloId"													inner join

					replica_ids as rmetac on rmetac.clases='META_COLOR' and
											 rmetac.destinatario='$ENDPOINT$' and
											 rmetac.nombre ilike '%color'																	inner join												
					replica_ids as rmetat on 	rmetat.destinatario='$ENDPOINT$' and 
												rmetat.clases='META_TALLA' and
												rmetat.nombre ilike '%talla'																left join
					replica_ids as rt 																																		
						on 	rt.clases='TALLA' and rt.destinatario='$ENDPOINT$' and
							rt."id_ERP"=substr(g.rdn, 9)																			left join

					replica_ids as rc 																									
						on 	rc.clases='COLOR' and rc.destinatario='$ENDPOINT$' and									
							rc."id_ERP"=substr(g.rdn, 6, 3)																					left join 
					
					replica_ids as rtmpl on 	rtmpl.clases='GÉNERO' and rtmpl.destinatario='$ENDPOINT$' and
												rtmpl."id_ERP"=substr(g.rdn, 1, 5)																	left join
												
					replica_ids as ratrlinet on 	ratrlinet.clases='ATTRIBUTELINE' and ratrlinet.destinatario='$ENDPOINT$' and
												ratrlinet."id_ERP"=substr(g.rdn, 1, 5)||'#TALLAS'													left join
												
					replica_ids as ratrlinec on 	ratrlinec.clases='ATTRIBUTELINE' and ratrlinec.destinatario='$ENDPOINT$' and
												ratrlinec."id_ERP"=substr(g.rdn, 1, 5)||'#COLORES'													left join 
					
					replica_ids as rvar on 		rvar.clases='VARIANTE' and rvar.destinatario='$ENDPOINT$' and
												rvar."id_ERP"=g.rdn																			left join
					
					replica_ids as rcat on  rcat.clases='CATEGORIA_ARTICULO' and 
											rcat.destinatario = '$ENDPOINT$#categ' and											
											rcat."id_ERP"~('(^|\{|\,)'||cat."tableId"::text||'(\}|\,|$)') and
											rcat.campo_aux1='LEVEL2'					left join 
					
					replica_ids as rtax on 	rtax.clases='TIPO_IVA' and rtax.destinatario='$ENDPOINT$' and
											rtax."id_ERP"=iva."tableId"::text and rtax."descripción" like '%ventas' and not rtax."nombre" ilike '%Recargo%'
												
					

					,"delegación" as endpoint											
						
				where 	(g.descatalogado is null or not descatalogado) and 
						(rvar.activo is null or rvar.activo) 
						and endpoint.rdn='$ENDPOINT$'
						and g."descripción" not ilike '%Dropship%' and g."descripción" not ilike '%tarjeta%' and g."descripción" not ilike '%tara%'
								
				order by endpoint."rdn",g.rdn
				
				]]>																									
			<atom http="POST" test="newatlinet or setlinetc">
				<!--uso dos atom separados por que cuando se crea una nueva variante, y existe attline en replica ids, solo hay un registro de replica ids por at line (talla o color) no se sabe el contenido, 
				si se esta añadiendo una variacion de talla, de color, o de ambas, y tengo que actualizar ambas seguidas, dos atom-->							
				<xsl:attribute name="new_field_response"></xsl:attribute>	
				<xsl:attribute name="groupby">{$skuprod}</xsl:attribute>

				<xsl:attribute name="url">{$urldest}</xsl:attribute>										
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>																
				<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>										
				<xsl:attribute name="method">execute_kw</xsl:attribute>	
				
				<xsl:attribute name="tableId">{$skuprod}#TALLAS</xsl:attribute>		
				<xsl:attribute name="class">ATTRIBUTELINE</xsl:attribute>					
				<xsl:attribute name="slug">{$skuprod}#TALLAS</xsl:attribute>
				<xsl:attribute name="name">{$skuprod}#TALLAS</xsl:attribute>
				<list>
					<par>db</par>	
					<par>uid</par>	
					<par>pwd</par>	
					<par>product.template.attribute.line</par>							
					
					<par test="newatlinet">create</par>																		
					<par test="setlinetc">write</par>						
					
					<list>										
						<list test="setlinetc">
							<par>{$ridatlinet}</par>
						</list>													
						<dict>
							<product_tmpl_id>{$ridprotmpl}</product_tmpl_id>
							<attribute_id>{$attid_talla}</attribute_id>
							<value_ids>
								<list>													
									<item>
										<xsl:attribute name="foreach">{$ridtalla}</xsl:attribute>
										<content>{$1}</content>
									</item>
								</list>
							</value_ids>								
						</dict>	
					</list>
				</list>					
			</atom>			
			<atom http="POST" test="newatlinec or setlinetc">						
				<xsl:attribute name="new_field_response"></xsl:attribute>	
				<xsl:attribute name="groupby">{$skuprod}</xsl:attribute>

				<xsl:attribute name="url">{$urldest}</xsl:attribute>										
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>																
				<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>										
				<xsl:attribute name="method">execute_kw</xsl:attribute>	
				
				<xsl:attribute name="tableId">{$skuprod}#COLORES</xsl:attribute>		
				<xsl:attribute name="class">ATTRIBUTELINE</xsl:attribute>					
				<xsl:attribute name="slug">{$skuprod}#COLORES</xsl:attribute>
				<xsl:attribute name="name">{$skuprod}#COLORES</xsl:attribute>
				<list>
					<par>db</par>	
					<par>uid</par>	
					<par>pwd</par>	
					<par>product.template.attribute.line</par>	

					<par test="newatlinec">create</par>																		
					<par test="setlinetc">write</par>
					
					<list>		
						<list test="setlinetc">
							<par>{$ridatlinec}</par>
						</list>						
						
						<dict>
							<product_tmpl_id>{$ridprotmpl}</product_tmpl_id>
							<attribute_id>{$attid_color}</attribute_id>
							<value_ids>
								<list>										
									<item>
										<xsl:attribute name="foreach">{$ridcolor}</xsl:attribute>
										<content>{$1}</content>
									</item>											
								</list>
							</value_ids>								
						</dict>	
					</list>
				</list>					
			</atom>	
				
			<atom http="POST" test="newtalla or newcolor or newtmpl or setvar">	<!-- uso process_response solo para variacion usada en creacion producto por ser obligatoria, en siguientes usa new_field_aux1-->									
				<xsl:attribute name="groupby">{$skuprod}</xsl:attribute>
				<xsl:attribute name="url">{$urldest}</xsl:attribute>										
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>												
				
				<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>										
				<xsl:attribute name="method">execute_kw</xsl:attribute>			

				<whenc test="newtalla">					
					<xsl:attribute name="new_field_response"></xsl:attribute>	
					<xsl:attribute name="groupby">{$tallaref}</xsl:attribute>
					<xsl:attribute name="tableId">{$tallaref}</xsl:attribute>		
					<xsl:attribute name="class">TALLA</xsl:attribute>					
					<xsl:attribute name="slug">{$term_prod_talla}</xsl:attribute>
					<xsl:attribute name="name">{$term_prod_talla}</xsl:attribute>
					<list>
						<par>db</par>	
						<par>uid</par>	
						<par>pwd</par>	
						<par>product.attribute.value</par>	
						<par>create</par>						
						<list>							
							<dict>
								<name>text:{$term_prod_talla}</name>	
								<display_name>text:{$term_prod_talla}</display_name>
								<code>text:{$tallaref}</code>
								<attribute_id>{$attid_talla}</attribute_id>
								<is_used_on_products>true</is_used_on_products>
								<sequence>1</sequence>
							</dict>	
						</list>
					</list>					
				</whenc>
				<whenc test="newcolor">					
					<xsl:attribute name="new_field_response"></xsl:attribute>	
					<xsl:attribute name="groupby">{$colorref}</xsl:attribute>
					<xsl:attribute name="tableId">{$colorref}</xsl:attribute>		
					<xsl:attribute name="class">COLOR</xsl:attribute>					
					<xsl:attribute name="slug">{$term_prod_color}</xsl:attribute>
					<xsl:attribute name="name">{$term_prod_color}</xsl:attribute>
					<list>
						<par>db</par>	
						<par>uid</par>	
						<par>pwd</par>	
						<par>product.attribute.value</par>	
						<par>create</par>						
						<list>							
							<dict>
								<name>text:{$prod_color_name}</name>	
								<display_name>text:{$prod_color_name}</display_name>
								<code>text:{$colorref}</code>
								<attribute_id>{$attid_color}</attribute_id>
								<is_used_on_products>true</is_used_on_products>
								<sequence>1</sequence>
							</dict>	
						</list>
					</list>					
				</whenc>				
				<whenc test="newtmpl"> 				
					<xsl:attribute name="new_field_response"></xsl:attribute>	
					<xsl:attribute name="groupby">{$skuprod}</xsl:attribute>
					<xsl:attribute name="class">GÉNERO</xsl:attribute>					
					<xsl:attribute name="tableId">{$skuprod}</xsl:attribute>
					<xsl:attribute name="slug">{$descr}</xsl:attribute>	
					<list>
						<par>db</par>	
						<par>uid</par>	
						<par>pwd</par>	
						<par>product.template</par>	
						<par>{$apiaction}</par>
						<list>							
							<dict>
								<name>{$descr}-{$skuprod}</name>
								<description>{$descr}</description>
								<!--Sin categoria, corresponde a la familia, falta poner categorias ecommerce <categ_id>{$ridcat}</categ_id>-->
								<uom_id>1</uom_id>
								<uom_po_id>1</uom_po_id>
								<detailed_type>product</detailed_type>
								<sale_line_warn>no-message</sale_line_warn>
								<default_code>text:{$skuprod}</default_code>
								<available_in_pos>true</available_in_pos>
								<default_code>text:{$skuprod}</default_code>
								<list_price>{$pvp_promoii}</list_price>		
								<wholesale_price>{$preciomayor}</wholesale_price>		
								<is_published>{$visible_web}</is_published>								
								<taxes_id>
									<list>
										<item>
											<xsl:attribute name="foreach">{$ridtax}</xsl:attribute>
											<content>{$1}</content>
										</item>
									</list>
								</taxes_id>								
							</dict>	
						</list>
					</list>
				</whenc>
			
				<whenc test="setvar"> 				
					<xsl:attribute name="groupby">{$sku}</xsl:attribute>
					<xsl:attribute name="class">VARIANTE</xsl:attribute>					
					<xsl:attribute name="tableId">{$sku}</xsl:attribute>
					<xsl:attribute name="slug">{$descr}</xsl:attribute>	
					<list>
						<par>db</par>	
						<par>uid</par>	
						<par>pwd</par>	
						<par>product.product</par>	
						<par>write</par>
						<list>			
							<list>
								<par>{$idrvar}</par>
							</list>
							<dict>
								<name>{$descr}-{$skuprod}</name>
								<description>{$descr}</description>
								<product_tmpl_id>{$ridprotmpl}</product_tmpl_id>
								<!--Sin categoria, corresponde a la familia, falta poner categorias ecommerce <categ_id>{$ridcat}</categ_id>-->						
								<uom_id>1</uom_id>
								<uom_po_id>1</uom_po_id>
								<detailed_type>product</detailed_type>
								<sale_line_warn>no-message</sale_line_warn>
								<default_code>text:{$sku}</default_code>
								<barcode>text:{$sku}</barcode>								
								
								<standard_price>{$coste}</standard_price>
								<available_in_pos>true</available_in_pos>
								<!--<product_template_attribute_value_ids>
									<list>
										<par>11</par>										
										<par>14</par>		
									</list>
								</product_template_attribute_value_ids>
								<attribute_line_ids>
									<list>
										<par>{$ridatlinet}</par>
										<par>{$ridatlinec}</par>
									</list>								
								</attribute_line_ids>-->
								<taxes_id>
									<list>
										<item>
											<xsl:attribute name="foreach">{$ridtax}</xsl:attribute>
											<content>{$1}</content>
										</item>
									</list>
								</taxes_id>								
							</dict>	
						</list>
					</list>
				</whenc>				
			</atom>
		</clone>																													
	</xsl:template>	
	
	<xsl:template name="stock_y_quant_set">
		<xsl:param name = "stock_y_quant_set_ids" />			
			<clone>
			<![CDATA[	
				select 
					case 	
							when rp."id_ERP" is not null and rs."id_ERP" is null then 'new'	
							when rp."id_ERP" is not null and rs."id_ERP" is not null then 'set'							
							else 'NA' end as test,						
						
					case when rp."id_ERP" is not null and rs."id_ERP" is null then 'create' 
						 when rs."id_ERP" is not null then 'write' 
						 else 'NA' end as apiaction,
					
					s.stock_disponible as cantidad,
					rp.identificador_replicas as idreppro,
					rvar.identificador_replicas as idvar,		
					rs.identificador_replicas as idrepstock,	
					s."tableId" as stocktid,
					endpoint."página_web" as urldest,
					endpoint."rdn" as endpointdest,								
					upper(g.rdn) as idsku,
					upper(s.clave_producto) as sku
					
				from 
					stock as s																									inner join
					"almacén" as a on "almacén_stock"=a."tableId" 								inner join
				    "género" as g 			on(g."tableId"=s.producto)															inner join
										
					replica_ids as rp on 	rp.clases='GÉNERO' and rp.destinatario='$ENDPOINT$' and
											rp."id_ERP"=substr(g.rdn, 1, 5)	 													inner join											
					
					replica_ids as rvar on 		rvar.clases='VARIANTE' and rvar.destinatario='$ENDPOINT$' and
												rvar."id_ERP"=g.rdn	 															left join
												
					replica_ids as rs on 	rs.clases='STOCK' and rs.destinatario='$ENDPOINT$' and
											rs."id_ERP"::int=s."tableId"								
					,"delegación" as endpoint											
				where s."tableId" in(]]><xsl:value-of select="$stock_y_quant_set_ids" /><![CDATA[) and (rs.activo is null or rs.activo) 
					  and endpoint.rdn='$ENDPOINT$' and
					  not(a.rdn='001R' and exists(select 1 from stock where producto=s.producto and rdn like '001#%' and cantidad>0))
				]]>									
			
			<atom test="new or set" http="POST"> 
				<xsl:attribute name="groupby">{$idsku}</xsl:attribute>
				<xsl:attribute name="tableId">{$stocktid}</xsl:attribute>	
				<xsl:attribute name="slug">{$sku}</xsl:attribute>					
				<xsl:attribute name="url">{$urldest}</xsl:attribute>
				<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>		
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
				<xsl:attribute name="class">STOCK</xsl:attribute>													
				<xsl:attribute name="method">execute_kw</xsl:attribute>					
				<xsl:attribute name="name">{$sku}</xsl:attribute>
				<whenc test="new">
					<xsl:attribute name="new_field_response"/>
				</whenc>
				<list>
					<par>db</par>	
					<par>uid</par>	
					<par>pwd</par>	
					<par>stock.quant</par>	
					<par>{$apiaction}</par>
					<list>			
						<list test="set">
							<par>{$idrepstock}</par>
						</list>
						<dict>
							<location_id><xsl:value-of select="$location" /></location_id>					
							<product_id>{$idvar}</product_id>
							<quantity>{$cantidad}</quantity>							
						</dict>	
					</list>
				</list>					
			</atom>
		</clone>				
	</xsl:template>	
	
	<xsl:template name="services">
		<xsl:param name = "servicetmpl" />
		<!--PRODUCTO -->
				<clone>
	<![CDATA[	
				select 
					distinct 
					case 	
							when rtmpl."id_ERP" is null then 'newtmpl' 								
							when rtmpl."id_ERP" is not null then 'setpro'							
							else 'NA' end as test,
									 
					case when rtmpl."id_ERP" is null then 'create' else 'write' end as apiaction,

					
					upper(substring(btrim(g."descripción"),1,1))||lower(substring(btrim(g."descripción"),2)) as descr, 					
					
					round(g.pvp_iva_incluido_promocion::numeric,4) as pvp,
					g.campo_aux1::numeric as preciomayor,
					  					
					round(g.coste::numeric,4) as coste,

					case when rcat.identificador_replicas is null then '1' else rcat.identificador_replicas end as ridcat,					

					g.rdn as skuprod,
					g."tableId" as gtid,
					g.rdn as sku,
					round(g.coste::numeric,4),
					
					'true' as sale_ok,
					'true' as purchase_ok,
															
					endpoint."página_web" as urldest,
					endpoint."rdn" as endpointdest,
					array_agg('{'||rtax.identificador_replicas||'}') OVER(PARTITION BY g.rdn) as ridtax,	
					rtmpl.identificador_replicas::int as ridprotmpl
				from 
					
					"servicio" as g 																										left join
					subfamilia as sf on g.subfamilia=sf."tableId"																			inner join
					unnest(ARRAY[]]><xsl:value-of select="$servicetmpl" /><![CDATA[]) as propro 
											on g."tableId" =propro																			inner join
					tipo_iva as iva 		on g.iva=iva."tableId"																			left join 										
					"categoria_articulo" as cat on cat.categoria_superior is not null and cat.rdn=sf.rdn									left join 
					
					replica_ids as rtmpl on 	rtmpl.clases='SERVICIO' and rtmpl.destinatario='$ENDPOINT$' and
												rtmpl."id_ERP"=g."tableId"::text																		left join
					
					replica_ids as rcat on  rcat.clases='CATEGORIA_ARTICULO' and 
											rcat.destinatario = '$ENDPOINT$' and											
											rcat."id_ERP"=cat."tableId"::text																left join 
					
					replica_ids as rtax on 	rtax.clases='TIPO_IVA' and rtax.destinatario='$ENDPOINT$' and
											rtax."id_ERP"=iva."tableId"::text and rtax."descripción" like '%ventas' and not rtax."nombre" ilike '%Recargo%' 
					
																				
															

					,"delegación" as endpoint											
						
				where 	
						endpoint.rdn='$ENDPOINT$'
						
								
				order by endpoint."rdn",g.rdn
				
				]]>																												
				
			<atom http="POST" test="newtmpl or setpro">	<!-- uso process_response solo para variacion usada en creacion producto por ser obligatoria, en siguientes usa new_field_aux1-->									
				<xsl:attribute name="groupby">{$gtid}</xsl:attribute>
				<xsl:attribute name="url">{$urldest}</xsl:attribute>										
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>												
				
				<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>										
				<xsl:attribute name="method">execute_kw</xsl:attribute>			
			
				<whenc test="newtmpl"> 
					<xsl:attribute name="groupby">{$gtid}</xsl:attribute>
					<xsl:attribute name="class">SERVICIO</xsl:attribute>					
					<xsl:attribute name="tableId">{$gtid}</xsl:attribute>
					<xsl:attribute name="slug">{$descr}</xsl:attribute>	
					<xsl:attribute name="new_field_response"></xsl:attribute>					
					<list>
						<par>db</par>	
						<par>uid</par>	
						<par>pwd</par>	
						<par>product.template</par>	
						<par>create</par>						
						<list>										
							<dict>
								<name>{$descr}</name>
								<description>{$descr}</description>																
								
								<detailed_type>service</detailed_type>
								<!--<sale_line_warn>no-message</sale_line_warn>-->
								<default_code>text:{$skuprod}</default_code>
								<sale_ok>{$sale_ok}</sale_ok>
								<purchase_ok>{$purchase_ok}</purchase_ok>							
								<list_price>{$pvp}</list_price>	
								<wholesale_price>{$preciomayor}</wholesale_price>			
								<is_published>false</is_published>								
								<categ_id>{$ridcat}</categ_id>
								<standard_price>{$coste}</standard_price>
								<taxes_id>
									<list>
										<item>
											<xsl:attribute name="foreach">{$ridtax}</xsl:attribute>
											<content>{$1}</content>
										</item>
									</list>
								</taxes_id>					
							</dict>	
						</list>
					</list>
				</whenc>		
				<whenc test="setpro"> 
					<xsl:attribute name="groupby">{$gtid}</xsl:attribute>
					<xsl:attribute name="class">SERVICIO</xsl:attribute>					
					<xsl:attribute name="tableId">{$gtid}</xsl:attribute>
					<xsl:attribute name="slug">{$descr}</xsl:attribute>					
					<list>
						<par>db</par>	
						<par>uid</par>	
						<par>pwd</par>	
						<par>product.template</par>	
						<par>write</par>						
						<list>				
							<list  >
								<par>{$ridprotmpl}</par>
							</list>							
							<dict>
								<name>{$descr}</name>
								<description>{$descr}</description>																
								<default_code>text:{$skuprod}</default_code>						
								<list_price>{$pvp}</list_price>	
								<wholesale_price>{$preciomayor}</wholesale_price>								
								<categ_id>{$ridcat}</categ_id>
								<standard_price>{$coste}</standard_price>
							</dict>	
						</list>
					</list>
				</whenc>						
			</atom>
		</clone>																															
	</xsl:template>	
		<!--VARIACION
		Dado que cada variacion tiene solo una imagen, que este desactivada (creada desde el producto) no debe frenar que se cree la variante, por eso el activado de imagen no va en where. Tampoco puedo ponerlo en left join de replica_ids imagen porque trataría de crearla en web de nuevo, debe anular la imagen de dynagent, se pone en el select
		-->
		<!--<clone>
			<![CDATA[	
				select 
					case 	
													
							when rvar."id_ERP" is not null and rs."id_ERP" is null then 'newstock'																												
							when rvar."id_ERP" is not null and rs."id_ERP" is not null then 'setvar'								
							else 'NA' end as test,
							
					s.stock_disponible,
					s.stock_reservado,
					rvar.identificador_replicas as idrvarian,		
					rs.identificador_replicas as idrepstock,	
										
					s."tableId" as stocktid,
					g.rdn as skustock,																														
												  
					endpoint."página_web" as urldest,
					endpoint."rdn" as endpointdest,
					ralm.identificador_replicas as locationid,
					case when rs."id_ERP" is null then 'create' else 'write' end as apiaction
					
				from 
					"género" as gconfig																							inner join
					"género" as g 			on gconfig.rdn=substr(g.rdn, 1, 5)													inner join
					stock as s				on(g."tableId"=s.producto)															inner join
					"almacén" as alm 		on 	alm.rdn='001' and 
												alm."tableId"=s."almacén_stock"													inner join
					mi_empresa as m 		on  m."tableId"=g."empresaMI_EMPRESA" and 
												m.rdn='001'	and m.nombre ilike '%CELOP%JOVEN%' and					
												g.rdn ~'^\d{5}(A|\d)\d{4}$'																inner join
																												
					replica_ids as ralm 	on	ralm.clases='UBICACION' and
												ralm."id_ERP"=alm."tableId"::text and
												ralm.destinatario='$ENDPOINT$'  												inner join 
					
					replica_ids as rvar on 	rvar.clases='VARIANTE' and rvar.destinatario='$ENDPOINT$' and
											rvar."id_ERP"=g.rdn																	left join
					replica_ids as rs on 	rs.clases='STOCK' and rs.destinatario='$ENDPOINT$' and
											s."tableId"::text=rs."id_ERP"																									
					,"delegación" as endpoint 																																					
																															
				where 	(s."tableId" in(]]><xsl:value-of select="$stock_new_ids" /><![CDATA[) or 
						g."tableId" in(]]><xsl:value-of select="$g_de_img_id" /><![CDATA[) or 						
						gconfig."tableId" in(]]><xsl:value-of select="$gconfig_de_cat_id" /><![CDATA[) or
						gconfig."tableId" in(
											select gconf2."tableId"														
											
											from "género" as gconf2 												inner join
											"género" as g2 on gconf2.rdn=substr(g2.rdn, 1, 5) 						inner join
											color as c 	on c.rdn='CLP'||substr(g2.rdn, 6, 3)						inner join												
											color as cm	on 'MAG'||c."descripción"=cm.rdn 

											where length(g2.rdn)=10 and length(gconf2.rdn)=5 and cm."tableId" in(]]><xsl:value-of select="$coloridsparam" /><![CDATA[)
						)
						
						
						)  
						and endpoint.rdn='$ENDPOINT$'
						and (rs.activo is null or rs.activo)
						
						and g."descripción" is not null and length(btrim(g."descripción"))>0 and gconfig."descripción" not ilike '%Dropship%' and gconfig."descripción" not ilike '%tarjeta%' and gconfig."descripción" not ilike '%tara%' and 
						s.stock_disponible is not null  
				
						
						order by g.rdn
				]]>																													
			
			<atom  test="newstock">
				<xsl:attribute name="groupby">{$skustock}</xsl:attribute>						
				<xsl:attribute name="url">{$urldest}</xsl:attribute>
				<xsl:attribute name="endpoint">{$endpointdest}</xsl:attribute>
				<xsl:attribute name="tableId">{$stocktid}</xsl:attribute>
									
				<xsl:attribute name="http">POST</xsl:attribute>								
				<xsl:attribute name="class">STOCK</xsl:attribute>	

				<xsl:attribute name="path">xmlrpc/2/object</xsl:attribute>										
				<xsl:attribute name="method">execute_kw</xsl:attribute>					
				
				<xsl:attribute name="new_field_response"></xsl:attribute>													
				<xsl:attribute name="slug">{$skustock}</xsl:attribute>	
				<list>
					<par>db</par>	
					<par>uid</par>	
					<par>pwd</par>	
					<par>stock.quant</par>	
					<par>{$apiaction}</par>
					<list>							
						<dict>
							<location_id>{$locationid}</location_id>
							<product_id>{$idrvarian}</product_id>
							<reserved_quantity>{$stock_reservado}</reserved_quantity>							
							<quantity>{$stock_disponible}</quantity>
						</dict>	
					</list>
				</list>
			</atom>				
		</clone>
			-->

</xsl:stylesheet>
