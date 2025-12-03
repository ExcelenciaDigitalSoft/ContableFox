
set default to h:\conta-upcn
set path to h:\conta-upcn
*set defa to F:\Conta-UPCN
*set path to F:\Conta-UPCN
clear all
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
if !directory("C:\temp")
	md c:\temp
endif
if ! apli_activa('Sistema de Gestión Administrativa')
	WITH _Screen
		.LockScreen=.T.                     && Desactiva el redibujado de pantalla
	   	.BackColor=rgb(192,192,192)         && Cambiar el color de fondo a gris
	   	.picture='fondo_principal.jpg'
	   	.BorderStyle=2                      && Cambiar el borde a doble
	   	.Closable=.F.                       && Quitar botones de control de ventana
	   	.ControlBox=.T.
	   	.MaxButton=.t.
	   	.MinButton=.T.
	   	.Movable=.F.
	    .icon='TRANSFRM.ico'
	   	.Caption='Sistema de Gestión Administrativa'
	   	.LockScreen=.F.                     && Activa el redibujado de pantalla
	   	.windowstate=2
	ENDWITH
	open data cooperativa
	do form op1
	read event
	close data
	clear all
	quit
endif