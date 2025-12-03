SET ENGINEBEHAVIOR 70
public _codden,volver,informe,volver,c_salida,c_entrada,cod_op,nom_op,niv_op
Public NomEmp,DirEmp,TelEmp,CuitEmp,BrutosEmp,_perfil
Store "" to NomEmp,DirEmp,TelEmp,CuitEmp,BrutosEmp
Public _idsesion,_idnumero,_periodosele,_periododesde,_periodohasta

Store '' to _idsesion,_periodosele
Store 0 to _idnumero
store {} to _periododesde,_periodohasta

NomEmp="UPCN - San Juan"
DirEmp="Sarmiento 461 -Sur-"
TelEmp=""
CuitEmp=""
BrutosEmp=""
_codden=space(5)
c_salida=rgb(255,255,255)
c_entrada=rgb(255,255,230)
niv_op=0
store 0 to volver,informe,volver
c_salida=rgb(255,255,255)
c_entrada=rgb(255,255,230)
on key label SHIFT+F12 do form contraseña
*on key label F7 do form op
*on key label SHIFT+F8 set sysmenu to default
set proc to proced

