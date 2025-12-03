if messagebox('Desea Visualizar Informe',36,'Informe')=6
	TB="S"
	fil1="select codigo_banco as banco ,Tipo_movimiento as Tipo_Mov,Fecha_emision as Fec_Emi,fecha_vencimiento as fec_Ven ,fecha_ingreso as fec_ing ,importe ,detalle from Movimientos_Bancos"
	fil2="where Tipo_banco=TB and codigo_banco=thisform.Banco1.value and Tipo_movimiento=thisform.tipo.value"
	if thisform.o1.o1.value=1
		fil3="and betw(Fecha_emision,thisform.text1.value,thisform.text2.value)"
		order1="order by  Fecha_emision"
	else
		fil3="and betw(fecha_vencimiento,thisform.text1.value,thisform.text2.value)"
		order1="order by  fecha_vencimiento"
	endif
	do case
		case thisform.o2.o1.value=1
			fil4="and fecha_ingreso # {}"
		case thisform.o2.o2.value=1
			fil4="and fecha_ingreso = {}"
		case thisform.o2.o3.value=1
			fil4=""
	endcase	
	filtro=fil1+" "+fil2+" "+fil3+" "+fil4+" "+order1+" into cursor consulta"
	&filtro
	select consulta
	Repor form lis_movbanco NoCon Prev
endif
