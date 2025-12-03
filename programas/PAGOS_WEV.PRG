* -- Se ha generado un archivo de secuencia de comandos de Asistente para Web -- 
*
* Se ha creado un registro único en GENHTML.DBF con su configuración.
* Se puede hacer referencia a este archivo con el Id. especificado en el 
* comando DO (GENHTML) siguiente.

LOCAL lnSaveArea
lnSaveArea=SELECT()
SELECT 0

OPEN DATABASE "C:\JAVIER\ACTUALIZADOS\COOPERATIVA\COOPERATIVA.DBC"
SELECT Ord_ing,Numfac,Periodo,Ruta,Folio,Subcta,Importe FROM "PAGOS" ;
   INTO CURSOR webwizard_query

IF EMPTY(_GENHTML)
  _GENHTML='GenHTML.PRG'
ENDIF
DO (_GENHTML) WITH "C:\JAVIER\ACTUALIZADOS\COOPERATIVA\PAGOS_WEV.HTM",ALIAS(),2,,"_13F13V5OZ"

IF USED("webwizard_query")
  USE IN webwizard_query
ENDIF
SELECT (lnSaveArea)
