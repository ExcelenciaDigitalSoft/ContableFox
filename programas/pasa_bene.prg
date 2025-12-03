use C:\B\FAM1.DBF in 1 
use C:\COOPERATIVA\BENEFICIARIOS.DBF in 2
use C:\COOPERATIVA\padron.dbf in 3 order codigo
sele 1
scan
	scatter memvar
	m.codigo=m.rut+right(m.fol,3)+m.sub
	sele 2
	IF LEN(ALLT(M.CONYUGE))#0
		APPE BLAN
		B=M.NACCONY
		a= right(B,2)
		F=ctod(left(B,2)+'/'+subs(B,3,2)+'/'+iif(val(A)<10,'20','19')+A)
		repl CODIGO with m.codigo,NOMBRE with M.CONYUGE    ,PARENTEZCO with 'CONYUGE'
    	repl FECNAC with F       ,TIPDOC with '001'        ,DOCUMENTO  with M.DNICONY
	ENDIF
	FOR K=1 TO 10
		L=IIF(K<10,STR(K,1),STR(K,2))
		N='M.HIJO'+L
      	D='M.DNIHIJO'+L
      	H='M.NACHIJO'+L
		IF LEN(ALLT(&N))#0
			APPE BLAN
			B=&H
			a= right(B,2)
			F=ctod(left(B,2)+'/'+subs(B,3,2)+'/'+iif(val(A)<10,'20','19')+A)
			repl CODIGO with m.codigo,NOMBRE with &N ,PARENTEZCO with 'HIJO'
		    repl FECNAC with F        ,TIPDOC with '001',DOCUMENTO  with &d
		ENDIF    
	ENDFOR
	FOR K=1 TO 5
		L=STR(K,1)
		N='M.ADHE'+L
      	D='M.DNIADHE'+L
      	H='M.NACADHE'+L
		IF LEN(ALLT(&N))#0
			APPE BLAN
			B=&H
			a= right(B,2)
			F=ctod(left(B,2)+'/'+subs(B,3,2)+'/'+iif(val(A)<10,'20','19')+A)
			repl CODIGO with m.codigo,NOMBRE with &N ,PARENTEZCO with 'ADHERENTE'
		    repl FECNAC with F        ,TIPDOC with '001',DOCUMENTO  with &d
		ENDIF    
	ENDFOR
	SELE 3
	SEEK M.CODIGO
	IF FOUND()
      	B=M.NACTIT
		a= right(B,2)
		F=ctod(left(B,2)+'/'+subs(B,3,2)+'/'+iif(val(A)<10,'20','19')+A)
		REPL FEC_NACIMIENTO WITH F
      	B=M.FECVIGENCI
		a= right(B,2)
		F=ctod(left(B,2)+'/'+subs(B,3,2)+'/'+iif(val(A)<10,'20','19')+A)
		REPL VIGENCIA WITH F
      	B=M.FECBAJA
		a= right(B,2)
		F=ctod(left(B,2)+'/'+subs(B,3,2)+'/'+iif(val(A)<10,'20','19')+A)
		REPL BAJA WITH F
		REPL TELEFONO WITH M.TELEFONO
	ENDIF	
	SELE 1	
ENDSCAN