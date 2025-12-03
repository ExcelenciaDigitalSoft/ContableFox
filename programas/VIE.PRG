close table all
use ord_ing in 1 
use pagos   in 2 orde ord_ing
sele 1
go bott
fin=recno()
set filter to rubro='001' and val(numero)#0
go top
do while not eof()
	reg=recno()
	scatter memvar
	sele pagos
	seek m.numero
	a=1
	do while not eof() and m.numero=ord_ing 
		if m.codigo=ruta+right(folio,3)+subcta
			if a=1	
				repl ord_ing.importe with pagos.importe,ord_ing.periodo with pagos.periodo
				a=a+1
			else
				sele ord_ing
				set order to ruta
				seek m.codigo+pagos.periodo
				if !found()
					appe blan
					gather memvar
					repl ord_ing.importe with pagos.importe,ord_ing.periodo with pagos.periodo
				else
					? m.codigo,pagos.periodo 	
				endif
				set order to 0	
				sele pagos
			endif
		else	
			? m.numero,m.codigo,ruta+right(folio,3)+subcta
		endif	
		skip
	enddo
	sele ord_ing
	go record reg
	if reg>=fin
		exit
	endif
	skip
enddo
