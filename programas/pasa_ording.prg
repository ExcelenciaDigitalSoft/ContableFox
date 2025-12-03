close table all
use pagos in 1 
use ord_ing in 2 excl
use padron in 3
store 0 to pag
sele 2
zap
sele 3
go top
scan
	sele 1
	set order to clave
	seek padron.ruta+padron.folio+padron.subcta
	do while not eof() and ruta=padron.ruta and folio=padron.folio and subcta=padron.subcta
		pag=pag+importe
		sele 1
		skip
	enddo
	if pag#0
		sele 2
		append blank
		repl ruta with padron.ruta,folio with padron.folio
		repl subcta with padron.subcta,nombre with padron.nombre
		repl rubro with "001",nomrubro with "SERVICIOS SOCIALES       "
		repl importe with pag,detalle with "Pago Sistema Viejo"
	endif
	store 0 to pag
	sele 3
endscan
close table all
