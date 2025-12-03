close table all
USE obras_sociales In 1 Alias ob excl
USE c:\bioquimicos\obras In 2 Alias obras
Select ob 
Zap
Select obras
Go top
Scan
	Scatter memvar
	m.direccion=m.domicilio	
	Select ob
	Append Blank
	Gather memvar
	Select obras
EndScan
Select ob
brows
Close TABLES all
