<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
							  xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no"/>

	<xsl:template match="@*|node()">		
		<xsl:variable name="tipopedido" > 
			<xsl:choose>				
				<xsl:when test="//PEDIDO_DE_CLIENTE/attribute::clp_cod_almacen and string-length(//PEDIDO_DE_CLIENTE/attribute::clp_cod_almacen)>0">PEDIDO_TRASPASO_ALMACENES</xsl:when>
				<xsl:when test="//ALBARÁN-FACTURA_PROVEEDOR">ALBARÁN-FACTURA_PROVEEDOR</xsl:when>
				<xsl:otherwise>PEDIDO_DE_CLIENTE</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tipolinea" > 
			<xsl:choose>		
				<xsl:when test="self::LÍNEA_ARTÍCULOS_FINANCIERA">LÍNEA_ARTÍCULOS_FINANCIERA</xsl:when>
				<xsl:when test="//PEDIDO_DE_CLIENTE/attribute::clp_cod_almacen  and string-length(//PEDIDO_DE_CLIENTE/attribute::clp_cod_almacen)>0">LÍNEA_MATERIA</xsl:when>
				<xsl:otherwise>LÍNEA_ARTÍCULOS_MATERIA</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tipoproducto" > 
			<xsl:choose>		
				<xsl:when test="$tipolinea='LÍNEA_ARTÍCULOS_FINANCIERA'">ARTÍCULO_FINANCIERO</xsl:when>				
				<xsl:otherwise>GÉNERO</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tipocliente"> 
			<xsl:choose>				
				<xsl:when test="parent::node()/attribute::agente='ONLINE DETALLE' or attribute::agente='ONLINE DETALLE' or parent::node()/attribute::agente='OTHERBRAND' or attribute::agente='OTHERBRAND' or attribute::website='vp' or parent::node()/attribute::website='vp'  or attribute::website='ob' or parent::node()/attribute::website='ob'">CLIENTE_VARIOS</xsl:when>						
				<xsl:otherwise>CLIENTE_PARTICULAR</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="centralreserva" > 
			<xsl:choose>				
				<xsl:when test="//PEDIDO_DE_CLIENTE/attribute::reservation='true'">001R</xsl:when>
				<xsl:otherwise>001</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>	
		
		<xsl:choose>
			<xsl:when test="string(node-name(current())) = 'localidad' and string-length(current())>1 and current()!='-' and not(contains(attribute::email,'sample@'))" >
				<LOCALIDAD>					
					<xsl:attribute name="action">createINE</xsl:attribute>
					<xsl:attribute name="property">localidad</xsl:attribute>						
					<xsl:attribute name="rdn" select="upper-case(current())" />
				</LOCALIDAD>
			</xsl:when>
				
			<xsl:when test="string(node-name(current())) = 'provincia' and string-length(current())>0">
				<PROVINCIA>
					<xsl:attribute name="action">createINE</xsl:attribute>
					<xsl:attribute name="property">provincia</xsl:attribute>
					<xsl:attribute name="rdn" select="upper-case(current())"/>												
				</PROVINCIA>
			</xsl:when>
				
			<xsl:when test="string(node-name(current())) = 'país' and string-length(current())>0">
				<PAÍS>
					<xsl:attribute name="action">createINE</xsl:attribute>
					<xsl:attribute name="property">país</xsl:attribute>
					<xsl:attribute name="rdn" select="upper-case(current())" />
					<xsl:if	test="parent::node()/attribute::código_pais">	
						<xsl:attribute name="código_pais"><xsl:value-of select="parent::node()/attribute::código_pais" /></xsl:attribute>
					</xsl:if>
				</PAÍS>
			</xsl:when>					
