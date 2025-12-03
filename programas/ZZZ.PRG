select orden
set order to ProFec
Set Near On
seek _prov+Dtos(_f1)
Set Near Off
do while not eof() and proveedor=_prov and fecha <= _f2
	if proveedor=_prov 
		Select pagosprov
		Set Order To Nroord
		Seek orden.nroord
		DO while not Eof() and nroord=orden.nroord
			If cliente=thisform.Textcodigo.Value
				d=d+orden.importe
			EndIf	
			skip
		EndDo
	endif
	select orden
	skip
EndDo