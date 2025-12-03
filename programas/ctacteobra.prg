obr="210"
fDesde={01/08/2005}
fHasta={31/08/2005}
Select Det_fac.numero, Det_fac.fecha as FecFacturacion, Det_fac.periodo, Det_fac.obra,;
Det_fac.nombre, Det_fac.importe as imp_fac, Det_fac.num_liq , ;
Det_fac.importe_liq , Liquidaciones.fecha as FecLiquidacion, ;
Liquidaciones.cuenta as CueLiqui, Liquidaciones.nomcuenta as CueLiquiNom, Liquidaciones.NomPro as CentroFacturacion, ;
Facturacion.cuenta as CueFac, Facturacion.nomcuenta as CueFacNom From det_fac ;
Inner Join liquidaciones ;
ON  Det_fac.num_liq = Liquidaciones.numero ;
Inner Join facturacion ;
On  Det_fac.numero = Facturacion.numero;
Where  Det_fac.obra = obr and Between(det_fac.fecha,fDesde,fhasta) ;
Into Cursor consulta
Select consulta
brows
  

