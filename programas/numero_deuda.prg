close table all
num=0
numero=space(14)
use deuda in 1 
go top
scan
	num=num+1
	numero="SA0001"+ceros(str(num,8),8)
	repl numfac with numero
endscan
go top
brows
close table all