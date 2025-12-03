******* Controlo Factura contra Contablilidad *******
close table all
clear
store 0 to dife
use movicont in 1
use faccom in 2 order numero
select movicont 
set filte to codigo="211010"
go top
scan
     select faccom
     Seek Right(movicont.faccom,6)+Left(movicont.faccom,14)
     if found()
         if movicont.importe#faccom.total
             dife=movicont.importe-faccom.total
             ?"Total Contable: "+str(movicont.importe,10,2)+" Total Factura: "+str(faccom.total,10,2)+" Diferencia : "+str(dife,10,2)
             ?movicont.NroAsiento
             *repl faccom.total with movicont.importe
         endif
     endif
     select movicont
endscan
select movicont
set filte to 
close table all