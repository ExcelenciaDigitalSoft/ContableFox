Close Tables all
Clear 
USE Bancos Order Codigo In 0
USE movimientos_bancos Order LibroBanco In 0
USE movicont  In 0 


Select movimientos_bancos  
Set Filter To tipo_banco="S" and codmodi=0  && filtro solo movimientos bancarios

Store 0 to mSalLibro,mSalBanco,mSalAjuste,mSalInicio,t_debe,t_haber
mCodBanco='003'
mCtaBanco=''                   && cuenta contable del banco
mFec1={01/12/2021}
mFec2={30/11/2022}
mFecI={}
mSalAjuste= Iif(mFec1>={01/12/2021},IIF(mCodBanco='002',409835.03,785632.33),0) && Calculo Saldo Inicial

Select Bancos
Seek mCodBanco
If found()
	mCtaBanco=cuenta
	mSalInicio=sal_inicio
	mFecI=fecha
EndIf	
m.debe =Iif(mSalInicio<0,0,mSalInicio)
m.haber=Iif(mSalInicio>0,mSalInicio,0)
m.saldo=mSalInicio 
If mSalAjuste=0
   Select movimientos_bancos  
   Set Near on
   Seek mCodBanco
   Set Near Off 
   Scan while codigo_banco=mCodBanco and fecha_emision<mFec1
		If debe_haber='H'
		   	t_haber=t_haber+importe
		   	mSalLibro=mSalLibro-importe
		   	m.saldo=m.saldo-Importe
		Else 
		   	t_debe=t_debe+importe
		   	mSalLibro=mSalLibro+importe 	
		   	m.saldo=m.saldo+Importe
		EndIf 
		mSalBanco=mSalBanco+Iif(fecha_ingreso#{},(Iif(Debe_haber='H',-1,1)*Importe),0)
	EndScan 
EndIf  && mSalAjuste=0  
Select  movimientos_bancos  
set near on
Seek mCodBanco+dtos(mFec1)
set near off
Scan while codigo_banco=mCodBanco and fecha_emision<=mFec2
If importe=   598035.38
brow
EndIf 
	If debe_haber='H'
		t_haber=t_haber+importe
		mSalLibro=mSalLibro-importe
		m.saldo=m.saldo-Importe
	Else 
		t_debe=t_debe+importe
		mSalLibro=mSalLibro+importe 	
		m.saldo=m.saldo+Importe
	EndIf 
	mSalBanco=mSalBanco+Iif(fecha_ingreso#{},(Iif(Debe_haber='H',-1,1)*Importe),0)
	If Len(orden_de_ingreso)#0
			?'.t.',orden_de_ingreso
	EndIf 
	If Val(orden_de_ingreso)#0
		Select movicont
		Set Order To INGRESO1   && INGRESO1
		Seek movimientos_bancos.orden_de_ingreso
		mIngresos=0
		do while not Eof() and INGRESO1=movimientos_bancos.orden_de_ingreso
			mIngresos=mIngresos+Iif(mCtaBanco=codigo,importe,0)
			skip
		EndDo 
		If mIngresos#movimientos_bancos.importe
			? movimientos_bancos.orden_de_ingreso,movimientos_bancos.importe,mIngresos
		EndIf 
	EndIf 
	
EndScan    
? t_debe,t_haber,mSalLibro,mSalBanco
