******* Control de Cheque de Terceros orden de Ingreso Contra Contabilidad *******
*cuenta="111015"
*Select ingreso1 as Ord_Ingreso,fecha,sum(Importe) as importe ;
*from chequeter ;
*where val(ingreso1)#0 ;
*order by importe ;
*group by ingreso1 ;
*into cursor consulta
*select consulta
*select * from movicont where Val(ingreso1)#0 and codigo=cuenta order by importe;
*into cursor consulta2 
*select consulta2
*select a.ord_ingreso,b.ingreso1,a.importe,b.importe,(a.importe-b.importe)as diferencia from consulta a, consulta2 b where a.ord_ingreso=b.ingreso1

******* Control de Cheque de Terceros transferencias Contra Contabilidad *******

*cuenta="111015"
*Select tran_egr as transfe,fecha,sum(Importe) as importe ;
*from chequeter ;
*where val(tran_egr)#0 ;
*order by importe ;
*group by ingreso1 ;
*into cursor consulta
*select consulta
*brows
*select * from movicont where Val(transfe)#0 and codigo=cuenta order by importe;
*into cursor consulta2 
*select consulta2
*select a.transfe,b.transfe,a.importe,b.importe,(a.importe-b.importe)as diferencia from consulta a, consulta2 b where a.transfe=b.transfe


******* Control de Cheque de Terceros orden de Pago Contra Contabilidad *******
cuenta="111015"
Select ord_pag as Ord_pag ,fecha,sum(Importe) as importe ;
from chequeter ;
where val(ord_pag)#0 ;
order by importe ;
group by ord_pag ;
into cursor consulta
select consulta
select * from movicont where Val(pag_prov)#0 and codigo=cuenta order by importe;
into cursor consulta2 
select consulta2
select b.NroAsiento,a.ord_pag,b.pag_prov,a.importe,b.importe,(a.importe-b.importe)as diferencia from consulta a, consulta2 b where a.ord_pag=b.pag_prov

