close table all
use proveedores in 1
use faccom in 2
use venci_compra in 3
use dias in 4
store 0 to inicio	
select faccom
set filte to inlist(val(proveedor),1,2,3,4)
go top
scan
	select proveedores
	set order to codigo
	seek faccom.proveedor
	if found()
		d_vence=proveedores.dias_vence
		select dias
		set order to nombre
		seek proveedores.dia_cierre
		if found()
			if dias.codigo#0
				if dow(faccom.fecha)=dias.codigo
					inicio=0
				else
					if dow(faccom.fecha)>dias.codigo	
						*inicio=dow(faccom.fecha)-dias.codigo+(7-dow(faccom.fecha))-1
						inicio=(7+dias.codigo)-dow(faccom.fecha)
					else
						inicio=dias.codigo-dow(faccom.fecha)
					endif
				endif
			else
				inicio=0	
			Endif	
		else
			inicio=0
		endif
	endif
	select venci_compra
	appen blank
	repl dias with inicio+d_vence
	repl fecven with faccom.fecha+dias
	repl factura with faccom.numero
	repl proveedor with faccom.proveedor
	repl num_venci with "01"
	select faccom
endscan	
select faccom
set filte to
close table all