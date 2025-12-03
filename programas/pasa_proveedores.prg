close tables all
use provexcel again in 0
use proveexcel2 again in 0 alias pro2
use proveedores again in 0 alias proveedores
use proveedores_2011 again in 0 alias proveedores_2011

sele proveedores
scan
	if len(allt(codprooc))>0
		sele proveedores_2011
		set order to codprooc
		seek proveedores.codprooc
		if FOUND()
			repl proveedores.codprooc2 with codprooc2
			repl proveedores.codprooc3 with codprooc3
		endif
	endif
endscan

messagebox("fin")
return


sele provexcel
scan

	*repl cuit2 with allt(cuit2)
	scatter memvar
	if len(allt(cuit2))>11
		*repl cuit with left(cuit2,2)+substr(cuit2,4,8)+right(cuit2,1)
	else
		*repl cuit with cuit2

	endif
	
	if len(allt(brutos2))>10
		*repl brutos with left(brutos2,3)+substr(brutos2,5,6)+right(allt(brutos2),1)
	else
		*repl brutos with brutos2

	endif
	
	sele pro2
	set order to codigo
	seek allt(provexcel.codigo)
*	messagebox(provexcel.codigo)
	if found()
		*repl provexcel.brutos2 with brutos
	endif
endsca