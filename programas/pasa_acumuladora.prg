close tables all
use cuencont again in 0 alias cuencont
use cuencont_2011 again in 0 alias cuencont_2011
_enc=0
sele cuencont
scan
	scatter memvar
	sele cuencont_2011
	set order to nombre
	seek allt(m.nombre)
	if found()
		repl cuencont.acumuladora with acumuladora
		_enc=_enc+1
	endif
	
endscan

messagebox("Fin del Proceso, encontradas: "+str(_enc))