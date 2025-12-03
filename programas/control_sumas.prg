Close Tables all
USE cuencont In 0
use movicont in 0
USE aux_sumsal in 0 excl

select aux_sumsal
Zap
	
	select cuencont
	set order to codigo
	go top
	do while not eof()
		store 0 to deb,hab,sal_an
		cod=alltr(codigo)
		select movicont
		set order to codigo
		seek cod
		if found()
			do while not eof() and codigo=cod
				if fecha>={01/12/2021} and fecha=<{30/11/2022}
					if debehaber='D'
						deb=deb+importe
					else
						hab=hab+importe	
					endif
				else
					if fecha<{01/12/2021}
						if debehaber='D'
							sal_an=sal_an+importe	
						else
							sal_an=sal_an-importe		
						endif	
					Endif	
				endif	
				skip
			enddo
			select aux_sumsal  
			append blank
			repl codigo with cod,detalle with Alltr(cuencont.nombre)
			repl acumula with cuencont.acumuladora,suma with cuencont.suma
			repl saldo_ant with sal_an
			repl debe with deb,haber with hab
			repl saldo with deb-hab
			repl nivel with nivel_cuenta(suma)
			store 0 to deb,hab,sal_an
		endif	
		select cuencont
		Skip
	EndDo

	******* Acumula los saldos en las cuentas Padre *******
	select aux_sumsal
	Browse
	Cancel
	
	Replace all suma with codigo for Val(suma)=0  && nuevo marce



*	set orde to codigo
	Set Order To suma
	go top

	do while not eof() 
		for i=1 to nivel
			if i#1
				repl aux_sumsal.detalle with "   "+aux_sumsal.detalle
			endif	
		endfor	
		_r=recno()
		_sal=aux_sumsal.saldo
		_deb=aux_sumsal.debe
		_hab=aux_sumsal.haber

		*do while not eof() and val(suma)#0
		If Val(suma)<>0 and nivel<>1 && nuevo marce
			Set Order To codigo  && nuevo marce
			seek aux_sumsal.suma
			if found()
				repl aux_sumsal.saldo with aux_sumsal.saldo+_sal
				repl aux_sumsal.debe with aux_sumsal.debe+_deb
				repl aux_sumsal.haber with aux_sumsal.haber+_hab
			EndIf
			*- Este while es un bucle infinito --- Marce  
		endif
		*enddo
		Set Order To suma && nuevo marce
		go record _r
		select aux_sumsal
		skip
	enddo
	select aux_sumsal
	Set Order To codigo  && nuevo marce
	Go top

	
	if thisform.o1.o1.value=1 && solo Cuentas Con Saldo
		go top
		scan
			if debe=0 and haber=0  && saldo=0 esta mal que elimine las cuentas con saldo cero ya que puede tener valores en debe=haber y no las muestra.
				dele
			endif
		endscan	
	endif	
	
		
	sele aux_sumsal
	*brow
	*count for saldo<>0 and nivel=4 to a &&acumula='S'
	*messagebox(a)
	*scan
	*	if saldo<>0 and nivel=4
	*		sele total
	*		locate for codigo=aux_sumsal.codigo
	*		if !found()
	*			messagebox(codigos)
	*		endif
	*	endif
	*endscan
	
	******* muestra saldo o saldo de Arrastre
	if _imprimir = 1
		if thisform.o4.o1.value=1 && sin Arrastre
			******* En el Informe lo muestra con debe,haber,Saldo o solo Saldos *******
			if thisform.o2.o1.value=1
			    report form sumsal_acumuladora.frx noconsole prev
			else
			    report form sumsal2_acumuladora.frx noconsole prev    
			endif    
		else    && con Arrastre
			if thisform.o2.o1.value=1
			    report form sumsal2_arrastre.frx noconsole prev
			else
			    report form sumsal2_arrastre.frx noconsole prev    
			endif    		
		endif	
	endif
EndIf

return
*////////////////////////////////////////////////////////////////////////////////////////////////////////////////


