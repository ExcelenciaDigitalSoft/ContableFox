Close Tables all
Clear 
Use ingresos In 0
Use MOVICONT In 0  
USE movimientos_bancos In 0
Select movimientos_bancos
Set Order To INGRESO   && INGRESO
Select movicont
Set Order To INGRESO1   && INGRESO1
Select ingresos
Set Filter To periodo='202401'
Go top
Scan
	imp=importe
	nro=numero
	Select movicont
	Set Near on
	Seek nro
	Set Near off 
	Store 0 to deb,hab
	Scan while nro=ingreso1
		If debehaber='D'
			deb=deb+importe
		Else
			hab=hab+importe
		EndIf 
	EndScan 
	sing1=0
	Select movimientos_bancos
	Seek nro
	DO while not Eof() and nro=ingreso
		sing1=sing1+importe
		Skip 
	EndDo 
	If Abs(deb-imp)>1 or Abs(hab-imp)>1
		? 'Deb',nro,imp,deb,hab,sing1
	EndIf 
	If Abs(deb-sing1)>1 or Abs(hab-sing1)>1
		? 'Ing',nro,imp,deb,hab,sing1
	EndIf 
	? 'Deb',nro,imp,deb,hab,sing1		
EndScan
