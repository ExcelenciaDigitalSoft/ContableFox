*** --------------------------------------------------- ***
function resta2
parameter hh1,hh2
m1=val(righ(hh1,2))
h1=val(left(hh1,2))*60
m2=val(righ(hh2,2))
h2=val(left(hh2,2))*60
hora1=h1+m1
hora2=h2+m2
if h1<=h2
	hora3=hora2-hora1
else
	dif1=1440-hora1
	hora3=dif1+hora2
endif	
h3=int(hora3/60)
m3=mod(hora3,60)
return ceros(str(h3,2),2)+ceros(str(m3,2),2)
*** --------------------------------------------------- ***
function suma
parameter hh1,hh2
m1=val(righ(hh1,2))
h1=val(left(hh1,2))
m2=val(righ(hh2,2))
h2=val(left(hh2,2))
if m1+m2>60
	h3=h1+h2+1
	m3=(m1+m2)-60
else
	h3=h1+h2
	m3=m1+m2	
endif
return ceros(str(h3,2),2)+ceros(str(m3,2),2)
*** --------------------------------------------------- ***
function resta
parameter hh1,hh2
m1=val(righ(hh1,2))
h1=val(left(hh1,2))
m2=val(righ(hh2,2))
h2=val(left(hh2,2))
if h1>h2
	j=resta(hh1,'2400')
	k=resta('0000',hh2)
	h3=val(left(j,2))+val(left(k,2))
	m3=val(righ(j,2))+val(righ(k,2))
	if m3>=60
		h3=h3+1
		m3=m3-60
	endif
else
	if m2<m1
		m3=60-(m1-m2)
		h2=h2-1
	else
		m3=m2-m1	
	endif
	h3=h2-h1
endif
return ceros(str(h3,2),2)+ceros(str(m3,2),2)
*** --------------------------------------------------- ***
function funcer
parameter _nro_,_y_
_nro_=ceros(_nro_,_y_)
return .t.
*** --------------------------------------------------- ***
function blancos
parameter x,y
private x,y
  x=alltrim(x)
  x=repl(' ',y-len(x))+x
return x
*** --------------------------------------------------- ***
function blancos2
parameter x,y
private x,y
  x=alltrim(x)
  x=x+repl(' ',y-len(x))
return x
*** --------------------------------------------------- ***
*** --------------------------------------------------- ***
function ceros
parameter x,y
private x,y
  x=alltrim(x)
  x=repl('0',y-len(x))+x
return x
*** --------------------------------------------------- ***
*** --------------------------------------------------- ***
function ceros2
parameter x,y
private x,y
  x=alltrim(x)
  x=x+repl('0',y-len(x))
return x
*** --------------------------------------------------- ***
*** --------------------------------------------------- ***
function barra
parameter x,y
private x,y
  x=alltrim(x)
  x=x+repl('-',y-len(x))
return x
*** --------------------------------------------------- ***
function lis_imp
parameter imp,ancho
private u,d,c,dies,veinte,imp,ancho,cent,p1,p2,p3,p4,p5,p6,tx
dimension u(9),d(9),c(9),diez(9),veinte(9)
*** ------------------------ ***
u(1) = 'UNO'
u(2) = 'DOS'
u(3) = 'TRES'
u(4) = 'CUATRO'
u(5) = 'CINCO'
u(6) = 'SEIS'
u(7) = 'SIETE'
u(8) = 'OCHO'
u(9) = 'NUEVE'
d(1) = 'DIEZ'
d(2) = 'VEINTE'
d(3) = 'TREINTA'
d(4) = 'CUARENTA'
d(5) = 'CINCUENTA'
d(6) = 'SESENTA'
d(7) = 'SETENTA'
d(8) = 'OCHENTA'
d(9) = 'NOVENTA'
c(1) = 'CIEN'
c(2) = 'DOSCIENTOS'
c(3) = 'TRESCIENTOS'
c(4) = 'CUATROCIENTOS'
c(5) = 'QUINIENTOS'
c(6) = 'SEISCIENTOS'
c(7) = 'SETECIENTOS'
c(8) = 'OCHOCIENTOS'
c(9) = 'NOVECIENTOS'
*** ------------------------ ***
diez(1)   = 'ONCE'
diez(2)   = 'DOCE'
diez(3)   = 'TRECE'
diez(4)   = 'CATORCE'
diez(5)   = 'QUINCE'
diez(6)   = 'DIECISEIS'
diez(7)   = 'DIECISIETE'
diez(8)   = 'DIECIOCHO'
diez(9)   = 'DIECINUEVE'
veinte(1) = 'VEINTIUNO'
veinte(2) = 'VEINTIDOS'
veinte(3) = 'VEINTITRES'
veinte(4) = 'VEINTICUATRO'
veinte(5) = 'VEINTICINCO'
veinte(6) = 'VEINTISEIS'
veinte(7) = 'VEINTISIETE'
veinte(8) = 'VEINTIOCHO'
veinte(9) = 'VEINTINUEVE'
*** ------------------------ ***
imp = abs(imp)                   &&   POR SI VIENE EN NEGATIVO
imp = round(imp,2)               &&   REDONDEO A DOS DECIMALES
cent= str((imp-int(imp))*100,2)  &&   SACO LOS CENTAVOS EN P1
imp = str(int(imp),7)            &&   CONVIERTO LA PARTE ENTERA EN STRING
p1 = val(substr(imp,7,1))        &&   UNIDAD 
p2 = val(substr(imp,6,1))        &&   DECENAS
p3 = val(substr(imp,5,1))        &&   CENTENAS
p4 = val(substr(imp,4,1))        &&   UNIDAD   DE MIL
p5 = val(substr(imp,3,1))        &&   DECENA   DE MIL
p6 = val(substr(imp,2,1))        &&   CENTENAS DE MIL
p7 = val(substr(imp,1,1))        &&   UNIDAD DE MILLON
tx = ''                          &&   INICIALIZO LA VARIABLE DE LOS TEXTOS

