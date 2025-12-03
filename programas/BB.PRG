use movimientos_bancos in 1
sele 1
set filte to tipo_banco="S" and codmodi=0 and val(num_concilia)=0
use det_conciliaciones in 2
sele 2
set filte to tipo=1 and numero="000012"
go top
scan
	sele 1
	if det_conciliaciones.debe=0
		locate for importe=det_conciliaciones.haber and det_conciliaciones.fecha=fecha_Emision
		if found()
			repl num_concilia with "000012"
			repl fecha_ingreso with {25/04/2005}
		else
			messagebox("N")
		endif
	else
		locate for importe=det_conciliaciones.debe and det_conciliaciones.fecha=fecha_Emision
		if found()
			repl num_concilia with "000012"
			repl fecha_ingreso with {25/04/2005}
		else
			messagebox("N")
		Endif			
	Endif	
	sele 2
endscan
close table all

