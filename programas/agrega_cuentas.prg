close tables all
use cuencont again in 0
use prov_txt again in 0 alias prov

sele prov
scan
	*repl clave with 'A'+codigo
	*repl padre with 'A'+left(codigo,4)+'00'
	*repl suma with righ(padre,6)
endscan


sele prov
scan
	scatter memvar
	m.acumuladora='S'
	sele cuencont
	append blank
	gather memvar
	
endscan



messagebox("fin")