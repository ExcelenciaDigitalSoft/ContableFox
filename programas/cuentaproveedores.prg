close table all
use proveedores in 1
use C:\UPCNContable\Conta-UPCN\archivos\ProveedoresUPCNCUIT in 2 alias pro
select 1
go top
scan
	sele 2
	set order to nombre
	seek alltr(upper(proveedores.nombre))
	if found()	
		repl proveedores.cuenta with pro.codigo
	EndIf
	sele 1
endscan
sele 1
go top
brows
