close table all
use facturacion in 1 excl
use deuda in 2
use pagos in 3 excl
sele 3
zap
sele 1
zap
sele 2
go top
scan
	scatter memvar
	m.periodo=m.mes+m.año
	m.lote=space(6)
	select 1
	append blank
	gather memvar
	if val(m.pagado)#0
		select pagos
		append blank
		repl lote with m.lote
		repl numfac with m.numfac,ruta with m.ruta
		repl folio with m.folio,subcta with m.subcta
		repl importe with m.cuota
	endif
	sele 2
endscan
close table all