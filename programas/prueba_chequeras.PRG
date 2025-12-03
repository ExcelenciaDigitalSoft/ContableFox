		
		select chequeras
		scan
			if habilitado=1
				select * ,max(val(numero_comprobante)) as ultimo from movimientos_bancos ;
				where tipo_banco="S" and codigo_banco=chequeras.banco and chequera=chequeras.codigo ;
				into cursor consulta
				Select consulta

				ult=consulta.ultimo
				
				select count(*)as cant from movimientos_bancos ;
				where tipo_banco="S" and codigo_banco=chequeras.banco and chequera=chequeras.codigo ;
				into cursor cantidad
				
				Select cantidad
				_cant=cantidad.cant
				
				select chequeras
				*if !betw(consulta.ultimo,val(chequeras.desde),val(chequeras.hasta))
				*	ult=val(chequeras.desde)-1
				*Endif
				if  betw(consulta.ultimo,val(chequeras.desde),val(chequeras.hasta)) &&and Val(chequeras.ultimo)=0 
					repl chequeras.ultimo with ceros(str(ult,10),10)
					*Replace chequeras.usados with _cant
					Select chequeras
					*brows
				EndIf
			EndIf
		endscan