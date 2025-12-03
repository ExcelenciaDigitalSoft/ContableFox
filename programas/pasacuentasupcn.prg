Close Tables all
clear
USE planUPCN In 1 Alias plan
Use cuencont In 2 Alias cuentas
Select cuentas
Go top
Scan
	Select plan
	Set Order To codigo
	Seek cuentas.codigo
	If !Found()
		?cuentas.codigo+" "+cuentas.Nombre
		Select cuentas
		Replace marca with 9
	EndIf
	Select cuentas
endscan


return
Select plan 
Replace all n6 with "N"
Go top
Scan
	Select cuentas
	Set Order To codigo
	Seek plan.codigo
	If Found()
		Replace plan.n6 with "S"
	EndIf
	Select plan
EndScan
Select plan
Set Filter To n6="N"
Browse
Set Filter To 