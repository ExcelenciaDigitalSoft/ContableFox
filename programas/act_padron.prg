close table all
use padron in 1  order clave
use padron_ele in 2
selec 2
go top
scan	
	sele 1
	seek padron_ele.ruta+padron_ele.folio+padron_ele.subcta
	if found()
		repl nuevo with "N"
		repl nro_med with padron_ele.nro_med,cuit with padron_ele.cuit
		repl cod_iva with padron_ele.cod_iva,categ_iva with padron_ele.categ_iva		
	else
		append blank
		repl nuevo with "S"	
		repl estado with "B",ruta with padron_ele.ruta
		repl folio with padron_ele.folio,subcta with padron_ele.subcta
		repl nombre with padron_ele.nombre,calle with padron_ele.calle
		repl numero with padron_ele.numero,barrio with padron_ele.barrio
		repl nro_med with padron_ele.nro_med,cuit with padron_ele.cuit
		repl cod_iva with padron_ele.cod_iva,categ_iva with padron_ele.categ_iva
	endif
	sele 2
endscan
close table all