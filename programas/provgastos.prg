* Pasar las cuentas de gastos de los proveedores institucionales.

Close Tables all
USE proveedores Again In 0 
USE provgastos Again In 0

Select provgastos
Scan
	Select proveedores
	Set Order To codigo
	Seek provgastos.codigo
	If Found()	
		Replace cuen_gasto with provgastos.cuen_gasto
	endif
EndScan

MessageBox("Fin Proceso")
