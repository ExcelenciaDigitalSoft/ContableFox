DEFINE CLASS DataTier AS Custom
AccessMethod = []	
_cone = ""
*Select coder10(usuariosql) as usuario,coder10(ClaveSQL)as clave,servidor,bdSQL from parametros into cursor parSQL
*Conexion Para CPIA
*ConnectionString = [Driver={SQL Server};Server=SERVIDOR-SQL\SQLSERVER;Database=CPIA1.0;UID=SA;PWD=2178;]

*ConnectionString = [Driver={SQL Server};Server=192.168.0.99;Database=seosg2;UID=SA;PWD=ata2;]
ConnectionString = [Driver={SQL Server};Server=192.168.0.103;Database=upcn;UID=exc;PWD=Pelotin+2178;]

*Conexion para probar en mi Máquina
*ConnectionString = [Driver={SQL Server};Server=SERVIDOR2\SQLSERVER;Database=CPIA1.0;UID=SA;PWD=2178;]

Handle       = 0


PROCEDURE AccessMethod_Assign
PARAMETERS AM
DO CASE
   CASE AM = [DBF]
		THIS.AccessMethod = [DBF]	
   CASE AM = [SQL]
		THIS.AccessMethod = [SQL]	
		THIS.GetHandle
   CASE AM = [XML]
		THIS.AccessMethod = [XML]	
   CASE AM = [WC]
		THIS.AccessMethod = [WC]	
   OTHERWISE
		MESSAGEBOX( [Incorrect access method ] + AM, 16, [Setter error] )
		THIS.AccessMethod = []
ENDCASE
*_VFP.Caption = [Data access method: ] + THIS.AccessMethod
ENDPROC


PROCEDURE CreateCursor
LPARAMETERS pTable, pKeyField ,NomCursor
IF THIS.AccessMethod = [DBF]
   IF NOT USED ( pTable )
      SELECT 0
      USE ( pTable ) ALIAS ( pTable )
   ENDIF
   SELECT ( pTable )
   IF NOT EMPTY ( pKeyField )
      SET ORDER TO TAG ( pKeyField )
   ENDIF
   RETURN
ENDIF
Cmd = [SELECT * FROM ] + pTable + [ WHERE 1=2]
DO CASE
   CASE THIS.AccessMethod = [SQL]
		SQLEXEC( THIS.Handle, Cmd )
		AFIELDS ( laFlds )
		Use
		If Len(Alltrim(NomCursor))=0
			CREATE CURSOR ( pTable ) FROM ARRAY laFlds
		Else
			CREATE CURSOR ( NomCursor ) FROM ARRAY laFlds	
		EndIf	
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE


PROCEDURE GetHandle
IF THIS.AccessMethod = [SQL]
   IF THIS.Handle > 0
      RETURN
   ENDIF
   THIS.Handle = SQLSTRINGCONNECT( THIS.ConnectionString )
   IF THIS.Handle < 1
      MESSAGEBOX( [Unable to connect], 16, [SQL Connection error], 2000 )
   ENDIF
  ELSE
   Msg = [A SQL connection was requested, but access method is ] + THIS.AccessMethod
   MESSAGEBOX( Msg, 16, [SQL Connection error], 2000 )
   THIS.AccessMethod = []
ENDIF
RETURN


PROCEDURE GetMatchingRecords
LPARAMETERS pTable, pFields, pExpr
pFields = IIF ( EMPTY ( pFields ), [*], pFields )
pExpr   = IIF ( EMPTY ( pExpr ), [], ;
		  [ WHERE ] + STRTRAN ( UPPER ( ALLTRIM ( pExpr ) ), [WHERE ], [] ) )
cExpr   = [SELECT ] + pFields + [ FROM ] + pTable + pExpr
IF NOT USED ( pTable )
   RetVal = THIS.CreateCursor ( pTable )
ENDIF
DO CASE
   CASE THIS.AccessMethod = [DBF]
		&cExpr
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr >= 0
		   THIS.FillCursor()
		  ELSE
		   Msg = [Unable to return records] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
ENDCASE
ENDPROC


