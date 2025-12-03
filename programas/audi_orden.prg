close table all
clear
use faccom in 1
******* Audito Adlantos de orden en Faccom *******
select * from orden where adelanto#0 into cursor consulta
select consulta
go top
scan
	select faccom
	set orde to numero
	seek consulta.proveedor+"AN-ORDEN"+consulta.nroord
	if found()
		if consulta.adelanto#faccom.total
			?"Importe no Coincidente Orden Nº: "+consulta.nroord+" Importe Orden: "+Str(consulta.adelanto,10,2)+" Importe FacCom: "+Str(faccom.Total,10,2)
		endif
	else
		?"No Encontrado Orden Nº: "+consulta.nroord+" Importe: "+Str(consulta.adelanto,10,2)
	endif
	select consulta
endscan
close table all
select * ,sum(importe) as totalpagos from pagosprov order by nroord group by nroord into cursor consulta
select a.nroord ,a.importe,a.adelanto,b.nroord,b.totalpagos,(a.importe-b.totalpagos) as diferencia from orden a, consulta b where a.nroord=b.nroord and (a.importe-b.totalpagos)#0
select a.nroord ,a.importe,a.adelanto,b.nroord,b.totalpagos,(a.importe-b.totalpagos) as diferencia from orden a, consulta b where a.nroord#b.nroord and (a.importe-b.totalpagos)#0
