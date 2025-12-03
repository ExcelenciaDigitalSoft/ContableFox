set alternate to recibir.ftp
set alternate on
set console off
? "open ftp.fortunecity.es"
? "allsoft"
? "ijsmnbqu"
? "cd /circulo"
? "get xs.txt"
? "quit"
set console on
set alternate off
set alternate to
RUN ftp -s:recibir.ftp >resultado.txt
