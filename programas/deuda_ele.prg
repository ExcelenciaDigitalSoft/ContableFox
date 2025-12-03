close table all
use padron_ele in 1
use deuda_ele in 2 excl
use fac_ele in 3 order claveperde
store 0 to deu
sele 2
zap
sele 1
go top
scan
	scatter memvar
	select 3
	seek m.ruta+m.folio+m.subcta
	do while not eof() and ruta=m.ruta and folio=m.folio and subcta=m.subcta and per_concat<"200105"
		deu=deu+fac_ele.total_fact		
		skip
	enddo
	sele 2
	set order to clave
	seek m.ruta+m.folio+m.subcta
	if !found()
		append blank
	else
		messagebox(m.ruta+m.folio+m.subcta)	
	endif
	m.deuda=deu
	gather memvar
	store 0 to deu
	sele 1
endscan
close table all