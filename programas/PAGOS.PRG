close table all
use pagos in 1 
use facturacion in 2
sele 1
go top
scan
	sele 2
	set order to numfac
	seek pagos.numfac
	if found()
		sele 1
		repl periodo with facturacion.periodo
	endif
	select 1
endscan
close table all


