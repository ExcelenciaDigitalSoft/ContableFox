*modifica el plan de cuentas
close tables all
use cuencont again in 0
set filter to len(allt(padre))!=0 and left(codigo,1)!="2"
_cant=0
scan
	
	_cant=_cant + 1
	* cambio digitos del codigo
	repl codigo with allt(codigo)
	if right(allt(codigo),4)<>'0000'    && Ej 10.01.00 pasa a 10.10.00
		repl codigo with left(codigo,2)+substr(codigo,4,1)+substr(codigo,3,1)+right(codigo,2)
	endif
	
	* cambio digitos de suma
	repl suma with allt(suma)
	if right(allt(suma),4)<>'0000'    && Ej 10.01.00 pasa a 10.10.00
		repl suma with left(suma,2)+substr(suma,4,1)+substr(suma,3,1)+right(suma,2)
	endif
	
	* cambio digitos del clave
	repl clave with allt(clave)
	if right(allt(clave),4)<>'0000'    && Ej 10.01.00 pasa a 10.10.00
		repl clave with left(clave,3)+substr(clave,5,1)+substr(clave,4,1)+right(clave,2)
	endif
	
	* cambio digitos del padre
	repl padre with allt(padre)
	if right(allt(padre),4)<>'0000'    && Ej 10.01.00 pasa a 10.10.00
		repl padre with left(padre,3)+substr(padre,5,1)+substr(padre,4,1)+right(padre,2)
	endif
	
	*row
	if _cant=5
	*return
	endif
endscan

messagebox("Plan de Cuentas Modificado")