<!-- PEDIDO  -->	
			<xsl:when test="self::POSITION">
				<ORDEN destination="001">
					<xsl:attribute name="rdn"><xsl:value-of select="concat(attribute::producto,'-',attribute::categoria)" /></xsl:attribute>
					<xsl:attribute name="orden"><xsl:value-of select="attribute::position" /></xsl:attribute>
					<xsl:choose>
						<xsl:when test="attribute::action='new'">	
							<xsl:attribute name="action">createINE</xsl:attribute>
						</xsl:when>
						<xsl:when test="attribute::action='del'">	
							<xsl:attribute name="action">del_object</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="action">set</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</ORDEN>				
			</xsl:when>
			<xsl:when test="self::ALBARÁN-FACTURA_PROVEEDOR"/>
			<xsl:when test="self::PEDIDO_DE_CLIENTE and attribute::codigo and not(//@*[contains(.,'getTemplateFilter')])"><!-- or self::ALBARÁN-FACTURA_PROVEEDOR">	-->
				<clone>
					<![CDATA[	
						select 
							case 	when rdn is null then 'new'									
									else 'set' end as test
											
						from unnest(ARRAY[']]><xsl:value-of select="attribute::codigo" /><![CDATA[']) as cin left join
							 pedido_de_cliente as p on rdn=cin

					]]>
				<xsl:element name="{$tipopedido}">	
					<xsl:choose>				
						<xsl:when test="$tipopedido='PEDIDO_TRASPASO_ALMACENES'">
							<xsl:copy-of select="@*[name(.)!='fecha' and name(.)!='NIF-CIF-VAT' and name(.)!='recargo_de_equivalencia' and name(.)!='estado' and name(.)!='total' and name(.)!='codigo' and name(.)!='descuento' and name(.)!='cliente' and name(.)!='action' and name(.)!='observaciones' and name(.)!='clp_cod_almacen' and name(.)!='pagado' and name(.)!='importe']"/>	
							<xsl:attribute name="destination"><xsl:value-of select="concat('001,',attribute::clp_cod_almacen)" /></xsl:attribute>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="@*[name(.)!='rectifica_a' and name(.)!='pagado' and name(.)!='proveedor' and name(.)!='website' and name(.)!='recargo_contrareembolso' and  name(.)!='recargo_de_equivalencia' and name(.)!='estado' and name(.)!='total' and name(.)!='NIF-CIF-VAT' and name(.)!='codigo' and name(.)!='descuento' and name(.)!='cliente' and name(.)!='action' and name(.)!='observaciones']"/>	
							<xsl:attribute name="destination">001</xsl:attribute>					
						</xsl:otherwise>
					</xsl:choose>
									
					<xsl:if	test="attribute::action='new' and not(attribute::fecha)">	
						<xsl:attribute name="fecha"><xsl:value-of select="current-date()" /></xsl:attribute>
					</xsl:if>

					<xsl:if	test="attribute::fecha">	
						<xsl:attribute name="fecha"><xsl:value-of select="replace(replace(attribute::fecha,'\.','/'),'/(\d)/','/0$1/')" /></xsl:attribute>
					</xsl:if>
					
					<xsl:if	test="attribute::total and attribute::total!='' and $tipopedido!='PEDIDO_TRASPASO_ALMACENES'">	
						<xsl:attribute name="importe"><xsl:value-of select="attribute::total" /></xsl:attribute>
					</xsl:if>

					<xsl:if	test="attribute::pagado and attribute::pagado!='' and number(attribute::pagado)!=0 and attribute::total and attribute::total!='' and $tipopedido!='PEDIDO_TRASPASO_ALMACENES'">	
						<xsl:attribute name="importe_no_anticipado"><xsl:value-of select="number(attribute::total)-number(attribute::pagado)" /></xsl:attribute>
					</xsl:if>
					
					<xsl:if	test="attribute::recargo_de_equivalencia and string-length(attribute::recargo_de_equivalencia)>0 and $tipopedido!='PEDIDO_TRASPASO_ALMACENES'">	
						<xsl:attribute name="recargo"><xsl:value-of select="attribute::recargo_de_equivalencia" /></xsl:attribute>
					</xsl:if>
					
					<xsl:attribute name="rdn">
						<xsl:value-of select="attribute::codigo" />
					</xsl:attribute>	

					<xsl:attribute name="coherente">true</xsl:attribute>	
					
					<xsl:choose>				
						<xsl:when	test="attribute::action='new'">
							<xsl:attribute name="cantidad_total"><xsl:value-of select="sum(//LÍNEA_ARTÍCULOS_MATERIA/attribute::cantidad)" /></xsl:attribute>						
							<xsl:if test="$tipopedido='PEDIDO_DE_CLIENTE'">
								<xsl:attribute name="emitido">false</xsl:attribute>
								<xsl:attribute name="albaranado">false</xsl:attribute>
							</xsl:if>								
							<xsl:if test="$tipopedido='PEDIDO_TRASPASO_ALMACENES'">								
								<xsl:attribute name="servido">false</xsl:attribute>
							</xsl:if>								
							<xsl:attribute name="action">new</xsl:attribute>
						</xsl:when>
						<xsl:when test="$tipopedido='ALBARÁN-FACTURA_PROVEEDOR' and not(attribute::action)">
							<xsl:attribute name="action">new</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:attribute name="action" select="attribute::action"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:copy-of select="//memo"/>
					
					<xsl:if test="attribute::pagado or attribute::observaciones or attribute::urlticket or attribute::urlrecibo or attribute::rectifica_a">
							<xsl:variable name="observ" ><xsl:value-of select="attribute::urlticket" /></xsl:variable> 							
							<!--<xsl:if test="attribute::urlticket"><xsl:variable name="observ" ><xsl:value-of select="attribute::urlticket" /></xsl:variable> </xsl:if>-->							
						<memo action="add" property="observaciones_internas">
							<xsl:element name="value">
								<xsl:value-of select="	
											concat(
											(if(attribute::rectifica_a) then concat('RMA sobre pedido:',attribute::rectifica_a) else ''),	
											(if(attribute::observaciones) then ' Coment:' else ''),attribute::observaciones,(if(attribute::observaciones) then '&#13;' else ''),
											(if(attribute::urlticket) then 'TICKET ' else ''),attribute::urlticket,(if(attribute::urlticket and contains(attribute::urlticket,'jpg')) then 'TICKET_' else ''),(if(attribute::urlticket) then '&#13;' else ''),
											(if(attribute::urlrecibo) then 'RECIBO ' else ''),attribute::urlrecibo,(if(attribute::urlrecibo and contains(attribute::urlrecibo,'jpg')) then 'RECIBO_' else '')
											)" />
							</xsl:element>
						</memo>			
					</xsl:if>
					
					<MI_EMPRESA property="mi_empresa" action="set" rdn="006"/>	
					
					<xsl:if test="child::CARGO[@tipo_cargo = 'Comision_Contrareembolso']">
						<memo action="new" property="observaciones_a_imprimir">
							<xsl:element name="value">CONTRAREEMBOLSO</xsl:element>
						</memo>			
					</xsl:if>
					
					<xsl:if test="attribute::transportista">
						<TRANSPORTISTA action="createINE" property="transportista" destination="001">
							<xsl:attribute name="rdn"><xsl:value-of select="attribute::transportista" /></xsl:attribute>	
						</TRANSPORTISTA>		
					</xsl:if>
					
					<xsl:if test="attribute::descuento and attribute::descuento!=0 and $tipopedido='PEDIDO_DE_CLIENTE'">
						<xsl:element name="DESCUENTO_GLOBAL">
							<xsl:attribute name="action">new</xsl:attribute>
							<xsl:attribute name="property">descuentos_globales</xsl:attribute>
							<xsl:attribute name="destination">001</xsl:attribute>	
							<xsl:attribute name="porcentaje"><xsl:value-of select="attribute::descuento" /></xsl:attribute>
							<xsl:attribute name="rdn"><xsl:value-of select="attribute::codigo" /></xsl:attribute>	
						</xsl:element>		
					</xsl:if>	
					<xsl:if test="attribute::proveedor and $tipopedido='ALBARÁN-FACTURA_PROVEEDOR'">
						<xsl:element name="PROVEEDOR">
							<xsl:attribute name="action">new</xsl:attribute>
							<xsl:attribute name="property">proveedor</xsl:attribute>
							<xsl:attribute name="destination">001</xsl:attribute>								
							<xsl:attribute name="rdn"><xsl:value-of select="attribute::proveedor" /></xsl:attribute>	
						</xsl:element>		
					</xsl:if>			
					<DELEGACIÓN property="delegación" rdn="001" action="set">
						<xsl:choose>
							<xsl:when test="$tipopedido='PEDIDO_TRASPASO_ALMACENES'">
								<xsl:attribute name="destination"><xsl:value-of select="concat('001,',attribute::clp_cod_almacen)" /></xsl:attribute>	
							</xsl:when>
							<xsl:otherwise>	
								<xsl:attribute name="destination">001</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</DELEGACIÓN>					
					<xsl:choose>				
						<xsl:when test="$tipopedido='PEDIDO_TRASPASO_ALMACENES'">
							<xsl:if test="attribute::estado">
								<ESTADO action="set"  property="estado">
									<xsl:attribute name="rdn"><xsl:value-of select="attribute::estado" /></xsl:attribute>	
								</ESTADO>
							</xsl:if>

							<ALMACÉN property="origen" rdn="001" action="set">
								<xsl:attribute name="destination"><xsl:value-of select="concat('001,',attribute::clp_cod_almacen)" /></xsl:attribute>		
							</ALMACÉN>
							<ALMACÉN property="destino" action="set">
								<xsl:attribute name="destination"><xsl:value-of select="if(attribute::clp_cod_almacen) then concat('001,',attribute::clp_cod_almacen) else '001'" /></xsl:attribute>							
								<xsl:attribute name="rdn"><xsl:value-of select="attribute::clp_cod_almacen" /></xsl:attribute>
								<!--No reserva en este momento para evitar el error de redondeo que supone el precio a dos digitos en la web, como tampoco se asigna la delegación
								no va a computar contribucion inicial en la regla CELOP:CORNER: STOCK RESERVADO ALMACEN que intencionadamente exiga que exista.
								Para forzar actualizar el credito en la web hay que crear y eliminar un pedido que contrubuya con un valor de PVP distinto de cero
								-->
								<xsl:if test="not(attribute::estado='Anulado') and not(attribute::estado='ErrorPago')">	
									<xsl:attribute name="stock_reservado"><xsl:value-of select="concat('+',-1*sum(//LÍNEA_ARTÍCULOS_MATERIA/attribute::importe_linea))" /></xsl:attribute>
									<xsl:attribute name="stock_disponible"><xsl:value-of select="concat('+',sum(//LÍNEA_ARTÍCULOS_MATERIA/attribute::importe_linea))" /></xsl:attribute>							
								</xsl:if>
							</ALMACÉN>
						</xsl:when>
						<xsl:when test="$tipopedido='ALBARÁN-FACTURA_PROVEEDOR'">							
							<ALMACÉN property="destino" action="set" rdn="001" destination="001"/>
						</xsl:when>
						
						<xsl:when test="$tipopedido='PEDIDO_DE_CLIENTE'">	
							<whenc test="new">
								<xsl:if test="not(attribute::estado) and attribute::action='new'">
									<ESTADO action="createINE" property="estado">
										<xsl:attribute name="rdn">
											<xsl:choose>									
												<xsl:when test="$centralreserva='001R'">Reserva</xsl:when>
												<xsl:when test="starts-with(attribute::codigo,'RMA')">Pendiente_abono</xsl:when>							
												<xsl:otherwise>Planificado</xsl:otherwise>	
											</xsl:choose>
										</xsl:attribute>	
									</ESTADO>							
								</xsl:if>
								<xsl:if test="attribute::estado">
									<ESTADO action="createINE" property="estado">
										<xsl:attribute name="rdn"><xsl:value-of select="attribute::estado" /></xsl:attribute>		
									</ESTADO>
								</xsl:if>

								<AGENTE_COMERCIAL_FIJO property="agente_comercial" action="set">
									<xsl:choose>
										<xsl:when test="attribute::agente">
											<xsl:attribute name="rdn"><xsl:value-of select="attribute::agente" /></xsl:attribute>		
										</xsl:when>
										<xsl:otherwise>	
											<xsl:attribute name="rdn">WEB</xsl:attribute>	
										</xsl:otherwise>	
									</xsl:choose>
								</AGENTE_COMERCIAL_FIJO>
								<ALMACÉN property="origen" action="set">
									<xsl:attribute name="destination"><xsl:value-of select="if(attribute::almacen) then concat('001,',attribute::almacen) else $centralreserva" /></xsl:attribute>		
									<xsl:attribute name="rdn"><xsl:value-of select="$centralreserva" /></xsl:attribute>
								</ALMACÉN>
								<xsl:if test="attribute::action='new' and not(./CLIENTE_EMPRESA) and not(./CLIENTE_PARTICULAR) and not(./CLIENTE_VARIOS)">		
									<CLIENTE_VARIOS action="set" rdn="0" property="cliente"/>
								</xsl:if>
							</whenc>
						</xsl:when>	
					</xsl:choose>						
					<xsl:apply-templates/>
				</xsl:element>		
				<xsl:if test="not(attribute::estado='Anulado') and not(attribute::estado='ErrorPago') and not(starts-with(attribute::codigo,'RMA'))">
					<xsl:if test="$tipopedido='PEDIDO_TRASPASO_ALMACENES'">
						<xsl:for-each select="./LÍNEA_ARTÍCULOS_MATERIA">
							<xsl:call-template name="stock">
								<xsl:with-param name="central" select = "'001'" />							
								<xsl:with-param name="signoreserva" select = "'1'" />
								<xsl:with-param name="soloreservar" select = "'true'" />
							</xsl:call-template>
							<xsl:call-template name="stock">
								<xsl:with-param name="central" select = "parent::node()/attribute::clp_cod_almacen" />							
								<xsl:with-param name="signoreserva" select = "'-1'" />
								<xsl:with-param name="soloreservar" select = "'true'" />
							</xsl:call-template>
						</xsl:for-each>				
					</xsl:if>
					<xsl:if test="$tipopedido='PEDIDO_DE_CLIENTE' and $centralreserva!='001R' and not(starts-with(attribute::codigo,'RMA'))">
						<xsl:for-each select="./LÍNEA_ARTÍCULOS_MATERIA">
							<xsl:call-template name="stock">
								<xsl:with-param name="central" select = "$centralreserva" />	
								<xsl:with-param name="signoreserva" select = "'1'" />
								<xsl:with-param name="soloreservar" select = "'true'" />
							</xsl:call-template>
						</xsl:for-each>				
					</xsl:if>
				</xsl:if>
				<xsl:if test="$tipopedido='PEDIDO_DE_CLIENTE' and $centralreserva!='001R' and not(starts-with(attribute::codigo,'RMA'))">
					<VENTA_HISTORICO action="new" rdn="&amp;index&amp;" destination="001">	
						<xsl:attribute name="fecha"><xsl:value-of select="current-date()" /></xsl:attribute>						
						<xsl:attribute name="causa">
							<xsl:choose>
								<xsl:when test="attribute::action='new'">CREACION</xsl:when>
								<xsl:when test="attribute::action='set'">MODIFIC</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="fase">PEDIDO_DE_CLIENTE</xsl:attribute>						
						<xsl:if test="attribute::total"><xsl:attribute name="importe"><xsl:value-of select="attribute::total" /></xsl:attribute></xsl:if>
						<xsl:attribute name="campo_aux1"><xsl:value-of select="attribute::total" /></xsl:attribute>
						<AGENTE_COMERCIAL_FIJO property="agente_comercial" action="set" rdn="WEB"/>
						<xsl:element name="{$tipocliente}">					
							<xsl:attribute name="rdn">
								<xsl:value-of select="./*[contains(name(),'CLIENTE')]/attribute::codigo" />
							</xsl:attribute>
							<xsl:attribute name="action">set</xsl:attribute>										
							<xsl:attribute name="property">cliente</xsl:attribute>	
							<xsl:attribute name="destination">001</xsl:attribute>							
						</xsl:element>
						<PEDIDO_DE_CLIENTE property="ámbito" action="set" >
							<xsl:attribute name="rdn">
								<xsl:value-of select="attribute::codigo" />
							</xsl:attribute>
						</PEDIDO_DE_CLIENTE>							
					</VENTA_HISTORICO>
				</xsl:if>
			</clone>
			</xsl:when>
			
			<xsl:when test="self::DESCUENTO_GLOBAL and $tipopedido='PEDIDO_DE_CLIENTE'">	
				<DESCUENTO_GLOBAL>
					<xsl:copy-of select="@*[name(.)!='action' and name(.)!='tipo_iva' and name(.)!='tipo_cargo' and name(.)!='base' and name(.)!='importe']"/>	
					<xsl:attribute name="action">new</xsl:attribute>
					<xsl:attribute name="property">descuentos_globales</xsl:attribute>
					<xsl:attribute name="destination">001</xsl:attribute>							
					<xsl:attribute name="rdn"><xsl:value-of select="parent::node()/attribute::codigo" /></xsl:attribute>
					
					<xsl:choose>				
						<xsl:when test="$tipocliente='CLIENTE_VARIOS' and $tipolinea='LÍNEA_ARTÍCULOS_MATERIA' and attribute::importe and attribute::importe!=0">
							<xsl:attribute name="importe"><xsl:value-of select="round((number(attribute::importe) div 1.21)*10000) div 10000" /></xsl:attribute>
						</xsl:when>
						<xsl:when test="$tipolinea='LÍNEA_ARTÍCULOS_MATERIA' and attribute::porcentaje and attribute::porcentaje!=0">
							<xsl:attribute name="porcentaje"><xsl:value-of select="attribute::porcentaje" /></xsl:attribute>
						</xsl:when>						
						<xsl:when test="$tipolinea='LÍNEA_ARTÍCULOS_MATERIA' and attribute::importe and attribute::importe!=0">
							<xsl:attribute name="importe"><xsl:value-of select="attribute::importe" /></xsl:attribute>
						</xsl:when>						
					</xsl:choose>
					<TIPO_DESCUENTO_GLOBAL property="tipo_descuento_global" action="createINE" rdn="WEB"/>		
					
				</DESCUENTO_GLOBAL>
			</xsl:when>

			<xsl:when test="self::LÍNEA_ARTÍCULOS_MATERIA">	<!-- comento or self::LÍNEA_ARTÍCULOS_FINANCIERA-->
				<xsl:element name="{$tipolinea}">			
					<xsl:choose>				
						<xsl:when test="$tipolinea='LÍNEA_MATERIA'">
							<xsl:copy-of select="@*[name(.)!='fecha_estimada_entrega' and name(.)!='estado' and name(.)!='razon' and name(.)!='resolucion' and name(.)!='precio' and name(.)!='precio_iva_incluido' and name(.)!='codigo' and name(.)!='producto' and name(.)!='número' and name(.)!='talla' and name(.)!='color' and name(.)!='tipo_iva']"/>
							<xsl:attribute name="destination"><xsl:value-of select="concat('001,',parent::node()/attribute::clp_cod_almacen)" /></xsl:attribute>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="@*[name(.)!='fecha_estimada_entrega' and name(.)!='estado' and name(.)!='razon' and name(.)!='resolucion' and name(.)!='precio' and name(.)!='pvp_iva_incluido' and name(.)!='nombre_color' and name(.)!='codigo' and name(.)!='producto' and name(.)!='número' and name(.)!='talla' and name(.)!='color' and name(.)!='tipo_iva']"/>
							<xsl:attribute name="destination">001</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>				

					<xsl:if test="not(attribute::action)">
						<xsl:attribute name="action">new</xsl:attribute>
					</xsl:if>
									
					<xsl:attribute name="property">línea</xsl:attribute>
									
					<xsl:variable name="detalle" select="concat(attribute::producto,attribute::color,attribute::talla)" />

					<xsl:if test="attribute::precio and string-length(attribute::precio) and $tipocliente!='CLIENTE_VARIOS' and $tipolinea='LÍNEA_ARTÍCULOS_MATERIA'">
						<xsl:attribute name="precio"><xsl:value-of select="attribute::precio" /></xsl:attribute>
					</xsl:if>			
					<xsl:if test="$tipocliente='CLIENTE_VARIOS' and $tipolinea='LÍNEA_ARTÍCULOS_MATERIA' and attribute::precio_iva_incluido">
						<xsl:attribute name="precio"><xsl:value-of select="round((number(attribute::precio_iva_incluido) div 1.21)*10000) div 10000" /></xsl:attribute>
					</xsl:if>					

					<xsl:if test="$tipolinea='LÍNEA_ARTÍCULOS_MATERIA' and attribute::fecha_estimada_entrega and matches(attribute::fecha_estimada_entrega,'\d{2,2}/\d{2,2}/\d{4,4}')">
						<xsl:attribute name="fecha_estimada_entrega"><xsl:value-of select="replace(attribute::fecha_estimada_entrega,'.*(\d{2,2}/\d{2,2}/\d{4,4}).*','$1')" /></xsl:attribute>
					</xsl:if>	
					
					<!--debo utilizar indice de linea para que sea un rdn numerico (exigido por Navision) y permita gestionar modificaciones de linea-->
					<xsl:attribute name="rdn">
						<xsl:value-of select="concat(parent::node()/attribute::codigo,'#',if(matches(lower-case(attribute::concepto),'^reserva\s*\d+')) then replace(lower-case(attribute::concepto),'reserva\s*','') else attribute::producto)" />
					</xsl:attribute>												
													
					<xsl:if test="parent::node()/attribute::fecha">
						<xsl:attribute name="fecha"><xsl:value-of select="replace(replace(parent::node()/attribute::fecha,'\.','/'),'/(\d)/','/0$1/')" /></xsl:attribute>						
					</xsl:if>
			
					<xsl:choose>				
						<xsl:when test="attribute::color and attribute::talla">						
							<xsl:attribute name="clave_producto">
								<xsl:value-of select="$detalle" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:attribute name="clave_producto" select="attribute::producto"/>

						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="attribute::action='new'">
						<xsl:variable name="reservado" > 
							<xsl:choose>		
								<xsl:when test="not(parent::node()/attribute::estado='Anulado') and not(parent::node()/attribute::estado='ErrorPago') and not(starts-with(parent::node()/attribute::codigo,'RMA')) and $tipopedido!='ALBARÁN-FACTURA_PROVEEDOR' and $centralreserva!='001R' ">true</xsl:when>				
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>				
							<xsl:when	test="$tipolinea='LÍNEA_MATERIA'">							
								<xsl:attribute name="servido">false</xsl:attribute>								
								<xsl:attribute name="reservado"><xsl:value-of select="$reservado"/></xsl:attribute>								
							</xsl:when>
							<xsl:when	test="$tipolinea='LÍNEA_ARTÍCULOS_FINANCIERA'">		
								<xsl:attribute name="precio">0.8265</xsl:attribute>
								<xsl:attribute name="precio_iva_incluido">1</xsl:attribute>
								<xsl:attribute name="cantidad"><xsl:value-of select="attribute::importe_con_iva" /></xsl:attribute>							
								<MI_EMPRESA property="mi_empresa" action="set" rdn="006"/>
							</xsl:when>
							<xsl:when	test="$tipolinea='LÍNEA_ARTÍCULOS_MATERIA'">	
								<xsl:attribute name="reservado"><xsl:value-of select="$reservado"/></xsl:attribute>								
								<xsl:attribute name="albaranado">false</xsl:attribute>
								<MI_EMPRESA property="mi_empresa" action="set" rdn="006"/>
							</xsl:when>
						</xsl:choose>
					</xsl:if>								
					
					<xsl:element name="{$tipoproducto}">
						<xsl:attribute name="action">createINE</xsl:attribute>						
						<xsl:attribute name="property">producto</xsl:attribute>					
						<xsl:choose>				
							<xsl:when test="attribute::color and attribute::talla">						
								<xsl:attribute name="rdn">
									<xsl:value-of select="$detalle" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="rdn" select="attribute::producto"/>								
							</xsl:otherwise>
						</xsl:choose>	
						<xsl:if test="not(parent::node()/attribute::estado='Anulado') and not(parent::node()/attribute::estado='ErrorPago')"><!--central reserva ahora tiene prioridad ventas 0-->						
							<xsl:choose>				
								<xsl:when test="$tipopedido='ALBARÁN-FACTURA_PROVEEDOR'">
									<xsl:attribute name="stock_disponible" select="concat('+',attribute::cantidad)"/>
									<xsl:attribute name="stock_total" select="concat('+',attribute::cantidad)"/>
								</xsl:when>
								<xsl:when test="$centralreserva!='001R'"><!--  central reserva no reserva en stock total por tener prioridad cero, pero si en el proio stock -->
									<xsl:attribute name="stock_reservado" select="concat('+',attribute::cantidad)"/> 
									<xsl:attribute name="stock_disponible" select="concat('+',-1*attribute::cantidad)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						<CATÁLOGO>
							<xsl:attribute name="action">set</xsl:attribute>
							<xsl:attribute name="property">catálogo</xsl:attribute>
							<xsl:attribute name="rdn">Catálogo_Compras</xsl:attribute>
						</CATÁLOGO>
						<CATÁLOGO>
							<xsl:attribute name="action">set</xsl:attribute>
							<xsl:attribute name="property">catálogo</xsl:attribute>
							<xsl:attribute name="rdn">Catálogo_Ventas</xsl:attribute>
						</CATÁLOGO>	
						<MI_EMPRESA property="empresa" action="set" rdn="006"/>							
					</xsl:element>

					
					<xsl:if test="attribute::tipo_iva and $tipopedido!='PEDIDO_TRASPASO_ALMACENES' and not(parent::node()/attribute::agente='DROPSHIPPING')"><!-- cuando es drop debe quedar vacio para que mande datos de cliente-->
						<TIPO_IVA>	
							<xsl:attribute name="action">set</xsl:attribute>
							<xsl:attribute name="property">iva</xsl:attribute>
							<xsl:choose>
								<xsl:when test="number(attribute::porciento_iva)=21">
									<xsl:attribute name="rdn">General21</xsl:attribute>
								</xsl:when>
								<xsl:when test="number(attribute::porciento_iva)=0 and parent::node()/CLIENTE_EMPRESA[contains(@régimen_iva,'comunit')]">
									<xsl:attribute name="rdn">Exento_Intracomunitario</xsl:attribute>
								</xsl:when>
								<xsl:when test="number(attribute::porciento_iva)=0">
									<xsl:attribute name="rdn">Exento</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="rdn"><xsl:value-of select="attribute::tipo_iva" /></xsl:attribute>						
								</xsl:otherwise>	
							</xsl:choose>					
						</TIPO_IVA>
					</xsl:if>
					<xsl:if test="attribute::estado and string-length(attribute::estado)>0">	
						<ESTADO action="createINE" property="estado">
							<xsl:attribute name="rdn"><xsl:value-of select="attribute::estado" /></xsl:attribute>						
						</ESTADO>
					</xsl:if>	
					<xsl:choose>				
						<xsl:when test="attribute::razon and attribute::resolucion">					
							<memo action="add" property="concepto">
								<xsl:element name="value">
									<xsl:value-of select="concat(attribute::razon,'-',attribute::resolucion)" />
								</xsl:element>
							</memo>	
						</xsl:when>
						<xsl:when test="attribute::precompra='true'">					
							<memo action="add" property="concepto">
								<xsl:element name="value">Precompra</xsl:element>
							</memo>	
						</xsl:when>						
					</xsl:choose>
				</xsl:element>																		
			</xsl:when>		
			
			<xsl:when test="self::CARGO and $tipopedido='PEDIDO_DE_CLIENTE'">	
				<xsl:copy>
					<xsl:copy-of select="@*[name(.)!='action' and name(.)!='tipo_iva' and name(.)!='tipo_cargo' and name(.)!='base' and name(.)!='importe']"/>	
					<xsl:choose>				
						<xsl:when	test="attribute::action='new'">
							<xsl:attribute name="action">createINE</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:attribute name="action" select="attribute::action"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="destination">001</xsl:attribute>
					<xsl:attribute name="property">cargos</xsl:attribute>								
					<xsl:attribute name="rdn"><xsl:value-of select="concat(parent::node()/attribute::codigo,'#',attribute::tipo_cargo)" /></xsl:attribute>					
					<xsl:if test="not(attribute::action)">
						<xsl:attribute name="action">new</xsl:attribute>		
					</xsl:if>
					
					<xsl:choose>	
						<xsl:when test="attribute::importe and string-length(attribute::importe)>0">
							<xsl:attribute name="importe">
								<xsl:value-of select="number(attribute::importe)*100 div (100 + number(attribute::porciento_iva))" />
							</xsl:attribute>	
						</xsl:when>					
						<xsl:when test="attribute::base and string-length(attribute::base)>0">
							<xsl:attribute name="importe">
								<xsl:value-of select="attribute::base" />
							</xsl:attribute>	
						</xsl:when>
					</xsl:choose>					
					<xsl:if test="attribute::tipo_cargo">
						<TIPO_CARGO>							
							<xsl:attribute name="action">createINE</xsl:attribute>
							<xsl:attribute name="property">tipo_cargo</xsl:attribute>
							<xsl:attribute name="rdn"><xsl:value-of select="attribute::tipo_cargo" /></xsl:attribute>						
						</TIPO_CARGO>
					</xsl:if>

					<xsl:if test="attribute::porciento_iva">
						<TIPO_IVA>	
							<xsl:attribute name="action">set</xsl:attribute>
							<xsl:attribute name="property">iva</xsl:attribute>
							<xsl:choose>
								<xsl:when test="number(attribute::porciento_iva)=21">
									<xsl:attribute name="rdn">General21</xsl:attribute>
								</xsl:when>
								<xsl:when test="number(attribute::porciento_iva)=0 and parent::node()/CLIENTE_EMPRESA[contains(@régimen_iva,'comunit')]">
									<xsl:attribute name="rdn">Exento_Intracomunitario</xsl:attribute>
								</xsl:when>
								<xsl:when test="number(attribute::porciento_iva)=0">
									<xsl:attribute name="rdn">Exento</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="rdn"><xsl:value-of select="attribute::tipo_iva" /></xsl:attribute>						
								</xsl:otherwise>	
							</xsl:choose>					
						</TIPO_IVA>
					</xsl:if>
					
				</xsl:copy>																		
			</xsl:when>													
			
			<xsl:when test="$tipopedido='PEDIDO_DE_CLIENTE' and self::DIRECCIÓN">	
				<xsl:copy>
					<xsl:copy-of select="@*[name(.)!='id_node' and name(.)!='direccion_entrega' and name(.)!='código_pais' and name(.)!='codigo_postal' and  name(.)!='receptor' and name(.)!='telefono' and  name(.)!='rdn' and name(.)!='localidad' and name(.)!='provincia' and name(.)!='país' and name(.)!='dirección_entrega']"/>	
					<xsl:attribute name="property">dirección_envío</xsl:attribute>
					<xsl:attribute name="rdn"><xsl:value-of select="concat(parent::node()/attribute::codigo,'#PEDIDOCLIENTE')" /></xsl:attribute>	
					
					<xsl:if test="attribute::telefono">		
						<xsl:attribute name="teléfono"><xsl:value-of select="attribute::telefono"/></xsl:attribute>
					</xsl:if>

					<xsl:if test="attribute::receptor">		
						<xsl:attribute name="receptor"><xsl:value-of select="substring(attribute::receptor,1,100)"/></xsl:attribute>
					</xsl:if>
					
					
					<!-- si destino clientes fuera diferente -->
					<xsl:choose>				
						<xsl:when test="parent::PEDIDO_DE_CLIENTE">						
							<xsl:attribute name="destination">001</xsl:attribute>	
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="destination">001,060,061,062</xsl:attribute>	
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>				
						<xsl:when	test="attribute::action='new' or not(attribute::action)">
							<xsl:attribute name="action">createINE</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:attribute name="action" select="attribute::action"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="attribute::direccion_entrega">
						<xsl:attribute name="dirección"><xsl:value-of select="substring(attribute::direccion_entrega,1,100)" /></xsl:attribute>		
					</xsl:if>
					
					<xsl:if test="attribute::codigo_postal">		
							<xsl:attribute name="código_postal"><xsl:value-of select="attribute::codigo_postal"/></xsl:attribute>
					</xsl:if>
					
					<!--<xsl:if test="parent::PEDIDO_DE_CLIENTE">-->
						<xsl:apply-templates select="@*"/>										
						<xsl:apply-templates/>					
				</xsl:copy>
			</xsl:when>
			<!--
			<xsl:when test="self::COBRO_ANTICIPO and attribute::importe!='' and not(number(attribute::importe)=0)">
				<xsl:copy>				
					<xsl:copy-of select="@*[name(.)!='medio_de_pago' and name(.)!='action']"/>
					<xsl:choose>				
						<xsl:when	test="attribute::action='new' or not(attribute::action)">
							<xsl:attribute name="action">createINE</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:attribute name="action" select="attribute::action"/>
						</xsl:otherwise>
					</xsl:choose>					
					<xsl:attribute name="property">cobro_anticipo</xsl:attribute>													
					
					<xsl:attribute name="rdn">&amp;index&amp;</xsl:attribute>	
					<xsl:attribute name="destination">001</xsl:attribute>						
					<xsl:attribute name="concepto"><xsl:value-of select="attribute::medio_de_pago" /></xsl:attribute>
					
					<xsl:if test="not(attribute::action)">
						<xsl:attribute name="action">new</xsl:attribute>		
					</xsl:if>
					
					
					
					<MI_EMPRESA property="mi_empresa" action="set" rdn="001"/>
					<xsl:if test="attribute::medio_de_pago">
						<TIPO_PAGO>
							<xsl:attribute name="action">createINE</xsl:attribute>
							<xsl:attribute name="property">medio_de_pago</xsl:attribute>
							<xsl:attribute name="rdn"><xsl:value-of select="attribute::medio_de_pago" /></xsl:attribute>						
						</TIPO_PAGO>
					</xsl:if>
					<xsl:if test=".//*[contains(name(),'CLIENTE')]/attribute::codigo">
						<xsl:element name="{$tipocliente}">					
							<xsl:attribute name="rdn">
								<xsl:value-of select=".//*[contains(name(),'CLIENTE')]/attribute::codigo" />
							</xsl:attribute>
							<xsl:attribute name="action">set</xsl:attribute>										
							<xsl:attribute name="property">cliente</xsl:attribute>	
							<xsl:attribute name="deuda" select="concat('+-',attribute::importe)"/>	
							<xsl:attribute name="destination">001</xsl:attribute>							
						</xsl:element>
					</xsl:if>
					<CAJA property="caja_entrada" action="set" rdn="001"/>
					
				</xsl:copy>	

			</xsl:when>-->
			
			<xsl:when test="$tipopedido='PEDIDO_DE_CLIENTE' and (self::PAGO_ADELANTADO or self::A_LA_ENTREGA) and not(number(attribute::importe)=0)">	
				<xsl:copy>				
					<xsl:copy-of select="@*[name(.)!='medio_de_pago' and name(.)!='action']"/>
					<xsl:choose>				
						<xsl:when	test="attribute::action='new' or not(attribute::action)">
							<xsl:attribute name="action">createINE</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:attribute name="action" select="attribute::action"/>
						</xsl:otherwise>
					</xsl:choose>					
					<xsl:attribute name="property">forma_pago</xsl:attribute>	
					<!--utilizo indice para sea numerico como exige Navision, y asi permitir cambios posteriores en facturas existentes. No puedo usar ido negativo porque lo desconozco. InstanceService.SetLocalIdos lo resuelve-->
					<xsl:attribute name="rdn"><xsl:value-of select="concat(parent::node()/attribute::codigo,'#',attribute::medio_de_pago)" /></xsl:attribute>				
					<xsl:attribute name="destination">001</xsl:attribute>						
					<xsl:attribute name="descripción"><xsl:value-of select="attribute::medio_de_pago" /></xsl:attribute>
					<xsl:if test="not(attribute::action)">
						<xsl:attribute name="action">new</xsl:attribute>		
					</xsl:if>
					<xsl:attribute name="porcentaje">100</xsl:attribute>
					<xsl:if test="attribute::medio_de_pago">
						<TIPO_PAGO>
							<xsl:attribute name="action">set</xsl:attribute>
							<xsl:attribute name="property">medio_de_pago</xsl:attribute>
							<xsl:attribute name="rdn"><xsl:value-of select="attribute::medio_de_pago" /></xsl:attribute>						
						</TIPO_PAGO>
					</xsl:if>
				</xsl:copy>		
				<!--<xsl:if test="not(parent::node()/child::COBRO_ANTICIPO) and (attribute::medio_de_pago='Tarjeta_crédito' or attribute::medio_de_pago='Paypal')">	
					<COBRO_ANTICIPO>				
						<xsl:copy-of select="@*[name(.)!='medio_de_pago' and name(.)!='action']"/>
						<xsl:choose>				
							<xsl:when	test="attribute::action='new' or not(attribute::action)">
								<xsl:attribute name="action">createINE</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>							
								<xsl:attribute name="action" select="attribute::action"/>
							</xsl:otherwise>
						</xsl:choose>					
						<xsl:attribute name="property">cobro_anticipo</xsl:attribute>													
						
						<xsl:attribute name="rdn">&amp;index&amp;</xsl:attribute>	
						<xsl:attribute name="destination">001</xsl:attribute>						
						<xsl:attribute name="concepto"><xsl:value-of select="attribute::medio_de_pago" /></xsl:attribute>
						<xsl:attribute name="fecha"><xsl:value-of select="parent::node()/attribute::fecha" /></xsl:attribute>	
						<xsl:if test="not(attribute::action)">
							<xsl:attribute name="action">new</xsl:attribute>		
						</xsl:if>
						
						<xsl:attribute name="importe"><xsl:value-of select="parent::node()/attribute::total"/></xsl:attribute>
						
						<MI_EMPRESA property="mi_empresa" action="set" rdn="001"/>
						<xsl:if test="attribute::medio_de_pago">
							<TIPO_PAGO>
								<xsl:attribute name="action">createINE</xsl:attribute>
								<xsl:attribute name="property">medio_de_pago</xsl:attribute>
								<xsl:attribute name="rdn"><xsl:value-of select="attribute::medio_de_pago" /></xsl:attribute>						
							</TIPO_PAGO>
						</xsl:if>
						<xsl:element name="{$tipocliente}">					
							<xsl:attribute name="rdn">
								<xsl:value-of select="..//*[contains(name(),'CLIENTE')]/attribute::codigo" />
							</xsl:attribute>
							<xsl:attribute name="action">set</xsl:attribute>										
							<xsl:attribute name="property">cliente</xsl:attribute>	
							<xsl:attribute name="destination">001</xsl:attribute>							
						</xsl:element>					
					</COBRO_ANTICIPO>
				</xsl:if>-->
			</xsl:when>			
			
			<xsl:when test="$tipopedido='PEDIDO_DE_CLIENTE' and (self::CLIENTE_EMPRESA or self::CLIENTE_PARTICULAR) and not(contains(attribute::nombre,'http')) and not(contains(attribute::provincia,'http')) and not(contains(attribute::email,'sample@'))">
				<clone>
					<![CDATA[	
						select 
							case 	when rdn is null then 'new'
									when activo is  null or not activo then 'set' 
									else 'NA' end as test
											
						from 
							unnest(ARRAY[']]><xsl:value-of select="attribute::codigo" /><![CDATA[']) as cin left join
							]]> <xsl:value-of select="$tipocliente"/><![CDATA[ as c	on cin=rdn 												

					]]>
										
					
					<xsl:element name="{$tipocliente}">
						<xsl:attribute name="action">createINE</xsl:attribute>
						<xsl:attribute name="rdn">
							<xsl:value-of select="attribute::codigo" />
						</xsl:attribute>
						
						<xsl:if test="parent::PEDIDO_DE_CLIENTE">
								<xsl:attribute name="property">cliente</xsl:attribute>							
						</xsl:if>
						
						<whenc test="new or set">
							<xsl:copy-of select="@*[name(.)!='NIF-CIF-VAT' and name(.)!='codigo_postal' and name(.)!='nombre' and name(.)!='persona_contacto' and name(.)!='apellidos' and 
							name(.)!='codigo' and name(.)!='action' and name(.)!='localidad' and name(.)!='dirección' and name(.)!='provincia' and name(.)!='país' and name(.)!='tarifa' and 
							name(.)!='grupo_cliente' and name(.)!='régimen_iva' and name(.)!='agente_comercial'  and name(.)!='código_pais']"/>					
					
													
							<!--<xsl:choose>	se puso un valor por defecto para que no falle tarea nocturna anula pedidos caducos, el problema que es que cambiar otro dato tampoco trae NIF y machaca, deberia distinguir si es nuevo o no			-->
							<xsl:if test="attribute::NIF-CIF-VAT and string-length(attribute::NIF-CIF-VAT)>0 and attribute::action='new'">		
									<xsl:attribute name="NIF-CIF-VAT"><xsl:value-of select="replace(attribute::NIF-CIF-VAT,'\W','')"/></xsl:attribute>
							</xsl:if>
							
									
							<xsl:if test="not(attribute::fecha_alta) and action='true'">	
								<xsl:attribute name="fecha_alta"><xsl:value-of select="current-date()" /></xsl:attribute>
							</xsl:if>

																									
							<xsl:if test="attribute::codigo_postal and attribute::action='new'">		
									<xsl:attribute name="código_postal"><xsl:value-of select="attribute::codigo_postal"/></xsl:attribute>
							</xsl:if>
							
							<xsl:if test="attribute::landing and string-length(attribute::landing)>0">		
									<xsl:attribute name="campo_aux4"><xsl:value-of select="attribute::landing"/></xsl:attribute>
							</xsl:if>
							
							<xsl:if test="attribute::telefono">		
									<xsl:attribute name="teléfono"><xsl:value-of select="attribute::telefono"/></xsl:attribute>
							</xsl:if>
							
							<xsl:choose>				
								<xsl:when	test="attribute::apellidos and string-length(attribute::apellidos)>0 and attribute::nombre and string-length(attribute::nombre)>0">
									<xsl:attribute name="nombre"><xsl:value-of select="substring(concat(attribute::apellidos,', ',attribute::nombre),1,100)"/></xsl:attribute>
								</xsl:when>
								<!--<xsl:when	test="attribute::apellidos and string-length(attribute::apellidos)>0 and (not(attribute::nombre) or string-length(attribute::nombre)=0)">
									<xsl:attribute name="nombre"><xsl:value-of select="concat(attribute::apellidos,',',attribute::nombre)"/></xsl:attribute>
								</xsl:when>-->
								<xsl:when	test="(not(attribute::apellidos) or string-length(attribute::apellidos)=0) and attribute::nombre and string-length(attribute::nombre)>0">
									<xsl:attribute name="nombre" select="substring(attribute::nombre,1,100)"/>
								</xsl:when>
							</xsl:choose>
						
							
							<xsl:attribute name="destination">001,060,061,062</xsl:attribute>
							<xsl:if test="attribute::email">
								<xsl:attribute name="campo_aux1"><xsl:value-of select="attribute::email" /></xsl:attribute>
								<xsl:attribute name="email_notificaciones"><xsl:value-of select="attribute::email" /></xsl:attribute>							
								<xsl:attribute name="email"><xsl:value-of select="attribute::email" /></xsl:attribute>	
							</xsl:if>
							
							<xsl:if test="attribute::dirección and attribute::action='new'">
								<xsl:attribute name="dirección"><xsl:value-of select="substring(attribute::dirección,1,100)" /></xsl:attribute>		
							</xsl:if>
							
							<xsl:if test="attribute::pass">
								<xsl:attribute name="campo_aux2"><xsl:value-of select="attribute::pass" /></xsl:attribute>					
							</xsl:if>
							
							<!--debe llegar a false y despues ellos lo cambian <xsl:if test="not(parent::PEDIDO_DE_CLIENTE) and attribute::action='new'">
								<xsl:attribute name="activo">true</xsl:attribute>
							</xsl:if>-->
							<!--hasta qui atributos-->
							
							<xsl:if test="number(attribute::codigo)!=0 and attribute::action='new'">
								<xsl:if test="$tipocliente!='CLIENTE_VARIOS'">
									<xsl:attribute name="ventas30">0</xsl:attribute>
									<xsl:attribute name="ventas90">0</xsl:attribute>
									<xsl:attribute name="ventas360">0</xsl:attribute>
									<TARIFA_PRECIO>							
										<xsl:attribute name="action">set</xsl:attribute>
										<xsl:attribute name="property">tarifa_precio</xsl:attribute>
										<xsl:attribute name="rdn">MAYOR</xsl:attribute>					
									</TARIFA_PRECIO>
									
								</xsl:if>
								<AGENTE_COMERCIAL_FIJO property="agente_comercial" action="set">
									<xsl:choose>
										<xsl:when test="parent::node()/attribute::agente">
											<xsl:attribute name="rdn"><xsl:value-of select="parent::node()/attribute::agente" /></xsl:attribute>		
										</xsl:when>
										<xsl:otherwise>	
											<xsl:attribute name="rdn">WEB</xsl:attribute>	
										</xsl:otherwise>	
									</xsl:choose>
								</AGENTE_COMERCIAL_FIJO>
							</xsl:if>
							<xsl:if test="$tipocliente!='CLIENTE_VARIOS'">
								<GRUPO_CLIENTE>
									<xsl:attribute name="action">set</xsl:attribute>
									<xsl:attribute name="property">grupo_cliente</xsl:attribute>
									<xsl:attribute name="rdn">20</xsl:attribute>					
								</GRUPO_CLIENTE>
							</xsl:if>	
							<xsl:if test="attribute::régimen_iva">
								<RÉGIMEN_IVA>
									<xsl:attribute name="action">set</xsl:attribute>
									<xsl:attribute name="property">régimen_iva</xsl:attribute>
									<xsl:choose>				
										<xsl:when	test="number(attribute::recargo_de_equivalencia)>0">
											<xsl:attribute name="rdn">Recargo_Equivalencia</xsl:attribute>	
										</xsl:when>
										<xsl:when	test="matches(lower-case(attribute::régimen_iva),'carg.+equ')">
											<xsl:attribute name="rdn">Recargo_Equivalencia</xsl:attribute>	
										</xsl:when>
										<xsl:when	test="matches(lower-case(attribute::régimen_iva),'exent')">
											<xsl:attribute name="rdn">Exentos</xsl:attribute>	
										</xsl:when>				
										<xsl:when	test="matches(lower-case(attribute::régimen_iva),'r.{1,2}gim.{1,5}gen.{0,2}r.{0,2}a')">
											<xsl:attribute name="rdn">Regimen_General</xsl:attribute>	
										</xsl:when>	
										<xsl:when	test="matches(lower-case(attribute::régimen_iva),'e?x.{0,2}p.{0,2}r.{0,2}tac.{0,2}(o|n)')">
											<xsl:attribute name="rdn">Exportaciones</xsl:attribute>	
										</xsl:when>	
										<xsl:when	test="matches(lower-case(attribute::régimen_iva),'(i|n).{0,2}(t|r).{0,2}c(o|m).{0,2}u.{0,3}t')">
											<xsl:attribute name="rdn">Intracomunitario</xsl:attribute>	
										</xsl:when>																													
										<xsl:otherwise>
											<xsl:attribute name="rdn"><xsl:value-of select="attribute::régimen_iva" /></xsl:attribute>					
										</xsl:otherwise>
									</xsl:choose>
								</RÉGIMEN_IVA>
							</xsl:if>
										
							<xsl:apply-templates select="@*"/>
							<xsl:apply-templates/>
						</whenc>
					</xsl:element>
				</clone>
			</xsl:when>		
					
			<xsl:when test="self::datos|self::objects">						
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>	
	<xsl:template name="stock">
		<xsl:param name = "soloreservar" />	
		<xsl:param name = "central" />			
		<xsl:param name = "signoreserva"/>
		<xsl:element name="STOCK">			
			<!--ojo de la web si viene info fictitica de talla y color y aqui se construye stock y SKU-->
			<xsl:attribute name="action">createINE</xsl:attribute>
			<xsl:attribute name="destination"><xsl:value-of select="$central"/></xsl:attribute>	
			<xsl:choose>				
					<xsl:when test="$soloreservar='true'">
						<xsl:attribute name="cantidad" select="'+0'"/>	
					</xsl:when>				
					<xsl:otherwise>	
						<xsl:attribute name="cantidad" select="concat('+',attribute::cantidad)"/>
					</xsl:otherwise>
			</xsl:choose>														
		
			<xsl:attribute name="stock_reservado" select="concat('+',number($signoreserva)*attribute::cantidad)"/>	
			<xsl:attribute name="stock_disponible" select="concat('+',-number($signoreserva)*attribute::cantidad)"/>
			
			<xsl:attribute name="rdn">
				<xsl:value-of select="concat($central,'#',attribute::producto,attribute::color,attribute::talla)"/>					
			</xsl:attribute>			
			<xsl:attribute name="clave_producto">
				<xsl:value-of select="concat(attribute::producto,attribute::color,attribute::talla)"/>					
			</xsl:attribute>					
			<GÉNERO property="producto" action="createINE">
				<xsl:attribute name="rdn"><xsl:value-of select="concat(attribute::producto,attribute::color,attribute::talla)" /></xsl:attribute>
			</GÉNERO>
			<ALMACÉN property="almacén_stock" action="set">				
				<xsl:attribute name="rdn"><xsl:value-of select="$central" /></xsl:attribute>
			</ALMACÉN>
		</xsl:element>	
	</xsl:template>
</xsl:stylesheet>