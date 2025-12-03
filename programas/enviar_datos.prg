set alternate to enviar.ftp
set alternate on
set console off
? "open ftp.fortunecity.es"
? "allsoft"
? "ijsmnbqu"
? "cd /odontologos"
? "send c:\programas\odonto\fac.txt"
? "quit"
set console on
set alternate off
set alternate to
RUN ftp -s:enviar.ftp >resultado.txt
