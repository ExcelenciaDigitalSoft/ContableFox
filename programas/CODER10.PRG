parameters cadena,largo,codifica
if codifica										&&codifico
	if !empty(cadena)
      cod_cadena = padr(upper(alltr(cadena)),largo)
		store '' to caracter_referencia, cadena_a_codificar
		valor_referencia=asc(cod_cadena)+largo
		caracter_referencia = chr(valor_referencia)
      for i=2 to largo			
			cadena_a_codificar = substr(cod_cadena,i,1)											 
			cadena_a_codificar = chr(mod(asc(cadena_a_codificar)+valor_referencia,255)+1)
			caracter_referencia = caracter_referencia+cadena_a_codificar
			valor_referencia = asc(cadena_a_codificar)
      endfor
   else
      caracter_referencia = space(largo)
	endif							  
else												&& decodifico
	if !empty(cadena)
		cadena=alltr(cadena)
		store '' to caracter_referencia, cadena_a_codificar
	    cod_cadena = substr(cadena,2)
		largo = len(cadena)
	    done = .F.
	    valor_referencia = asc(cadena)-largo
	    prim=valor_referencia
	   	  for i=2 to largo				
				cadena_a_codificar = substr(cadena,i,1)
				if i#2
			        if asc(cadena_a_codificar) <= valor_referencia
			           caracter_referencia = caracter_referencia + chr(255+asc(cadena_a_codificar)-valor_referencia-1)
			        else
			            caracter_referencia = caracter_referencia + chr(asc(cadena_a_codificar)-valor_referencia-1)
					endif
				else
					if asc(cadena_a_codificar) <= valor_referencia
			           caracter_referencia = caracter_referencia + chr(255+asc(cadena_a_codificar)-valor_referencia-1-largo)
			        else
			            caracter_referencia = caracter_referencia + chr(asc(cadena_a_codificar)-valor_referencia-1-largo)
					endif
				endif	
				valor_referencia = asc(cadena_a_codificar)
	      endfor
		  caracter_referencia=chr(prim)+caracter_referencia
    else
	    caracter_referencia = space(largo)
	endif
endif
return caracter_referencia

