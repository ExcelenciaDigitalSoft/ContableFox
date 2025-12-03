*!*	Close  table all
*!*	SET ENGINEBEHAVIOR 70

*!*	select pagprov,*,sum(importe) as imp_banco from movimientos_bancos where Val(pagprov)#0 and codigo_banco='003' and ;
*!*		Between(fecha_emision,{01/01/2023},{31/12/2023}) order by fecha_emision;
*!*		group by pagprov	into cursor c_banco

*!*	select pag_prov,*,sum(importe) as imp_conta from movicont where Val(pag_prov)#0 and codigo='101003' and periodo='202301' order by fecha;
*!*			group by pag_prov into cursor c_conta

*!*	select a.NroAsiento,a.pag_prov_a,b.pagprov_a,a.imp_conta,b.imp_banco,(a.imp_conta-b.imp_banco)as diferencia from c_conta a, c_banco b where a.pag_prov_a=b.pagprov_a into cursor cursor3
*!*	Select cursor3
*!*	Sum diferencia to c
*!*	? c
*!*	Browse


Close  table all
SET ENGINEBEHAVIOR 70

select fecha_emision,*,sum(importe) as imp_banco from movimientos_bancos where Val(pagprov)=0 and codigo_banco='003' and ;
	Between(fecha_emision,{01/12/2021},{30/11/2022}) and debe_haber='H' order by fecha_emision ;
	group by fecha_emision	into cursor c_banco

select fecha,*,sum(importe) as imp_conta from movicont where Val(pag_prov)=0 and codigo='101003' and periodo='202301' and;
	debehaber='H' order by fecha group by fecha into cursor c_conta

Select c_banco
Browse
Select c_conta
Browse

select a.NroAsiento,a.fecha_a,b.fecha_emision_a,a.imp_conta,b.imp_banco,(a.imp_conta-b.imp_banco)as diferencia from c_conta a, c_banco b where a.fecha_a=b.fecha_emision_a into cursor cursor3
Select cursor3
Sum diferencia to c
? c
Browse