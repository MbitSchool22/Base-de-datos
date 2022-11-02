SELECT CLIDAT.Nif,
    CLIN.IdContrato AS IdContrato, DATEDIFF(DAY,CCAB.FechaInicio,CCAB.FechaFinEst) AS DurContEstimada, DATEDIFF(DAY,CCAB.FechaInicio, CCAB.FechaFin) AS DurContReal, CCAB.FormaPago, FP.Descrip AS FormaPagoDesc, /*Cálculo de variables incluidas en el dataset*/
    CLIN.IdMaquina, CLIN.TipoAlquiler, AMTIPALQ.Descrip AS TipoAlquilerDescrip, AMTIPALQ.Dias AS TipoAlquilerDiasCobro, (YEAR (GETDATE())-YEAR (AM.FechaUltimaCompra)) AS ANTIGMAQUINA, AM.IdTipoMaquina, PTiposMaq.Descrip AS TipoMaquinaDesc, /*Cálculo de variables incluidas en el dataset*/
    COALESCE((AM.AcuVentas_Euros-AM.AcuCompras_Euros) / NULLIF(AM.AcuVentas_Euros,0), 0)*100  as MBAvgMaq, /*Cálculo de variables incluidas en el dataset teniendo en cuenta que si tenemos un valor 0 no realice la operación e introduzca un "0"*/
    CLIN.Unidades, CLIN.Precio_Euros, CLIN.Descuento, DATEDIFF(DAY,CLIN.FechaInicio,CLIN.FechaDev) AS TempAlqMaquina, (CLIN.ContadorActual - CLIN.ContadorInicial) AS TempUsoMaquina /*Cálculo de variables incluidas en el dataset*/
FROM Contratos_Lineas CLIN /*Declaración de diferentes tablas a usar con sus inner join*/
    INNER JOIN Contratos CCAB ON CLIN.IdContrato = CCAB.IdContrato
    INNER JOIN Articulos_Maquinas AM ON CLIN.IdMaquina = AM.IdArticulo
    INNER JOIN Clientes_Datos CLIDAT ON CCAB.IdCliente = CLIDAT.IdCliente
    INNER JOIN Articulos_Maquinas_TipoAlq AMTIPALQ ON AM.TipoAlquiler = AMTIPALQ.TipoAlquiler
    INNER JOIN FormasPago FP ON CCAB.FormaPago = FP.IdFormaPago
    INNER JOIN PartesTiposMaquinas PTiposMaq ON AM.IdTipoMaquina = PTiposMaq.IdTipoMaquina

WHERE (CCAB.IdEmpresa = '0') AND ( CLIDAT.Nif NOT IN ('B15448467','B15076615','B15625734','B70382064','B27401033','B70441043')) /*No consideramos los siguientes "clientes" por tratarse de empresas del grupo y por tanto no deben tenerse en cuenta*/