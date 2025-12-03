close table all
clear
store 0 to deuda
use deuda in 1 order periodo
sele 1
go top
do while not eof() and periodo<="200105"
	deuda=deuda+cuota
	skip
enddo
close table all
?deuda
