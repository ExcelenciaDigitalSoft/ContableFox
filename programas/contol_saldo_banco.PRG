if messagebox('Desea Visualizar Informe',36,'Informe')=6
	thisform.imprimir(1)
endif
Return


if messagebox('Desea Visualizar Informe',36,'Informe')=6
   sele aux_movbanco
   =tablerevert(.t.)
   thisform.saldolibrobanco=0
   thisform.saldobancario=0
   THISFORM.SALDOAJUSTE=0
   ******* Calculo Saldo Inicial *******
	IF THISFORM.TEXT1.VALUE>={01/01/2013}
		THISFORM.SALDOAJUSTE=IIF(THISFORM.BANCO1.VALUE='002',409835.03,785632.33)
	ENDIF
	
	If thisform.saldo_inicial#0  		
	    select aux_movbanco
	    append blank	
	    repl tipo with "Saldo Inicial"
	    repl fecemi with thisform.fecha_inicio
	    if thisform.saldo_inicial<0
		    repl debe with 0.00
		    repl haber with thisform.saldo_inicial
		    repl saldo with thisform.saldo_inicial
		else
		    repl debe with thisform.saldo_inicial
		    repl haber with 0.00
		    repl saldo with thisform.saldo_inicial
		Endif    
	    thisform.saldolibrobanco=thisform.saldo_inicial
	EndIf	    
   ******* Calculo Saldo Anterior *******
*   store 0 to m.debe,m.haber,m.saldo,t_debe,t_haber
   m.debe=aux_movbanco.debe
   m.haber=aux_movbanco.haber
   m.saldo=aux_movbanco.saldo
   store 0 to t_debe,t_haber
   
IF THISFORM.SALDOAJUSTE=0

   select movimientos_bancos  
   set order to librobanco
   set near on
   seek thisform.banco1.value
   set near off
   do while not eof() and codigo_banco=thisform.banco1.value and fecha_emision<thisform.text1.value
   	   If tipo_banco="S" and codmodi=0
		   scatter memvar
		   m.fecpag=m.fecha_ingreso
		   if m.debe_haber='H'
		   		m.haber=importe
		   		t_haber=t_haber+importe
		   		m.debe=0.00		   
		   		thisform.saldolibrobanco=thisform.saldolibrobanco-importe
		   		m.saldo=m.saldo+(m.debe-m.haber)
		   else
		   		thisform.saldolibrobanco=thisform.saldolibrobanco+importe 	
		   		m.debe=m.importe
		   		t_debe=t_debe+importe
		   		m.haber=0.00		   			
		   		m.saldo=m.saldo+(m.debe-m.haber)
		   endif
		   if m.fecpag#{}
		   	   if m.debe_haber='H'
			   		thisform.saldobancario=thisform.saldobancario-importe
			   else
			   		thisform.saldobancario=thisform.saldobancario+importe 		
			   endif	
		   endif
		EndIF   
	   	select movimientos_bancos
	   	skip
	enddo 
	If m.saldo#0  		
	    select aux_movbanco
	    append blank	
	    repl tipo with "Saldo Anterior"
	    repl debe with t_debe
	    repl haber with t_haber
	    repl saldo with m.saldo
	    repl fecemi with thisform.text1.value-1
	EndIf	
ENDIF  && THISFORM.SALDOAJUSTE<>0    
   ******* Calculo movimientos  entre fecha *******
   store 0 to m.debe,m.haber
   select movimientos_bancos  
   set order to librobanco
   set near on
   seek thisform.banco1.value+dtos(thisform.text1.value)
   set near off
   do while not eof() and codigo_banco=thisform.banco1.value and fecha_emision<=thisform.text2.value
   	   If tipo_banco="S" and codmodi=0
		   scatter memvar
		   m.nrocupon=m.numero_comprobante
		   m.fecemi=m.fecha_emision
		   m.fecven=m.fecha_vencimiento
		   m.fecpag=m.fecha_ingreso
		   if m.debe_haber='H'
		   		thisform.saldolibrobanco=thisform.saldolibrobanco-importe
		   		m.haber=importe
		   		m.debe=0.00
		   		m.saldo=m.saldo+(m.debe-m.haber)
		   else
		   		thisform.saldolibrobanco=thisform.saldolibrobanco+importe 		
		   		m.debe=m.importe
		   		m.haber=0.00
		   		m.saldo=m.saldo+(m.debe-m.haber)
		   endif
		   if m.fecpag#{}
		   	   if m.debe_haber='H'
			   		thisform.saldobancario=thisform.saldobancario-importe
			   else
			   		thisform.saldobancario=thisform.saldobancario+importe 		
			   endif	
		   EndIf
		   If Val(movimientos_bancos.pagprov)#0
			   Select orden
			   Set Order To nroord
			   Seek movimientos_bancos.pagprov
			   If Found()
			   		m.detalle = Alltrim(m.detalle)+"-"+Alltrim(orden.detalle)
			   EndIf
		   Endif		   
		   select movimientos_banco
		   set order to codigo
		   seek m.tipo_movimiento
		   m.tipo=nombre
		   select aux_movbanco
		   append blank
		   gather memvar
		EndIF   
	   select movimientos_bancos
	   skip
	enddo   
	thisform.saldo=m.saldo
	repo form librobanco noconsole  prev
endif
