Lparameters _codigo,_pperfil,_nivel,_nombre
_cant_parametros=parameters()

set default to v:\voleynuevo\conta-upcn
set path to v:\voleynuevo\conta-upcn

close all
set talk off
set cons off
set delete on
set status bar off
set message to
set safety off
set sysmenu off
set date to brit
set cent on
set help off
set exclusive off

on error do errores with error( ), message( ),message(1),program( ),lineno( )
do datos
USE parametros
Go Top
NomEmp=parametros.Nombre
DirEmp=parametros.Direccion
TelEmp=parametros.Telefono
CuitEmp=parametros.Cuit
BrutosEmp=parametros.brutos
Use

If !directory("C:\temp")
    md c:\temp
EndIf 
If ! apli_activa('Sistema de Gestión Administrativa')

    With _Screen
       .LockScreen=.T.                     && Desactiva el redibujado de pantalla
       .BackColor=rgb(192,192,192)         && Cambiar el color de fondo a gris
       .picture='fondo_principal.jpg'
       .BorderStyle=2                      && Cambiar el borde a doble
       .Closable=.F.                       && Quitar botones de control de ventana
       .ControlBox=.T.
       .Movable=.F.
       .icon='icon3.ico'
       .Caption='Sistema de Gestión Administrativa - UPCN VOLEY'
       .LockScreen=.F.                     && Activa el redibujado de pantalla
       .windowstate=2
       .MaxButton=.t.
 		.MinButton=.T. 	
    	If _cant_parametros<>0	  
			.titlebar=0
        endif
    EndWith 
    open data cooperativa shared
	If _cant_parametros=0
	    do form op1
	Else 
		cod_op=alltr(_codigo)
		nom_op=alltr(_nombre)
		niv_op=Val(_nivel)
		_perfil =_pperfil		
	    DO menu
	    do form sele_periodos
	    do form ver_periodo			
	EndIf 
    Read EVENTS 
    Close Databases 
    Clear  all 
    Quit 
EndIf 