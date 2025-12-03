SET SYSMENU TO
SET SYSMENU AUTOMATIC
Close Tables all

Use Menu_Osp In 0 Alias MenuBar
*Use men_prueba In 0 Alias MenuBar
Select MenuBar
Set Order To Menu
nRegistro=0
Do While Not Eof()
	Define Pad ("_"+Alltrim(Str(IdPad))) Of _MSYSMENU ;
		PROMPT ALLTRIM(Prompt) MESSAGE ALLTRIM(Message)
	nRegistro=Recno()
	DO DefinePop WITH popname, "_"+Alltrim(Str(IdPad)),clave
	Select MenuBar
	Set Order To Menu
	Go Record nRegistro
	Skip
Enddo
Close Tables All
*-----------------------------------------------------------------*
PROCEDURE DefinePop
Lparameters cPopup, cPadName, cPadre
cPopup = ALLTRIM(cPopup)
cPadName = ALLTRIM(cPadName)
cOldAlias = ALIAS()

DEFINE POPUP (cPopup) RELATIVE MARGIN
ON PAD (cPadName) OF _MSYSMENU ACTIVATE POPUP (cPopup)

Do Expande With cPadre, cPopup
 
IF !EMPTY(cOldAlias)
	SELECT (cOldAlias)
EndIf
Return
*-----------------------------------------------------------------*
Procedure Expande
Lparameters cPadre,cPop
*MessageBox(cPadre,CPop)
LOCAL cAction, cPad, cKey, cDefineString, cPicture, nReg, cDefinePop

Select MenuBar
Set Order To PADRE   && PADRE+CLAVE
Set Near On
Seek cPadre
Set Near off
*brows
Scan While Padre=cPadre
	If !Empty(Padre)
		*Wait windows menubar.padre nocon 
		nReg=Recno()
		cAction = ALLTRIM(Action)
		cBar = ALLTRIM(Right(Clave,2))
		cKey = ALLTRIM(hotkey)
		cPicture = Alltrim(Picture)
		Set Exact On
		cSkipFor = Comprobar1(_Perfil,IdPad)
		Set Exact Off
		Select MenuBar
		If Right(cPadre,2)!="00"
			*MessageBox(MenuBar.prompt)
			cDefineString = "DEFINE BAR " + cBar + ;
			" OF " + MenuBar.PopName + ;
			" PROMPT '" + ALLTRIM(MenuBar.prompt) + "'"
			IF !EMPTY(cKey)
				cDefineString = cDefineString + " KEY " + cKey
			ENDIF
			IF !EMPTY(cSkipFor)
				cDefineString = cDefineString + " SKIP FOR " + cSkipFor
			ENDIF
			IF !EMPTY(cPicture)
				cDefineString = cDefineString + " PICTURE " + cPicture
			ENDIF
			&cDefineString
*			?"-"+DefineString
		Else
			*MessageBox("S")
			If Len(Alltrim(Padre))=0
				cBar=Substr(Clave,2,2)
			Endif
			cDefineString = "DEFINE BAR " + cBar + ;
			" OF " + cPop + ;
			" PROMPT '" + ALLTRIM(prompt) + "'"
			IF !EMPTY(cKey)
				cDefineString = cDefineString + " KEY " + cKey
			ENDIF
			IF !EMPTY(cSkipFor)
				cDefineString = cDefineString + " SKIP FOR " + cSkipFor
			ENDIF
			IF !EMPTY(cPicture)
				cDefineString = cDefineString + " PICTURE '" + cPicture + "'"
			ENDIF
			&cDefineString
*			?cDefinePop
			ON SELECTION BAR &cBar of (cPop) &cAction
			*brows
			*?cBar+" -- "+cPop+" -- "+cAction
		Endif
		If Len(Alltrim(PadNum))=0 And Len(Alltrim(PopName))#0
		 	cDefinePop="ON BAR " + cBar +" OF " + Alltrim(cPop);
				+ " Activate Popup " + Alltrim(PopName)
				&cDefinePop
				*?cDefinePop
				DEFINE POPUP (Alltrim(PopName)) RELATIVE MARGIN
		Endif
		Do Expande With Clave,cPop
		Go Record nReg
	Endif
Endscan
Endproc
