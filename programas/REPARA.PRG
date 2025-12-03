parameter n_file
clear
dime _elemento(4)

=adir(_datos,n_file)
* _tamano=_datos(2)
* ? 'Tama¤o del Archivo...... '+tran(_tamano,'###,###')
*------------------------ abro .DBF
_manejador=fopen(n_file,12)
*------------------------ n§ de _registros
_registros=0
=fseek(_manejador,4)
_registros=_registros+asc(fread(_manejador,1))
=fseek(_manejador,5)
_registros=_registros+asc(fread(_manejador,1))*256
=fseek(_manejador,6)
_registros=_registros+asc(fread(_manejador,1))*256^2
=fseek(_manejador,7)
_registros=_registros+asc(fread(_manejador,1))*256^3
? 'N£mero de Registros..... '+tran(_registros,'###,###')
*--------------------------- longitud de la cabecera
_cabecera=0
=fseek(_manejador,8)
_cabecera=_cabecera+asc(fread(_manejador,1))
=fseek(_manejador,9)
_cabecera=_cabecera+asc(fread(_manejador,1))*256
? 'Longitud de la Cabecera. '+tran(_cabecera,'###,###')
*--------------------------- longitud de registro
_tamrec=0
=fseek(_manejador,10)
_tamrec=_tamrec+asc(fread(_manejador,1))
=fseek(_manejador,11)
_tamrec=_tamrec+asc(fread(_manejador,1))*256
? 'Longitud del Registro... '+tran(_tamrec,'####,###')
? 
_estimo=1+_cabecera+_registros*_tamrec
? 'Longitud estimada....... '+tran(_estimo,'####,###')

_tamnue=_estimo
_regnue=_registros
*do while _tamnue>_tamano
	_tamnue=_tamnue-_tamrec
	_regnue=_regnue-1
*enddo	 
? 
? 'Tamano Nuevo............' + tran(_tamnue,'####,###')
? 'Cantidad Nueva..........' + tran(_regnue,'####,###')
*---------------------------------------------------
*if _tamnue#_tamano or _regnue#_registros
	do _base with _regnue,256
	=fseek(_manejador,4)
	=fwrite(_manejador,chr(_elemento(1))+chr(_elemento(2))+chr(_elemento(3))+chr(_elemento(4)),4)
	=fchsize(_manejador,_tamnue)
*endif
=fclose(_manejador)



*------------------------------------------------------------------------
function _base

parameter _numero,_base

_elemento=0

_van=0
_resto=_numero
do while _resto>=_base
	_van=_van+1
	_elemento(_van)=_resto%_base
	_resto=int(_resto/_base)
enddo	
_van=_van+1
_elemento(_van)=_resto
for _i=1 to _van
	? _elemento(_i)
next
return	
	