if messagebox('Desea Visualizar Listado',36,'Listado')=6
	store 0 to deb,hab,sal_an
	select aux_sumsal
	=tablerevert(.t.)
	select cuencont
	set order to codigo
	go top
	do while not eof()
		cod=alltr(codigo)
		select movicont
		set order to codigo
		seek cod
		if found()
			store 0 to den,hab,sal_an
			do while not eof() and codigo=cod
				if fecha>={01/12/2021} and fecha=<{30/11/2022}
					if debehaber='D'
						deb=deb+importe
					else
						hab=hab+importe	
					endif
				else
					if fecha<{01/12/2021}
						if debehaber='D'
							sal_an=sal_an+importe	
						else
							sal_an=sal_an-importe		
						endif	
					Endif	
				endif	
				skip
			enddo
		endif	
		select aux_sumsal  
		append blank
		repl codigo with cod,detalle with Alltr(cuencont.nombre)
		repl acumula with cuencont.acumuladora,suma with cuencont.suma
		repl saldo_ant with sal_an
		repl debe with deb,haber with hab
		repl saldo with deb-hab
		repl nivel with thisform.nivel(suma)
		store 0 to deb,hab,sal_an
		select cuencont
		Skip
	EndDo
	******* Acumula los saldos en las cuentas Padre *******
	select aux_sumsal
	set orde to codigo
	go top
	do while not eof() 
		for i=1 to nivel
			if i#1
				repl aux_sumsal.detalle with "   "+aux_sumsal.detalle
			endif	
		endfor	
		_r=recno()
		_sal=aux_sumsal.saldo
		_deb=aux_sumsal.debe
		_hab=aux_sumsal.haber
		do while not eof() and val(suma)#0
			seek aux_sumsal.suma
			if found()
				repl aux_sumsal.saldo with aux_sumsal.saldo+_sal
				repl aux_sumsal.debe with aux_sumsal.debe+_deb
				repl aux_sumsal.haber with aux_sumsal.haber+_hab
			endif
		enddo
		go record _r
		select aux_sumsal
		skip
	enddo
	select aux_sumsal
	if thisform.o1.o1.value=1 && solo Cuentas Con Saldo
		go top
		scan
			if saldo=0
				dele
			endif
		endscan	
	endif	
	******* muestra saldo o saldo de Arrastre
	if thisform.o4.o1.value=1 && sin Arrastre
		******* En el Informe lo muestra con debe,haber,Saldo o solo Saldos *******
		if thisform.o2.o1.value=1
		    report form sumsal_acumuladora.frx noconsole prev
		else
		    report form sumsal2_acumuladora.frx noconsole prev    
		endif    
	else    && con Arrastre
		if thisform.o2.o1.value=1
		    report form sumsal2_arrastre.frx noconsole prev
		else
		    report form sumsal2_arrastre.frx noconsole prev    
		endif    		
	endif	
endif

return

* codigo viejo no totaliza en las sumadoras
if messagebox('Desea Visualizar Listado  -A-',36,'Listado')=6
	store 0 to deb,hab,sal_an
	select aux_sumsal
	=tablerevert(.t.)
	select cuencont
	set order to codigo
	go top
	do while not eof()
		cod=alltr(codigo)
		select movicont
		set order to codigo
		seek cod
		if found()
			store 0 to den,hab,sal_an
			do while not eof() and codigo=cod
				if fecha>={01/12/2021} and fecha=<{30/11/2022}
					if debehaber='D'
						deb=deb+importe
					else
						hab=hab+importe	
					endif
				else
					if fecha<{01/12/2021}
						if debehaber='D'
							sal_an=sal_an+importe	
						else
							sal_an=sal_an-importe		
						endif	
					Endif	
				endif	
				skip
			enddo
		endif	
		select aux_sumsal  
		append blank
		repl codigo with cod,detalle with Alltr(cuencont.nombre)
		repl acumula with cuencont.acumuladora,suma with cuencont.suma
		repl saldo_ant with sal_an
		repl debe with deb,haber with hab
		repl saldo with deb-hab
		repl nivel with thisform.nivel(suma)
		store 0 to deb,hab,sal_an
		select cuencont
		Skip
	EndDo

	******* Acumula los saldos en las cuentas Padre *******
	select aux_sumsal

	set orde to codigo
	go top

	do while not eof() 
		for i=1 to nivel
			if i#1
				repl aux_sumsal.detalle with "   "+aux_sumsal.detalle
			endif	
		endfor	
		_r=recno()
		_sal=aux_sumsal.saldo
		_deb=aux_sumsal.debe
		_hab=aux_sumsal.haber
		*do while not eof() and val(suma)#0
			seek aux_sumsal.suma
			if found()
				repl aux_sumsal.saldo with aux_sumsal.saldo+_sal
				repl aux_sumsal.debe with aux_sumsal.debe+_deb
				repl aux_sumsal.haber with aux_sumsal.haber+_hab
			endif
			*- Este while es un bucle infinito --- Marce  
		*enddo
		go record _r
		select aux_sumsal
		skip
	enddo
	select aux_sumsal
	if thisform.o1.o1.value=1 && solo Cuentas Con Saldo
		go top
		scan
			if saldo=0
				dele
			endif
		endscan	
	endif	
	******* muestra saldo o saldo de Arrastre
	if thisform.o4.o1.value=1 && sin Arrastre
		******* En el Informe lo muestra con debe,haber,Saldo o solo Saldos *******
		if thisform.o2.o1.value=1
		    report form sumsal_acumuladora.frx noconsole prev
		else
		    report form sumsal2_acumuladora.frx noconsole prev    
		endif    
	else    && con Arrastre
		if thisform.o2.o1.value=1
		    report form sumsal2_arrastre.frx noconsole prev
		else
		    report form sumsal2_arrastre.frx noconsole prev    
		endif    		
	endif	
endif