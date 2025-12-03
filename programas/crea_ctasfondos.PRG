close tables all
use cuencont again in 0 alias cuencont
use cuencont again in 0 alias cuen
use bancos again in 0
USE DELEGACIONES AGAIN IN 0
_cod='001'
sele cuencont
set order to codigo
scan
	if codigo#'211100'
		sele cuen
		set order to padre
		seek cuencont.clave
		if !found()  && Es una cuenta hijo -> pasar como Cuenta de Fondos.
			sele bancos
			append blank
			repl codigo with _cod
			repl nombre with cuencont.nombre
			repl cuenta with cuencont.codigo
			repl tipo_banco with 'N'
			repl modi_cartera with 'N'
			repl fecha with {01/07/2020}
			repl sal_inicio with 0.00
			_cod=ceros(str(val(_cod)+1),3)
			IF INLIST(CUENCONT.CODIGO,'701009','701010','701013','701015','701001')
				SCATTER MEMVAR
				SELE DELEGACIONES
				SCAN
					M.NOMBRE=ALLT(CUENCONT.NOMBRE)+'  DELEG. '+ALLT(NOMBRE)
					M.CODIGO=_COD
					SELE BANCOS
					APPEND BLANK
					GATHER MEMVAR
					_cod=ceros(str(val(_cod)+1),3)
				ENDSCAN
			ENDIF
		endif
	endif
	
endscan
MESSAGEBOX("FIN PROCESO")