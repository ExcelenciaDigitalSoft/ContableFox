Close Tables all
USE cuencont In 0
use movicont in 0

	

select movicont
Set Order To NROASIENTO   && NROASIENTO
Set Filter To fecha>={01/12/2021} and fecha=<{30/11/2022}
Go top
DO while not Eof()
	store 0 to deb,hab,sal_an
	nro=nroasiento
	do while not eof() and nro=nroasiento
		if debehaber='D'
			deb=deb+importe
		else
			hab=hab+importe	
		endif
		skip
	EndDo
	If (deb-hab)!=0
		? nro,deb,hab
	EndIf 
EndDo 	

Close Tables all
