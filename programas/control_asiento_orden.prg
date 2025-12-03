Close Tables all
Clear 
USE orden In 0
USE movicont In 0
USE movimientos_bancos In 0 

Select movimientos_bancos
Set Order To PAGPROV   && PAGPROV 
Select movicont
Set Order To PAG_PROV   && PAG_PROV 
** ordenes con movimiento contable
Select orden
Set Filter To Between(fecha,{01/12/2021},{30/11/2022}) &&and tipo='001'
Go top 
a=1
Scan
	nOrd=NroOrd
	mImp=importe
	Select movicont
	Seek nOrd
	Store  0 to sImp1,sImp2
	DO while not Eof() and nOrd=pag_prov
		sImp1=sImp1+Iif(debehaber='H' ,importe,0)
		sImp2=sImp2+Iif(debehaber='H' and Val(Alltrim(nro_cheque))#0,importe,0)
		Skip 
	EndDo ´
	Select movimientos_bancos
	Seek nOrd
	bImp=0
	DO while not Eof() and nOrd=pagprov
		bImp=bImp+importe
		Skip 
	EndDo ´

	If mImp#sImp1
		? 'Orden',nOrd,mImp,sImp1,bImp
	EndIf 
EndScan 
? a


** movimientos contable con orden
Select Orden
Set Order To NROORD   && NROORD

Select movicont
Set Order To PAG_PROV   && PAG_PROV 

Set Filter To periodo='202201' and debehaber='H' and Val(pag_prov)#0
Go top 
a=1
Scan
	nOrd=PAG_PROV   
	mImp=importe
	fec=fecha
	nro=nroasiento
	Select orden 
	Seek nOrd
	Store  0 to sImp1,sImp2
	DO while not Eof() and nOrd=nroord
		sImp1=sImp1+importe
		Skip 
	EndDo 
	If mImp#sImp1 and sImp1 =0
		? 'Conta',nro,nOrd,mImp,sImp1,fec
	EndIf 
	
EndScan 
? a