PROCEDURE CreateView
LPARAMETERS pTable
IF NOT USED( pTable )
   MESSAGEBOX( [Can't find cursor ] + pTable, 16, [Error creating view], 2000 )
   RETURN
ENDIF
SELECT ( pTable )
AFIELDS( laFlds )
SELECT 0
CREATE CURSOR ( [View] + pTable ) FROM ARRAY laFlds
ENDFUNC


PROCEDURE GetOneRecord
LPARAMETERS pTable, pKeyField, pKeyValue
SELECT ( pTable )
Dlm   = IIF ( TYPE ( pKeyField ) = [C], ['], [] )
IF THIS.AccessMethod = [DBF]
   cExpr = [LOCATE FOR ] + pKeyField + [=] + Dlm + TRANSFORM ( pKeyValue ) + Dlm
 ELSE
   cExpr = [SELECT * FROM ] + pTable + [ WHERE ] + pKeyField + [=] + Dlm + TRANSFORM ( pKeyValue ) + Dlm
ENDIF
DO CASE
   CASE THIS.AccessMethod = [DBF]
		&cExpr
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr >= 0
		   THIS.FillCursor( pTable )
		  ELSE
		   Msg = [Unable to return record] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE
ENDFUNC


PROCEDURE FillCursor
LPARAMETERS pTable
IF THIS.AccessMethod = [DBF]
   RETURN
ENDIF
SELECT ( pTable )
ZAP
APPEND FROM DBF ( [SQLResult] )
USE IN SQLResult
GO TOP
ENDPROC


PROCEDURE DeleteRecord
LPARAMETERS pTable, pKeyField
ForExpr  = IIF ( THIS.AccessMethod = [DBF], [ FOR ], [ WHERE ] )
KeyValue = EVALUATE ( pTable + [.] + pKeyField )
Dlm      = IIF ( TYPE ( pKeyField ) = [C], ['], [] )
*!*	IF NOT USED ( pTable )
*!*	   THIS.CreateCursor ( pTable )
*!*	   IF NOT USED ( pTable )
*!*	      RETURN
*!*	   ENDIF
*!*	ENDIF
DO CASE
   CASE THIS.AccessMethod = [DBF]
		cExpr = [DELETE FOR ] + pKeyField + [=] + Dlm + TRANSFORM ( m.KeyValue ) + Dlm
		&cExpr
		SET DELETED ON
		GO TOP
   CASE THIS.AccessMethod = [SQL]
		cExpr = [DELETE ] + pTable + [ WHERE ] + pKeyField + [=] + Dlm + TRANSFORM ( m.KeyValue ) + Dlm
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr < 0
		   Msg = [Unable to delete record] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE
ENDFUNC


PROCEDURE SaveRecord
PARAMETERS pTable, pKeyField, pAdding
IF THIS.AccessMethod = [DBF]
   RETURN
ENDIF
IF pAdding
	THIS.InsertRecord ( pTable, pKeyField )
 ELSE
	THIS.UpdateRecord ( pTable, pKeyField )
ENDIF
ENDPROC


PROCEDURE InsertRecord
LPARAMETERS pTable, pKeyField
cExpr = THIS.BuildInsertCommand ( pTable, pKeyField )
_ClipText = cExpr
DO CASE
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr < 0
		   msg = [Unable to insert record; command follows:] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE
ENDFUNC

PROCEDURE UpdateRecord
LPARAMETERS pTable, pKeyField
cExpr = THIS.BuildUpdateCommand ( pTable, pKeyField )


_ClipText = cExpr
DO CASE
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr < 0
		   msg = [Unable to update record; command follows:] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE
ENDFUNC


FUNCTION BuildInsertCommand
PARAMETERS pTable, pKeyField
Cmd = [INSERT ] + pTable + [ ( ]
FOR I = 1 TO FCOUNT()
	Fld = UPPER(FIELD(I))
	IF TYPE ( Fld ) = [G]
	   LOOP
	ENDIF


	IF Fld = UPPER(pKeyField)
	   LOOP
	ENDIF
***************************************

	Cmd = Cmd + Fld + [, ]
ENDFOR
Cmd = LEFT(Cmd,LEN(Cmd)-2) + [ ) VALUES ( ]
FOR I = 1 TO FCOUNT()
	Fld = FIELD(I)
	IF TYPE ( Fld ) = [G]
	   LOOP
	ENDIF


	IF Fld = UPPER(pKeyField)
	   LOOP
	ENDIF
***************************************

	Dta = ALLTRIM(TRANSFORM ( &Fld ))
	Dta = CHRTRAN ( Dta, CHR(39), CHR(146) )		
	Dta = IIF ( Dta = [/  /], [], Dta )
	Dta = IIF ( Dta = [.F.], [0], Dta )
	Dta = IIF ( Dta = [.T.], [1], Dta )
	Dlm = IIF ( TYPE ( Fld ) $ [CM],['],;
	      IIF ( TYPE ( Fld ) $ [DT],['],;
	      IIF ( TYPE ( Fld ) $ [IN],[],	[])))
	Cmd = Cmd + Dlm + Dta + Dlm + [, ]
ENDFOR
Cmd = LEFT ( Cmd, LEN(Cmd) -2) + [ )]  
RETURN Cmd
ENDFUNC


FUNCTION BuildUpdateCommand
PARAMETERS pTable, pKeyField
Cmd = [UPDATE ]  + pTable + [ SET ]
FOR I = 1 TO FCOUNT()
	Fld = UPPER(FIELD(I))
	IF Fld = UPPER(pKeyField)
	   LOOP
	ENDIF
	IF TYPE ( Fld ) = [G]
	   LOOP
	ENDIF
	Dta = ALLTRIM(TRANSFORM ( &Fld ))
	IF Dta = [.NULL.]
	   DO CASE
		  CASE TYPE ( Fld ) $ [CMDT]
			   Dta = []
		  CASE TYPE ( Fld ) $ [INL]
			   Dta = [0]
	   ENDCASE
	ENDIF
	Dta = CHRTRAN ( Dta, CHR(39), CHR(146) )		
	Dta = IIF ( Dta = [/  /], [], Dta )
	Dta = IIF ( Dta = [.F.], [0], Dta )
	Dta = IIF ( Dta = [.T.], [1], Dta )
	Dlm = IIF ( TYPE ( Fld ) $ [CM],['],;
	      IIF ( TYPE ( Fld ) $ [DT],['],;
	      IIF ( TYPE ( Fld ) $ [IN],[],	[])))
	Cmd = Cmd + Fld + [=] + Dlm + Dta + Dlm + [, ]
ENDFOR
Dlm = IIF ( TYPE ( pKeyField ) = [C], ['], [] )
Cmd = LEFT ( Cmd, LEN(Cmd) -2 )			;
	+ [ WHERE ] + pKeyField + [=] 		;
	+ + Dlm + TRANSFORM(EVALUATE(pKeyField)) + Dlm
RETURN Cmd
ENDFUNC


PROCEDURE SelectCmdToSQLResult
LPARAMETERS pExpr
DO CASE
   CASE THIS.AccessMethod = [DBF]
		 pExpr = pExpr + [ INTO CURSOR SQLResult]
		&pExpr
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, pExpr )
		IF lr < 0
		   Msg = [Unable to return records] + CHR(13) + pExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE
ENDFUNC

PROCEDURE SelectCmdToSQLResultMarce
LPARAMETERS pExpr
_errorSqlResult=0
DO CASE
   CASE THIS.AccessMethod = [DBF]
         pExpr = pExpr + [ INTO CURSOR SQLResult]
        &pExpr
   CASE THIS.AccessMethod = [SQL]
        lr = SQLExec ( THIS.Handle, pExpr )
        IF lr < 0
           Msg =  pExpr
           MESSAGEBOX( Msg, 16, [SQL error] )
           _errorSqlResult=1
        ENDIF
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
Endcase
Return _errorSqlResult
ENDFUNC

FUNCTION GetNextKeyValue
LPARAMETERS pTable
EXTERNAL ARRAY laVal
pTable = UPPER ( pTable )
DO CASE

   CASE THIS.AccessMethod = [DBF]
		IF NOT FILE ( [Keys.DBF] )
		   CREATE TABLE Keys ( TableName Char(20), LastKeyVal Integer )
		ENDIF
		IF NOT USED ( [Keys] )
		   USE Keys IN 0
		ENDIF
		SELECT Keys
		LOCATE FOR TableName = pTable
		IF NOT FOUND()
		   INSERT INTO Keys VALUES ( pTable, 0 )
		ENDIF
		Cmd = [UPDATE Keys SET LastKeyVal=LastKeyVal + 1 ]	;
			+ [ WHERE TableName='] + pTable + [']
		&Cmd
		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName = '] ;
			+ pTable + [' INTO ARRAY laVal]
		&Cmd
		USE IN Keys
		RETURN TRANSFORM(laVal(1))

   CASE THIS.AccessMethod = [SQL]

		Cmd = [SELECT Name FROM SysObjects WHERE Name='KEYS' AND Type='U']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF
		IF RECCOUNT([SQLResult]) = 0
		   Cmd = [CREATE TABLE Keys ( TableName Char(20), LastKeyVal Integer )]
		   SQLEXEC( THIS.Handle, Cmd )
		ENDIF
		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName='] + pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF

		IF RECCOUNT([SQLResult]) = 0
		   Cmd = [INSERT INTO Keys VALUES ('] +  pTable + [', 0 )]
		   lr = SQLEXEC( THIS.Handle, Cmd )
		   IF lr < 0
		      MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		   ENDIF
		ENDIF

		Cmd = [UPDATE Keys SET LastKeyVal=LastKeyVal + 1 WHERE TableName='] +  pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF

		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName='] +  pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF

		nLastKeyVal = TRANSFORM(SQLResult.LastKeyVal)
		USE IN SQLResult
		RETURN TRANSFORM(nLastKeyVal)

   CASE THIS.AccessMethod = [WC]
   CASE THIS.AccessMethod = [XML]

ENDCASE

PROCEDURE SelectCmdSinResultado
LPARAMETERS pExpr
DO CASE
   CASE THIS.AccessMethod = [DBF]
		 pExpr = pExpr + [ INTO CURSOR SQLResult]
		&pExpr
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, pExpr )
		IF lr < 0
		   Msg = [Unable to return records] + CHR(13) + pExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE
EndFunc


ENDDEFINE