Close Tables all 
USE detacont In 0
USE movicont In 0
USE movimientos_bancos In 0
_periodosele ='202201'
SELECT detacont
SET FILTER TO periodo = _periodosele AND LEN(ALLTRIM(unico)) = 0
COUNT TO vacio
IF vacio > 0
    MESSAGEBOX("El sistema relaciona los datos por campo Unico, y se encontraron asientos que no poseen cargado este Valor", 48, "Control")
    RETURN
ENDIF
tcPeriodo=_periodosele 
    
    LOCAL lnErrores, lnAdvertencias, lcMensaje, lcDetalle
    LOCAL lnDetaSinMovi, lnMoviSinDeta, lnBancosSinDeta, lnInconsistencias
    
    STORE 0 TO lnErrores, lnAdvertencias, lnDetaSinMovi, lnMoviSinDeta
    STORE 0 TO lnBancosSinDeta, lnInconsistencias
    STORE "" TO lcMensaje, lcDetalle
    
    IF EMPTY(tcPeriodo)
        tcPeriodo = _periodosele
    ENDIF
    
    WAIT WINDOW "Validando integridad de datos..." NOWAIT
    
    *-- ========================================================================
    *-- 1. CREAR CURSOR TEMPORAL PARA REPORTE DE ERRORES
    *-- ========================================================================
    CREATE CURSOR curErrores (;
        tipo C(15), ;
        tabla C(20), ;
        unico C(20), ;
        nroasiento C(10), ;
        nuevo_nro C(10), ;
        descripcion C(250))
    
    *-- ========================================================================
    *-- 2. VALIDAR DETACONT vs MOVICONT
    *-- ========================================================================
    SELECT detacont
    SET FILTER TO periodo = tcPeriodo
    GO TOP
    
    SCAN
        LOCAL lcUnico, lcNuevoNro
        lcUnico = detacont.unico
        lcNuevoNro = detacont.nuevo_nro
        
        *-- Verificar que tenga nuevo_nro asignado
        IF EMPTY(lcNuevoNro)
            lnAdvertencias = lnAdvertencias + 1
            INSERT INTO curErrores VALUES (;
                "ADVERTENCIA", ;
                "detacont", ;
                lcUnico, ;
                detacont.nroasiento, ;
                "", ;
                "Asiento sin nuevo_nro asignado")
            LOOP
        ENDIF
        
        *-- Buscar movimientos correspondientes en movicont
        SELECT movicont
        SET FILTER TO periodo = tcPeriodo
        SET ORDER TO unico
        SEEK lcUnico
        
        IF !FOUND()
            lnErrores = lnErrores + 1
            lnDetaSinMovi = lnDetaSinMovi + 1
            INSERT INTO curErrores VALUES (;
                "ERROR CRITICO", ;
                "detacont", ;
                lcUnico, ;
                detacont.nroasiento, ;
                lcNuevoNro, ;
                "Asiento en detacont SIN movimientos en movicont")
        ELSE
            *-- Verificar que TODOS los movimientos tengan el mismo nuevo_nro
            LOCAL llInconsistencia
            llInconsistencia = .F.
            
            SCAN WHILE unico = lcUnico
                IF movicont.nuevo_nro != lcNuevoNro
                    llInconsistencia = .T.
                    lnInconsistencias = lnInconsistencias + 1
                    INSERT INTO curErrores VALUES (;
                        "ERROR", ;
                        "movicont", ;
                        lcUnico, ;
                        movicont.nroasiento, ;
                        movicont.nuevo_nro, ;
                        "Nuevo_nro en movicont (" + ALLTRIM(movicont.nuevo_nro) + ;
                        ") NO coincide con detacont (" + ALLTRIM(lcNuevoNro) + ")")
                ENDIF
            ENDSCAN
            
            IF llInconsistencia
                lnErrores = lnErrores + 1
            ENDIF
        ENDIF
        
        SELECT detacont
    ENDSCAN
    
    *-- ========================================================================
    *-- 3. VALIDAR MOVICONT HUÉRFANOS (sin detacont)
    *-- ========================================================================
    SELECT movicont
    SET FILTER TO periodo = tcPeriodo
    SET ORDER TO unico
    GO TOP
    
    LOCAL lcUnicoAnt
    lcUnicoAnt = ""
    
    SCAN
        *-- Solo verificar una vez por unico
        IF movicont.unico = lcUnicoAnt
            LOOP
        ENDIF
        
        lcUnicoAnt = movicont.unico
        
        SELECT detacont
        SET ORDER TO unico
        SEEK lcUnicoAnt
        
        IF !FOUND()
            lnErrores = lnErrores + 1
            lnMoviSinDeta = lnMoviSinDeta + 1
            INSERT INTO curErrores VALUES (;
                "ERROR", ;
                "movicont", ;
                lcUnicoAnt, ;
                movicont.nroasiento, ;
                movicont.nuevo_nro, ;
                "Movimientos en movicont SIN asiento en detacont")
        ENDIF
        
        SELECT movicont
    ENDSCAN
    
    *-- ========================================================================
    *-- 4. VALIDAR MOVIMIENTOS_BANCOS
    *-- ========================================================================
    SELECT movimientos_bancos
    SCAN FOR !EMPTY(nuevo_asiconci)
        LOCAL lcPeriodoBanco, lcNroAsientoBanco
        
        *-- Extraer periodo y nro de asiento del nuevo_asiconci
        lcPeriodoBanco = LEFT(nuevo_asiconci, LEN(tcPeriodo))
        lcNroAsientoBanco = SUBSTR(nuevo_asiconci, LEN(tcPeriodo) + 1)
        
        IF lcPeriodoBanco = tcPeriodo
            *-- Verificar que exista en detacont
            SELECT detacont
            SET FILTER TO periodo = tcPeriodo
            LOCATE FOR nuevo_nro = lcNroAsientoBanco
            
            IF !FOUND()
                lnErrores = lnErrores + 1
                lnBancosSinDeta = lnBancosSinDeta + 1
                INSERT INTO curErrores VALUES (;
                    "ERROR", ;
                    "movimientos_bancos", ;
                    "", ;
                    movimientos_bancos.asiconci, ;
                    movimientos_bancos.nuevo_asiconci, ;
                    "Movimiento banco con asiconci que NO existe en detacont")
            ENDIF
        ENDIF
        
        SELECT movimientos_bancos
    ENDSCAN
    
    *-- ========================================================================
    *-- 5. VALIDAR NUMERACIÓN SECUENCIAL (sin saltos)
    *-- ========================================================================
    SELECT nuevo_nro, COUNT(*) AS cant ;
        FROM detacont ;
        WHERE periodo = tcPeriodo AND !EMPTY(nuevo_nro) ;
        GROUP BY nuevo_nro ;
        INTO CURSOR curNumeracion
    
    GO TOP
    SCAN
        IF cant > 1
            lnErrores = lnErrores + 1
            INSERT INTO curErrores VALUES (;
                "ERROR", ;
                "detacont", ;
                "", ;
                "", ;
                nuevo_nro, ;
                "Número de asiento DUPLICADO (" + ALLTRIM(STR(cant)) + " veces)")
        ENDIF
    ENDSCAN
    
    *-- Verificar secuencia
    SELECT DISTINCT nuevo_nro FROM detacont ;
        WHERE periodo = tcPeriodo AND !EMPTY(nuevo_nro) ;
        ORDER BY nuevo_nro ;
        INTO CURSOR curSecuencia
    
    LOCAL lnNumAnt, lnNumAct, lnSaltos
    lnSaltos = 0
    lnNumAnt = 0
    
    GO TOP
    SCAN
        lnNumAct = VAL(nuevo_nro)
        IF lnNumAnt > 0 AND lnNumAct - lnNumAnt > 1
            lnSaltos = lnSaltos + 1
            lnAdvertencias = lnAdvertencias + 1
            INSERT INTO curErrores VALUES (;
                "ADVERTENCIA", ;
                "detacont", ;
                "", ;
                "", ;
                PADL(ALLTRIM(STR(lnNumAnt + 1)), 6, "0"), ;
                "Salto en numeración: de " + ALLTRIM(STR(lnNumAnt)) + ;
                " a " + ALLTRIM(STR(lnNumAct)))
        ENDIF
        lnNumAnt = lnNumAct
    ENDSCAN
    
    WAIT CLEAR
    
    *-- ========================================================================
    *-- 6. GENERAR REPORTE DE RESULTADOS
    *-- ========================================================================
    lcMensaje = "=== RESULTADO DE VALIDACIÓN ===" + CHR(13) + CHR(13)
    lcMensaje = lcMensaje + "Periodo: " + tcPeriodo + CHR(13) + CHR(13)
    
    IF lnErrores = 0 AND lnAdvertencias = 0
        lcMensaje = lcMensaje + "? VALIDACIÓN EXITOSA" + CHR(13)
        lcMensaje = lcMensaje + "No se encontraron errores ni inconsistencias." + CHR(13)
        MESSAGEBOX(lcMensaje, 64, "Validación Correcta")
    ELSE
        lcMensaje = lcMensaje + "RESUMEN:" + CHR(13)
        lcMensaje = lcMensaje + "- Errores Críticos: " + ALLTRIM(STR(lnErrores)) + CHR(13)
        lcMensaje = lcMensaje + "- Advertencias: " + ALLTRIM(STR(lnAdvertencias)) + CHR(13) + CHR(13)
        
        IF lnDetaSinMovi > 0
            lcMensaje = lcMensaje + "- Asientos en detacont sin movicont: " + ALLTRIM(STR(lnDetaSinMovi)) + CHR(13)
        ENDIF
        
        IF lnMoviSinDeta > 0
            lcMensaje = lcMensaje + "- Movimientos en movicont sin detacont: " + ALLTRIM(STR(lnMoviSinDeta)) + CHR(13)
        ENDIF
        
        IF lnBancosSinDeta > 0
            lcMensaje = lcMensaje + "- Mov. bancos sin asiento en detacont: " + ALLTRIM(STR(lnBancosSinDeta)) + CHR(13)
        ENDIF
        
        IF lnInconsistencias > 0
            lcMensaje = lcMensaje + "- Inconsistencias nuevo_nro: " + ALLTRIM(STR(lnInconsistencias)) + CHR(13)
        ENDIF
        
        lcMensaje = lcMensaje + CHR(13) + "¿Desea ver el detalle de errores?"
        
        IF MESSAGEBOX(lcMensaje, 52, "Errores Encontrados") = 6
            MostrarDetalleErrores()
        ENDIF
    ENDIF
    
    *-- Limpiar filtros
    SELECT detacont
    SET FILTER TO
    SELECT movicont
    SET FILTER TO
    
    RETURN (lnErrores = 0)
