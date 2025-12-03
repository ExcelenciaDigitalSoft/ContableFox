lcServer="terminal1"
lcDatabase="cooperativa"
lcUser = ""
lcPassword = ""
lcStringConn="Driver={MySQL ODBC 3.51 Driver};Port=3306"+;
             ";Server="+lcServer+;
             ";Database="+lcDatabase+;
             ";Uid="+lcUser+;
             ";Pwd="+lcPassWord
***Evitar que aparezca  la ventana de login 
SQLSETPROP(0,"DispLogin",3)
lnHandle=SQLSTRINGCONNECT(lcStringConn)
IF lnHandle > 0
   ?SQLTABLES(lnHandle,"TABLES")
   brow
   SQLDISCONNECT(lnHandle)
ELSE
   =AERROR(laError)
   MESSAGEBOX("Error de conexión"+CHR(13)+;
              "Descripcion:"+laError[2])
ENDIF