tx = tx+iif(p7#0,iif(p7=1,'UN',u(p7))+' MILLON'+iif(p7#1,'ES ',' '),'')  && UNIDAD DE MILLON

*     - - -     ARMO TEXTO PARA UNIDAD / DECENA / CENTENA DE MIL
if (p6+p5+p4)#0
   tx = tx +iif(p6#0,c(p6),'')
   tx = tx +iif(p6=1 and p5>0,'TO ',' ')
   if p5>2 
	   tx = tx +iif(p5#0,d(p5),'')
	   tx = tx +iif(p4#0,' Y '+u(p4),'')
   else
	   tx = tx +iif(p5=2,iif(p4#0,veinte(p4),d(p5)),'')
	   tx = tx +iif(p5=1,iif(p4#0,diez(p4),d(p5)),'')
	   tx = tx +iif(p5=0 and p4#0,iif(p4=1,'UN',u(p4)),'')
   endif	   
   tx=tx+' MIL '
endif
*     - - -     ARMO TEXTO PARA UNIDAD / DECENA / CENTENA
if (p3+p2+p1)#0
   tx = tx +iif(p3#0,c(p3),'')
   tx = tx +iif(p3=1 and p1>0,'TO ',' ')
   if p2>2 
	   tx = tx +iif(p2#0,d(p2),'')
	   tx = tx +iif(p1#0,' Y '+u(p1),'')
   else
	   tx = tx +iif(p2=2,iif(p1#0,veinte(p1),d(p2)),'')
	   tx = tx +iif(p2=1,iif(p1#0,diez(p1),d(p2)),'')
	   tx = tx +iif(p2=0 and p1#0,u(p1),'')
   endif	   
endif
tx=tx+iif(val(cent)#0,' CON '+cent+'/100.-','.-')
return padr(alltrim(tx),ancho,'.')
*** --------------------------------------------------- ***
function vercod
parameter bas,cod,ind
actual=select(0)
enuso=used(bas)
if !enuso
	use (bas) in 0 
	sele (bas)
	if parameter()=3	
		set order to &ind
	else	
		set	order to codigo
	endif	
else
	sele (bas)
	reg=iif(eof() or bof(),1,recno())
	cdx=tag()
	fil=filter()
	set filter to
	if parameter()=3	
		set order to &ind
	else	
		set	order to codigo
	endif	
endif
sele (bas)
seek cod
nom=nombre
if !enuso
	sele (bas)
	use
else
	sele (bas)
	if len(allt(fil))#0
		a=fil
		set filter to &a
	endif	
	if len(allt(cdx))#0
		set order to (cdx)
	endif	
	go record (reg)
endif
sele (actual)
return nom
*** --------------------------------------------------- ***
function verfield
parameter bas,cod,cam
actual=select(0)
enuso=used(bas)
if !enuso
	if upper(bas)='DENTISTA'
		use (bas) in 0 order matri
	else
		use (bas) in 0 order codigo
	endif	
else
	sele (bas)
	reg=iif(eof() or bof(),1,recno())
	cdx=tag()
	fil=filter()
	set filter to
	if upper(bas)='DENTISTA'
		set order to matri
	else
		set order to codigo
	endif	
endif
sele (bas)
seek cod
nom=&cam
if !enuso
	sele (bas)
	use
else
	sele (bas)
	if len(allt(fil))#0
		a=fil
		set filter to &a
	endif	
	if len(allt(cdx))#0
		set order to (cdx)
	endif	
	go record (reg)
endif
sele (actual)
return nom
*** --------------------------------------------------- ***
function proximo &&esta Funcion debuelve : si logico=.t. el proximo de lo contrario debuelve el ultimo
parameter bas,campo,tamaño,logico
actual=select(0)
enuso=used(bas)
dato=space(val(tamaño))
if !enuso
	use (bas) in 0 order campo
else
	select(bas)	
endif
orden='set order to '+alltr(campo)
&orden
go bott
valor=''
store 0 to tam
valor=&campo
tam=val(tamaño)
if logico
	dato=ceros(str(val(valor)+1,tam),tam)
else
	dato=valor
endif	
return dato
*************************************************
*** --------------------------------------------------- ***
function verfield
parameter bas,cod,cam,ind1
private reg,bas,cod,cam1,ind1,enuso,cam,ind,ba,actual,fil,cdx,nom,a
actual=select(0)
ba=iif(rat('\',bas)#0,right(bas,len(bas)-;
              rat('\',bas)),bas)
enuso=used(ba)
cam=iif(parameter()=2,'nombre',cam)
ind=iif(parameter()=4,ind1,'codigo')
if !enuso
	use (bas) in 0 order &ind
else
	sele (ba)
	reg=iif(eof() or bof(),1,recno())
	cdx=tag()
	fil=filter()
	set filter to
	set order to &ind
endif
sele (ba)
seek cod
nom=&cam
if !enuso
	sele (ba)
	use
else
	sele (ba)
	if len(allt(fil))#0
		a=fil
		set filter to &a
	endif	
	if len(allt(cdx))#0
		set order to (cdx)
	endif	
	go record (reg)
endif
sele (actual)
return nom
*** --------------------------------------------------- ***
function excel 
parameter base
enuso=used(base)
if !enuso
	use (base) in 0 
else
	select(base)	
endif
nom=PUTFILE('Guardar Como',base, 'xls')
if !empty(nom)
	COPY TO (nom) TYPE xls
	if messagebox('Desea Abrir Excel',36,'Asistente')=6
		wait windows "Transferiendo Datos a Excel..." nowait
		tmpsheet = GetObject(nom,'excel.sheet')
		XLApp = tmpsheet.application
		XLApp.Visible = .t.
		XLApp.WorkBooks.Add(nom)
	endif	
endif	
*******
function word
parameter base
enuso=used(base)
if !enuso
	use (base) in 0 
else
	select(base)	
endif
nom=PUTFILE('Guardar Como',base, 'doc')
COPY TO (nom) DELIMITED WITH BLANK
if messagebox('Desea Abrir Word',36,'Asistente')=6
	wait windows "Transferiendo Datos a Word..." nowait
	tmpsheet = GetObject(nom)
	XLApp = tmpsheet.application
	XLApp.Visible = .t.
endif	
*//*****************
function apicopy &&Esta Funcion copia Archivos por debajo de windows
	parameter desde,hasta
	declare CopyFile in Kernel32 string d, string h ,long a
	copyfile(desde,hasta,1)
function apidele &&Esta Funcion Borra Archivos por debajo de windows
	parameter archivo
	declare DeleteFile in Kernel32 string Arch
	Deletefile(archivo)
*-----------------------------
FUNCTION apli_activa(cCaption)
*-----------------------------
LOCAL nHWD
DECLARE INTEGER FindWindow IN WIN32API ;
STRING cNULL, ;
STRING cWinName

DECLARE SetForegroundWindow IN WIN32API ;
INTEGER nHandle

DECLARE SetActiveWindow IN WIN32API ;
INTEGER nHandle

DECLARE ShowWindow IN WIN32API ;
INTEGER nHandle, ;
INTEGER nState

nHWD = FindWindow(0, cCaption)
IF nHWD > 0
    * VENTANA YA ACTIVA
    * LA "LLAMAMOS":
    ShowWindow(nHWD,9)

    * LA PONEMOS ENCIMA
    SetForegroundWindow(nHWD)

    * LA ACTIVAMOS
    SetActiveWindow(nHWD)
    RETURN .T.
ELSE
    * VENTANA NO ACTIVA
    RETURN .F.
ENDIF
**********cambiar la resolucion de pantalla****************
*!* Cambia la resolución de la pantalla
*!* Sintaxis: ChangeRes(tnWidth, tnHeight)
*!* Valor devuelto: llRetVal
*!* Argumentos: tnWidth, tnHeight
*!* tnWidth especifica la nueva anchura de la pantalla en pixels
*!* tnHeight especifica la nueva altura de la pantalla en pixels

FUNCTION ChangeRes
    LPARAMETERS tnWidth, tnHeight
    LOCAL lnWidth, lnHeight, lnModeNum, lcDevMode
    *!* Valores
    lnModeNum  = 0
    lcDevMode  = REPLICATE(CHR(0), 156)
    lnWidth    = IIF(EMPTY(tnWidth), 800, tnWidth)
    lnHeight   = IIF(EMPTY(tnHeight), 600, tnHeight)
    *!* Instrucciones DECLARE DLL para cambiar resolución
    DECLARE INTEGER EnumDisplaySettings   IN Win32API STRING lpszDeviceName,;
	INTEGER iModeNum, STRING @lpDevMode
    DECLARE INTEGER ChangeDisplaySettings IN Win32API STRING @lpDevMode ,;
	INTEGER dwFlags
    *!* Bucle para obtener todos los modos disponibles
    DO WHILE EnumDisplaySettings(NULL, lnModeNum, @lcDevMode) <> 0
        lnModeNum = lnModeNum +1
    ENDDO
    *!* Configurar la structura DevMode
    lcDevMode = STUFF(lcDevMode,  41, 4, LongToStr(1572864))
    lcDevMode = STUFF(lcDevMode, 109, 4, LongToStr(tnWidth))  && Ancho
    lcDevMode = STUFF(lcDevMode, 113, 4, LongToStr(tnHeight))  && Alto
    *!* Cambiar resolucion
    ChangeDisplaySettings(@lcDevMode, 1)
ENDFUNC

*!* Convierte un long integer a un 4-byte character string
*!* Sintaxis: LongToStr(lnLongVal)
*!* Valor devuelto: lcRetStr
*!* Argumentos: lnLongVal
*!* lnLongVal especifica el long integer a convertir
FUNCTION LongToStr
    LPARAMETERS lnLongVal
    LOCAL lnCnt, lcRetStr
    lcRetStr = ''
    FOR lnCnt = 24 TO 0 STEP -8
        lcRetStr = CHR(INT(lnLongVal/(2^lnCnt))) + lcRetStr
        lnLongVal = MOD(lnLongVal, (2^lnCnt))
    NEXT
    RETURN lcRetStr
ENDFUNC
*******restaurar datos despues de un zap
FUNCTION UNZAP
PARAMETER Y
IF Y>0 .AND. USED() 
   IF RECCOUNT()=0
      FILENAME=DBF()
      USE
      HANDLE=FOPEN(FILENAME,2)
      IF HANDLE>0
         BYTE=FREAD(HANDLE,32)
         BKUP_BYTE=BYTE
         FIELD_SIZE=ASC(SUBSTR(BYTE,11,1))+(ASC(SUBSTR(BYTE,12,1))*256)
         FILE_SIZE=FSEEK(HANDLE,0,2)
         BYTE8=CHR(INT(Y/(256*256*256)))
         BYTE7=CHR(INT(Y/(256*256)))
         BYTE6=CHR(INT(Y/256))
         BYTE5=CHR(MOD(Y,256))
         BYTE=SUBSTR(BYTE,1,4)+BYTE5+BYTE6+BYTE7+BYTE8+SUBSTR(BYTE,9)
         =FSEEK(HANDLE,0)
         =FWRITE(HANDLE,BYTE)
         =FCHSIZE(HANDLE,FILE_SIZE+(FIELD_SIZE*Y))
         =FCLOSE(HANDLE)
      ENDIF
      USE &FILENAME
   ENDIF
ENDIF
*--------------------------------------------
*--------------------------------------------
* Nuestra información de las aplicaciones que
* estan corriendo en Windows
* USO: ListApp()
*-----------------------------------------------
FUNCTION ListApp
LOCAL laApp, lnHandle, lnCount, lcTitle, lnI, lnHFox
DIMENSION laApp[1]
lnHFox=0
DECLARE INTEGER FindWindow ;
  IN win32api ;
  INTEGER nullpointer, ;
  STRING cwindow_name
DECLARE INTEGER GetWindow ;
  IN win32api ;
  INTEGER ncurr_window_handle, ;
  INTEGER ndirection
DECLARE INTEGER GetWindowText ;
  IN win32api ;
  INTEGER n_win_handle, ;
  STRING @ cwindow_title, ;
  INTEGER ntitle_length
lnHFox = FindWindow(0,_SCREEN.CAPTION)
lnHandle = lnHFox && GetWindow(lnHFox,0)
lnCount = 0
DO WHILE lnHandle > 0
  lcTitle=SPACE(255)
  lnI=GetWindowText(lnHandle, @lcTitle,LEN(lcTitle))
  IF lnI>0
    lcTitle=STRTRAN(TRIM(lcTitle),CHR(0),"")
  ELSE
    lcTitle=""
  ENDIF
  IF lnHandle > 0 .AND. !EMPTY(lcTitle)
    lnCount=lnCount+1
    DIMENSION laApp(lnCount)
    laApp[lnCount]=lcTitle
  ENDIF
  lnHandle = GetWindow(lnHandle,2)
ENDDO

IF ALEN(laApp,1)>0
  lcString = "Las siguientes aplicaciones estan ejecutandose:" + CHR(13) + CHR(13)
  FOR i=1 TO ALEN(laApp,1)
    lcString = lcString + laApp[i]+CHR(13)
  NEXT
ELSE
  lcString = "No hay aplicaciones ejecutandose"
ENDIF
=MESSAGEBOX(lcString, "Lista de aplicaciones")
RETURN ""
ENDFUNC
*--------------------------------------------------------------------------------
***rutina para averiguar serie de disco duro encriptada
function encriptaserie
local inret, icstring, lpvolname,nvolsize,lpvolnumber,; 
lpmaxcomp, lpflags,lpfsname,nfssize,lproot,numeroserie 
if empty(lproot) 
lproot="c:\" 
endif 
lpvolname=space(256) 
nvolsize=256 
lpvolnumber=0 
lpmaxcomp=256 
lpflags=0 
lpfsname=space(256) 
nfssize=256 
declare integer GetVolumeInformation in win32api as getvolinfo; 
string @lproot,; 
string @lpvolname,; 
integer nvolsize,; 
integer @lpvolnumber,; 
integer @lpmaxcomp,; 
integer @lpflags,; 
string @lpfsname,; 
integer nfssize 
inret=getvolinfo(@lproot,@lpvolname,nvolsize,@lpvolnumber,@lpmaxcomp,@lpflags,@lpfsname,nfssize) 
if inret>0 
	numeroserie=+alltrim(str(lpvolnumber))
endif 
return coder10(numeroserie,43,.t.)
*******marcar telefono con el MSCOMM.ocx
*MSCOMM.SETTINGS="9800,N,8,1"
*MSCOMM.COMMPORT=1         (Supongo el modem conectado al com1)
*MSCOMM.PORTOPEN=.T.
*MSCOMM.OUTPUT = "ATDT "+Numero+chr(13)
 *****registrarse
procedure demo
local fec,fec1
	if file ('reg.dbf')	
		if used('reg')
			sele reg
			if recc()=1
				go top
				if !empty(xxx) and !empty(yyy)
					if alltr(coder10(xxx))='VACIO' and alltr(coder10(yyy))='FECHA'
						fec=date()+30
						fec1=coder10(ceros(str(day(fec),2),2)+ceros(str(month(fec),2),2)+ceros(str(year(fec),4),4),8,.t.)
						repl yyy with fec1
					endif
				else
					messagebox('Registro de Sistema Adulterado.'+chr(13)+'Comuniquese con All Soft.',48,'Control')	
					quit					
				endif	
			else
				messagebox('Registro de Sistema Adulterado.'+chr(13)+'Comuniquese con All Soft.',48,'Control')	
				quit
			endif	
		else
			use reg in 0
			sele reg
			if recc()=1
				go top
				if !empty(xxx) and !empty(yyy)
					if alltr(coder10(xxx))=='VACIO' and alltr(coder10(yyy))=='FECHA'
						fec=date()+30
						fec1=coder10(ceros(str(day(fec),2),2)+ceros(str(month(fec),2),2)+ceros(str(year(fec),4),4),8,.t.)
						repl yyy with fec1
					endif
					use
				else
					messagebox('Registro de Sistema Adulterado.'+chr(13)+'Comuniquese con All Soft.',48,'Control')	
					quit					
				endif	
			else
				messagebox('Registro de Sistema Adulterado.'+chr(13)+'Comuniquese con All Soft.',48,'Control')	
				quit
			endif	
		endif	
	else
		messagebox('No se encuentra registro de Sistema.'+chr(13)+'Comuniquese con All Soft.',48,'Control')	
		quit
	endif	
endproc
function registrado 
	if file ('reg.dbf')	
		if used('reg')
			sele reg
			go top
			if alltr(coder10(xxx,.f.))==alltr(alltr(coder10(encriptaserie()))+'ALLSOFT')
				return .t.
			else	
				fec=coder10(reg.yyy,.f.)
				fecsys=ctod(left(fec,2)+"/"+substr(fec,3,2)+"/"+right(fec,4))
				if fecsys>=date()
					return .t.
				else
					return .f.	
				endif
			endif
		else
			use reg in 0
			go top
			if alltr(coder10(xxx,.f.))==alltr(alltr(coder10(encriptaserie()))+'ALLSOFT')
				return .t.
			else	
				fec=coder10(reg.yyy,.f.)
				fecsys=ctod(left(fec,2)+"/"+substr(fec,3,2)+"/"+right(fec,4))
				if fecsys>=date()
					return .t.
				else
					return .f.	
				endif
			endif
			use
		endif	
	endif		
return .t.	
function registrado1 
	if file ('reg.dbf')	
		if used('reg')
			sele reg
			go top
			if alltr(coder10(xxx,.f.))==alltr(alltr(coder10(encriptaserie()))+'ALLSOFT')
				return .t.
			else	
				return .f.
			endif
		else
			use reg in 0
			go top
			if alltr(coder10(xxx,.f.))==alltr(alltr(coder10(encriptaserie()))+'ALLSOFT')
				return .t.
			else	
				return .f.
			endif
			use
		endif	
	endif		
return .t.

********capturar errores
procedure errores
parameter merror, mess, mess1, mprog, mlineno
if merror=15
	mess='Archivo no valido'
	messagebox('¡ '+mess+' !',16,'Error')
	close data
	*do restauraresu
	quit
endif


messagebox('¡ '+mess+' !',16,'Error')
function impresora &&devuelve 0 si esta la impresora Laser 1 si esta la matriz 
     			   &&2 si estan las dos 3 si no hay impresora
store 0 to mat,las
if aprinters(Impresoras) > 0  
	for i = 1 to alen(Impresoras,1)
		if alltr(impresoras(i,1))=="matriz"
			mat=1
		endif
		if alltr(impresoras(i,1))=="laser"
			las=1
		endif
	endfor
	if mat+las=2
		return 2
	else
		if mat=1
			return 1
		else
			return 0	
		endif	
	endif
else  
  return 3
endif
**********************valida cuit
function validarcuit
parameter numcuit
local suma,retorno
store 0 to suma
if empty(numcuit)
	retorno=.t.
else
	if type('numcuit')='C' and len(numcuit)=11
		suma=val(subs(numcuit,10,1))*2+val(subs(numcuit,9,1))*3+;
		     val(subs(numcuit,8,1))*4+val(subs(numcuit,7,1))*5+ ;
		     val(subs(numcuit,6,1))*6+val(subs(numcuit,5,1))*7+ ;
		     val(subs(numcuit,4,1))*2+val(subs(numcuit,3,1))*3+ ;
		     val(subs(numcuit,2,1))*4+val(subs(numcuit,1,1))*5
		     a=(mod(suma,11))
		     b=11-mod(suma,11)	
		if a=0     
			if val(subs(numcuit,11,1))=a
				retorno=.t.
			else
				retorno=.f.	
			endif
		else
			if val(subs(numcuit,11,1))=b
				retorno=.t.
			else
				retorno=.f.	
			endif
		endif	
	else
		retorno=.f.
	endif		      
	return retorno
	endif
endfunc	


*** --------------------------------------------------- ***
function vercod
parameter bas,cod,ind
actual=select(0)
enuso=used(bas)
if !enuso
	use (bas) in 0 
	sele (bas)
	if parameter()=3	
		set order to &ind
	else	
		set	order to codigo
	endif	
else
	sele (bas)
	reg=iif(eof() or bof(),1,recno())
	cdx=tag()
	fil=filter()
	set filter to
	if parameter()=3	
		set order to &ind
	else	
		set	order to codigo
	endif	
endif
sele (bas)
seek cod
nom=nombre
if !enuso
	sele (bas)
	use
else
	sele (bas)
	if len(allt(fil))#0
		a=fil
		set filter to &a
	endif	
	if len(allt(cdx))#0
		set order to (cdx)
	endif	
	go record (reg)
endif
sele (actual)
return nom 

*** ------------------------------------------------------------------------------------- ***
FUNCTION mayoriza
PARAMETERS _cuen,_alc && if _alc="T" es todo sin filtrar por tipo
PRIVATE _cer, _niv ,_padre,_per
Store 0 to _cer

FOR i=1 TO 12 STEP 2
  IF val(SUBSTR(_cuen,i,2))=0
     _cer=_cer+1
  endif
endfor 

_niv = 6 - _cer
_dig = _niv * 2
_padre = Left(Alltrim(_cuen),_dig)
*_per=_periodo
If Alltrim(_alc)#"T"
*	SELECT * ,sum(importe) as mayor from movimientos  ;
	WHERE codper=_per and  Left(cod_cuenta,_dig)=_padre and cod_estado=Alltrim(_alc) and !desafec ;
	into cursor ConMayor
	SELECT * ,sum(importe) as mayor from movicont  ;
	WHERE Left(codigo,_dig)=_padre ;
	into cursor ConMayor	
Else
*	SELECT * ,sum(importe) as mayor from movimientos  ;
	WHERE codper=_per and  Left(cod_cuenta,_dig)=_padre and !desafec;
	into cursor ConMayor		
	SELECT * ,sum(importe) as mayor from movicont  ;
	WHERE Left(codigo,_dig)=_padre ;
	into cursor ConMayor			
Endif	
Select ConMayor
Return ConMayor.mayor


FUNCTION ArbolCrearRamas
PARAMETERS _cuenta
PRIVATE _nivel,_tope,_i,_k,_carac
PUBLIC _espacio as String 
*_nivel=ArbolCalcularNivel(_cuenta,12,0)
_nivel=ArbolCalcularNivel(_cuenta,6,0)
_espacio=""
DO case
	CASE _nivel=1
		_espacio=CHR(43)+" "
	CASE _nivel>1
		_carac="|"+"-- "
		FOR _i=1 TO _nivel-1
			_espacio=_espacio+"|"+"    "
		ENDFOR 
		_espacio=_espacio+_carac
ENDCASE
_espacio=_espacio+SUBSTR(_cuenta,1,2)+"."+;
SUBSTR(_cuenta,3,2)+"."+;
SUBSTR(_cuenta,5,2)+"."+;
SUBSTR(_cuenta,7,2)+"."+;
SUBSTR(_cuenta,9,2)+"."+;
SUBSTR(_cuenta,11,2)
RETURN _espacio
ENDFUNC
*** Fer------------------------------------------------------------------------------------- ***
FUNCTION ArbolCalcularNivel
PARAMETERS _cuenta as String ,_maximo as Number,_nivel as Number 
PRIVATE _numero
IF _maximo>0
	_numero=VAL(_cuenta)
	IF _numero%(10**_maximo)#0
		RETURN ArbolCalcularNivel(_cuenta,_maximo-2,_nivel+1)
	ENDIF
ENDIF
return _nivel
endfunc
*** Fer------------------------------------------------------------------------------------- ***
FUNCTION Ramas
PARAMETERS _cuenta,_long as numbre
PRIVATE _nivel,_tope,_i,_k,_carac
PUBLIC _espacio as String 
_nivel=Nivel(_cuenta,_long,0)
_espacio=""
DO case
	CASE _nivel=1
		_espacio=CHR(43)+" "
	CASE _nivel>1
		_carac="|"+"-- "
		FOR _i=1 TO _nivel-1
			_espacio=_espacio+"|"+"    "
		ENDFOR 
		_espacio=_espacio+_carac
ENDCASE
RETURN _espacio
ENDFUNC
*** Fer------------------------------------------------------------------------------------- ***
FUNCTION Nivel
PARAMETERS _cuenta as String ,_maximo as Number,_nivel as Number 
PRIVATE _numero
IF _maximo>0
	_numero=VAL(_cuenta)
	IF _numero%(10**_maximo)#0
		RETURN Nivel(_cuenta,_maximo-1,_nivel+1)
	ENDIF
ENDIF
return _nivel
ENDFUNC
*** Fer------------------------------------------------------------------------------------- ***
FUNCTION BuscarResultado
PARAMETERS _reccount as number ,_reg as Number,_Ini as Boolean(.f.)
PRIVATE cod_act,cod_sig,_niv_act,_niv_sig
PUBLIC XXCuentaResultado as Cursor,XXCuenta as Cursor  
IF _Ini=.f.
	SELECT * from det_cuentas_resultado INTO CURSOR XXCuentaResultado readwrite
	DELETE from XXCuentaResultado where !EMPTY(r)
	SELECT codigo FROM cuentas ORDER BY codigo INTO CURSOR XXCuentas
	SELECT XXCuentas
	_r=reccount()
	BuscarResultado(_r,1,.t.)
ELSE
	IF _reg<_reccount && Si no ha llegado al fin lateral o vertical
		SELECT XXCuentas 
		GO record _reg 
		cod_act=XXCuentas.codigo
		GO record (_reg+1)
		cod_sig=XXCuentas.codigo
		_niv_act=ArbolCalcularNivel(cod_act,12,0)
		_niv_sig=ArbolCalcularNivel(cod_sig,12,0)
		IF _niv_act>=_niv_sig && Llegue a una cuenta de resultado
			SELECT XXCuentaResultado
			APPEND BLANK 
			replace codigo WITH cod_act
			replace R WITH _reg
		ENDIF
		BuscarResultado(_reccount,_reg+1,.t.)
	ELSE
		SELECT XXCuentaResultado
		APPEND BLANK 
		replace codigo WITH XXCuentas.Codigo
		replace R WITH _reg
	ENDIF
endif
ENDFUNC 
*** Fer------------------------------------------------------------------------------------- ***
FUNCTION RangoPalabras
PARAMETERS _CadDato as string,_CadTabla as String 
PRIVATE _tope,_i
	IF LEN(alltrim(_CadDato))#0
		_cadDato=ALLTRIM(_cadDato)
		_cadTabla=ALLTRIM(_cadTabla)
		_tope=LEN(_cadDato)+1
		_i=1
		DO WHILE _i<_tope AND UPPER(SUBSTR(_cadDato,_i,1))==UPPER(SUBSTR(_cadTabla,_i,1))
		_i=_i+1
		ENDDO
		_cadDato=""
		_cadTabla=""
		IF _i=_tope
			RETURN .t.
		ELSE
			RETURN .f.
		ENDIF		
	ELSE
		RETURN .f.
	ENDIF
ENDFUNC
*** Fer------------------------------------------------------------------------------------- ***
FUNCTION ObtenerPadreDe 
PARAMETERS Cuenta1,Cuenta2
_i=2
_parar=.f.
_fin=12
STORE "" to _cad
do while _i<_fin and _parar=.f.
	SELECT ArbolCalcularNivel(cc.codigo,12,0) as nivel,cc.codigo from cuentas cc ;
	where LEFT(cc.codigo,_i)=LEFT(Cuenta1,_i) ;
	and LEFT(cc.codigo,_i)=LEFT(Cuenta2,_i) into cursor XXXXXXX
	IF RECCOUNT("XXXXXXX")#0
		_cad=LEFT(xxxxxxx.codigo,_i)
		_i=_i+2
	ELSE
		_parar=.t.
	ENDIF
ENDDO
FOR _k=(LEN(_cad)+1) to 12
	_cad=_cad+"0"
ENDFOR
	return _cad
ENDFUNC

FUNCTION CalculaPadre
PARAMETERS _cuen
PRIVATE _cer, _niv ,_padre,_per
Store 0 to _cer

FOR i=1 TO 6 STEP 2
  IF val(SUBSTR(_cuen,i,2))=0
     _cer=_cer+1
  endif
endfor 
_niv = 3 - _cer
_dig = _niv * 2
*if _dig=6
*	_padre = "      "
*else
	_padre = Left(Alltrim(_cuen),_dig)+ceros("0",_niv)
*EndIf	

?"cer" + str(_cer)
?"niv" + str(_niv)
?"dig" + str(_dig)
?"padre"+_padre+" - "

return _padre


Function comprobar1 (perf As String, nIdPad As Integer) As string
	Actual=Select(0)
	Enuso1=Used("niveles")
	Enuso2=Used("perfiles")
	If !Enuso1
		Use Niveles In 0 Alias Niveles
	Endif
	If !Enuso2
		Use Perfiles In 0 Alias Perfiles
	Endif
	Select Niveles
	Set Order To NIVPAD   && NIVEL+ALLTRIM(STR(IDPAD))
	Select Perfiles
	Set Order To Codigo
	Seek perf
	Scan While Codigo=perf
		Select Niveles
		Seek Perfiles.Nivel+Alltrim(Str(nIdPad))
		If Found()
			Select (Actual)
			Return ".F."
		EndIf
	Endscan
	Select (Actual)
	Return ".T." 
EndFunc

Function nivel_cuenta (_cuenta as String)
store 0 to _nivel
if val(_cuenta)=0
	return 1
endif
for k= 1 to 6
	if Left(right(_cuenta,k),1)="0"
		_nivel=_nivel+1
	else
		return 7-_nivel	
	endif
endfor
return 7-_nivel	