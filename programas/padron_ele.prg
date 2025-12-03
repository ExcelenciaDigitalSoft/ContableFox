close table all
use fac_ele in 1
use padron_ele in 2 excl order clave
sele 2
zap
sele 1
scan
	scatter memvar
	select 2
	seek m.ruta+m.folio+m.subcta
	if !found()
		append blank
		gather memvar
	endif
	sele 1
endscan
close table all