ENDPROC

*-- ============================================================================
*-- PROCEDIMIENTO PARA MOSTRAR DETALLE DE ERRORES
*-- ============================================================================
PROCEDURE MostrarDetalleErrores
    SELECT curErrores
    GO TOP
    
    IF RECCOUNT() = 0
        RETURN
    ENDIF
    
    *-- Crear formulario para mostrar errores
    LOCAL oForm
    oForm = CREATEOBJECT("Form")
    oForm.Caption = "Detalle de Errores de Validación"
    oForm.Width = 900
    oForm.Height = 500
    oForm.AutoCenter = .T.
    
    *-- Grid para mostrar errores
    LOCAL oGrid
    oGrid = CREATEOBJECT("Grid")
    oGrid.Top = 10
    oGrid.Left = 10
    oGrid.Width = oForm.Width - 30
    oGrid.Height = oForm.Height - 90
    oGrid.RecordSource = "curErrores"
    oGrid.ReadOnly = .T.
    oGrid.DeleteMark = .F.
    oGrid.AllowAddNew = .F.
    
    *-- Configurar columnas
    oGrid.Column1.Header1.Caption = "Tipo"
    oGrid.Column1.Width = 100
    oGrid.Column2.Header1.Caption = "Tabla"
    oGrid.Column2.Width = 100
    oGrid.Column3.Header1.Caption = "Único"
    oGrid.Column3.Width = 120
    oGrid.Column4.Header1.Caption = "Nro Asiento"
    oGrid.Column4.Width = 80
    oGrid.Column5.Header1.Caption = "Nuevo Nro"
    oGrid.Column5.Width = 80
    oGrid.Column6.Header1.Caption = "Descripción"
    oGrid.Column6.Width = 380
    
    oForm.AddObject("grdErrores", oGrid.Class)
    oForm.grdErrores = oGrid
    
    *-- Botón Cerrar
    LOCAL oBtnCerrar
    oBtnCerrar = CREATEOBJECT("CommandButton")
    oBtnCerrar.Caption = "Cerrar"
    oBtnCerrar.Top = oForm.Height - 60
    oBtnCerrar.Left = (oForm.Width - 100) / 2
    oBtnCerrar.Width = 100
    oBtnCerrar.Height = 30
    
    oForm.AddObject("btnCerrar", oBtnCerrar.Class)
    oForm.btnCerrar = oBtnCerrar
    
    oForm.Show(1)
ENDPROC

*-- ============================================================================
*-- EJEMPLO DE USO
*-- ============================================================================
*-- ValidarRenumeracion("202401")
*-- o simplemente
*-- ValidarRenumeracion()  && usa _periodosele