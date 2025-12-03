close table all
use \B\DEUDA    in 1 
use ord_ing     in 2 ORDER RUTA
use facturacion in 3 
SELE 1
scan
	SCATTER MEMVAR
	select 3
	append blank
	a= right(m.vence,2)
    repl NUMFAC with 'SA000000'+ceros(str(m.factura,6),6),PERIODO with m.periodo
    repl FECVEN with ctod(left(m.vence,2)+'/'+subs(m.vence,3,2)+'/'+iif(val(A)<10,'20','19')+a)
    repl RUTA with m.rut,FOLIO with m.fol,SUBCTA with m.sub
    repl CUOTA with m.importe,DETALLE with 'Deuda Anterior'
	IF VAL(M.PAGADO)#0
		SELE 2
		SET NEAR ON
		SEEK M.RUT+M.FOL+M.SUB+M.PERIODO
		SET NEAR OFF
		IF !FOUND()
			append blank
			b= right(m.pagado,2)
			repl ruta with M.rut,folio with M.fol,subcta with M.sub,PERIODO WITH M.PERIODO
			repl rubro with "001",nomrubro with "SERVICIOS SOCIALES       "
			repl importe with M.IMPORTE,detalle with "Pago Periodo "+right(m.periodo,2)+'-'+left(m.periodo,4)
    		repl FECha with ctod(left(m.pagado,2)+'/'+subs(m.pagado,3,2)+'/'+iif(val(b)<10,'20','19')+b)
		endif
	ENDIF	
	sele 1
endscan
close table all
quit
