Close TABLES all
USE proveedores In 0 Alias proveedores
Use C:\UPCNContabilidad\bdsql\comercios In 0 Alias come
c=0
Select proveedores
Go top
Scan
	Select come
	Set Order To nombre
	Seek Alltrim(proveedores.nombre)
	If Found()
		Replace proveedores.codprooc with come.cod
		c=c+1
	endif
	Select proveedores
EndScan
MessageBox(Str(c))
Close Tables all