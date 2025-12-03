lparameters _banco,_chequera
*messagebox(_banco+_chequera)

* controlar cheques de chequeras.




close tables all
use chequeras again in 0
set filter to banco=_banco and codigo=_chequera
count to _registros
brow noedit 
if _registros<>0
	
	use movimientos_bancos again in 0
	
	_desde=desde
	_hasta=hasta
	_cantidad=cantidad
	_usados=0
	_cambiados=0
	
	for i=1 to _cantidad
	
		sele movimientos_bancos
		set filter to numero_comprobante=_desde and chequera=_chequera and codigo_banco=_banco
		count to _encontro
		if _encontro>0
			_usados=_usados + 1
		else
			set filter to numero_comprobante=_desde and codigo_banco=_banco and chequera<>_chequera
			count to _otro
			if _otro>0		
				_cambiados=_cambiados + 1	
				messagebox("Cheque: "+_desde+" Está mal asociado a la chequera: "+movimientos_Bancos.chequera)		
			else
				messagebox("Cheque: "+_desde+" No cargado en Movmientos Bancos")
			endif				
		endif
		_desde=ceros(str(val(_desde)+1),10)
	endfor
	
	
	if _usados<_cantidad
	
		if _usados=_cantidad
			messagebox("La chequera ya tiene usados todos los cheques")
		endif
			
		if _usados+_cambiados=_cantidad
			messagebox("La chequera ya tiene usados todos los cheques pero al menos un cheque está en otra chequera")
		endif
		if _usados<_cantidad and _cambiados=0
			messagebox("La chequera NO tiene usados todos los cheques, y NO tiene cheques cambiados")
		endif	
		
		
	endif
else
	messagebox("No hay chequerass")
endif