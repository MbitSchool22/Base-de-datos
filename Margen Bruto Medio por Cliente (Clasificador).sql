SELECT CLIDAT.Nif, max(SUBSTRING(CCAB.IdCliente,1,5)) as ClientePadre,  MAX(CCAB.IdCliente) AS IDCliente, /*Los clientes se estructuran en ClientesPadre que son los clientes en si (5 primeros dígitos) y en clientes que son los centros de trabajo de esos clientes. Calculamos el ClientePadre ya que es nuestra referencia*/ 
    SUM(CLIN.Precio_Euros*CLIN.Unidades*(1-(CLIN.Descuento/100))) as VENTASCLIENTE,/*Cálculo de variables incluidas en el dataset*/ 
    AVG(COALESCE((AM.AcuVentas_Euros-AM.AcuCompras_Euros) / NULLIF(AM.AcuVentas_Euros,0), 0)*100 ) as MBAvg, /*Cálculo de variables incluidas en el dataset teniendo en cuenta que si tenemos un valor 0 no realice la operación e introduzca un "0"*/
    MAX(COALESCE((AM.AcuVentas_Euros-AM.AcuCompras_Euros) / NULLIF(AM.AcuVentas_Euros,0), 0)*100 ) as MBMax, /*Cálculo de variables incluidas en el dataset teniendo en cuenta que si tenemos un valor 0 no realice la operación e introduzca un "0"*/
    MIN(COALESCE((AM.AcuVentas_Euros-AM.AcuCompras_Euros) / NULLIF(AM.AcuVentas_Euros,0), 0)*100 ) as MBMin, /*Cálculo de variables incluidas en el dataset teniendo en cuenta que si tenemos un valor 0 no realice la operación e introduzca un "0"*/
    SUM(CLIN.Unidades) AS NArticulos,/*Cálculo de variables incluidas en el dataset*/ 
    COUNT(CLIN.IdContrato) AS NContratos,/*Cálculo de variables incluidas en el dataset*/ 
    AVG(COALESCE(CLIN.Precio_Euros*CLIN.Unidades*(1-(CLIN.Descuento/100)) / NULLIF(CLIN.Unidades,0),0)) AS PrecMedArticulo,/*Cálculo de variables incluidas en el dataset teniendo en cuenta que si tenemos un valor 0 no realice la operación e introduzca un "0"*/
    (/*Realizamos una subselect para poder calcular la diferencia de los cobros reales y previstos ya que la variable de cliente real (ClientePadre) la tenemos que realizar calculada por no disponerla en este set de datos*/
        SELECT AVG(DATEDIFF(DAY,FechaVencimiento,ISNULL(FechaCobro,FechaVencimiento)))  from Clientes_Efectos where Clientes_Efectos.IdCliente =  max(SUBSTRING(CCAB.IdCliente,1,5)) 
    ) as DifCPrevCReal
FROM Contratos_Lineas CLIN /*Declaración de diferentes tablas a usar con sus inner join*/
    INNER JOIN Contratos CCAB ON CLIN.IdContrato = CCAB.IdContrato
    INNER JOIN Articulos_Maquinas AM ON CLIN.IdMaquina = AM.IdArticulo
    INNER JOIN Clientes_Datos CLIDAT ON CCAB.IdCliente = CLIDAT.IdCliente
WHERE (CCAB.IdEmpresa = '0') AND ( CLIDAT.Nif NOT IN ('B15448467','B15076615','B15625734','B70382064','B27401033','B70441043')) /*No consideramos los siguientes "clientes" por tratarse de empresas del grupo y por tanto no deben tenerse en cuenta*/
GROUP BY CLIDAT.Nif
ORDER BY ClientePadre