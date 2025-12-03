clear
close table all
use orden in 1 
use pagosprov in 2
store 0 to tp,tot,dife
select orden
go top
scan
	select pagosprov
	set orde to nroord
	seek orden.nroord
	do while not eof() and pagosprov.nroord=orden.nroord
		If inlist(left(pagosprov.numero,1),"C","A")
			tp=tp-pagosprov.importe
		Else
			tp=tp+pagosprov.importe
		EndIf
		skip
	enddo
	dife=orden.importe-tp-orden.adelanto
	if dife#0 and orden.tipo#"002"
		?orden.nroord+"   Importe: "+str(orden.importe,10,2)+" Diferencia "+str((dife),10,2)+" Tipo: "+orden.tipo
	endif	
	tot=tot+dife
	dife=0
	tp=0	
	select orden
endscan
?"Diferencia Total : "+str((tot),10,2)
close table all
use faccom in 1
use orden in 2
sele faccom
set filte to left(numero,1)="A"
go top
scan
	select orden
	set orde to nroord
	seek Right(faccom.numero,6)
	if found()
		if faccom.total#orden.adelanto
			?"Diferencias : "+orden.nroord
		else
			?"Encontrada : "+orden.nroord
		endif
	else
		?"Orden no encontrada : "+orden.nroord
	endif
endscan
set filte to
close table all