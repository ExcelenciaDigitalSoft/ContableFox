close table all
use deuda in 1
sele 1
set filter to mes_letra="02/03          "
repl all mes with "02"
repl all año with "2003"
repl all periodo with año+mes
brows
close table all