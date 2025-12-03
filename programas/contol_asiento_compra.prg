close table all
use movicont in 1 order faccom
use faccom in 2
select 2
go top
scan
	sele 1
	seek faccom.numero+faccom.proveedor
	do while not eof() and faccom=faccom.numero+faccom.proveedor
	
	enddo
	sele faccom
endscan
close table all