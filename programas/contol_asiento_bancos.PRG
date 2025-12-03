Close Tables all
Clear 
Use movimientos_bancos In 0

USE movicont In 0
Select movicont
Set Filter to periodo='202301' and InList(codigo,'101002','101003','101004','101005','101007','103005') && and Val(nro_cheque)<>0

Select movimientos_bancos
Set Order To FECHA_EMIS   && FECHA_EMISION
Set Filter to Between(fecha_emision,{01/01/2023},{31/12/2023}) and tipo_banco='S' and debe_haber='H'
Go top
a=0
DO WHILE not Eof()
	ord=pagprov
	imp=0
	DO WHILE not Eof() and pagprov=ord
		imp=imp+importe
		Skip 
	EndDo 
	If Len(Alltrim(ord))#0
		Select movicont
		Set Order To pag_prov
		Set Near on
		Seek ord
		Set Near off
		sum1=0
		Scan while pag_prov=ord
			If debehaber='H'
				sum1=sum1+importe
			EndIf 
		EndScan 
		If sum1<>imp
			? ord,imp,sum1,imp-sum1
			a=a+(imp-sum1)
		EndIf 
	Else 
		*? ord
	EndIf 
	Select movimientos_bancos
	ord=pagprov
	imp=0	
EndDo 
? a
Close Tables all
