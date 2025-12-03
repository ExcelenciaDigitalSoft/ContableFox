*-- ============================================================================
*-- BALANCE DE SUMAS Y SALDOS - VERSIÓN CORREGIDA
*-- ============================================================================
*-- Genera balance con acumulación en cuentas padre
*-- Corrige: variables no reiniciadas, lógica de acumulación, bucles infinitos
*-- ============================================================================
Set Multilocks On 
Close Tables all
USE cuencont In 0
use movicont in 0
USE detacont In 0
USE aux_sumsal In 0
Select aux_sumsal
=CursorSetProp("Buffering",5,"aux_sumsal")

desde = {01/12/2021} && Fecha desde
hasta = {30/11/2022} && Fecha hasta
IF GenerarBalanceSumasYSaldos()
     ValidarBalance()
ENDIF

    SELECT aux_sumsal
    = TABLEREVERT(.T.)
Close Tables all
Return 


PROCEDURE GenerarBalanceSumasYSaldos
    LOCAL deb, hab, sal_an, cod, _r, _sal, _deb, _hab, i
    LOCAL dFechaDesde, dFechaHasta
    
    *-- Obtener fechas del formulario
    dFechaDesde = desde
    dFechaHasta = hasta
    
    *-- Validar fechas
    IF EMPTY(dFechaDesde) OR EMPTY(dFechaHasta)
        MESSAGEBOX("Debe ingresar rango de fechas válido", 48, "Error")
        RETURN .F.
    ENDIF
    
    IF dFechaDesde > dFechaHasta
        MESSAGEBOX("La fecha desde no puede ser mayor a la fecha hasta", 48, "Error")
        RETURN .F.
    ENDIF
    
    WAIT WINDOW "Generando Balance de Sumas y Saldos..." NOWAIT
    
    *-- ========================================================================
    *-- FASE 1: INICIALIZAR TABLA TEMPORAL Y CALCULAR SALDOS POR CUENTA
    *-- ========================================================================
    SELECT aux_sumsal
    = TABLEREVERT(.T.)
    *ZAP  && Limpiar tabla temporal
    
    SELECT cuencont
    SET ORDER TO codigo
    GO TOP
    
    *-- Procesar cada cuenta del plan de cuentas
    SCAN
        cod = ALLTRIM(codigo)
        ? cod
        STORE 0 TO deb, hab, sal_an  && CRÍTICO: Reiniciar ANTES de cada cuenta
        
        *-- Buscar movimientos de esta cuenta
        SELECT movicont
        SET ORDER TO codigo
        SEEK cod
        
        IF FOUND()
            *-- Procesar todos los movimientos de esta cuenta
            SCAN WHILE codigo = cod
                *-- Movimientos dentro del período (van a debe/haber)
                IF fecha >= dFechaDesde AND fecha <= dFechaHasta
                    IF debehaber = 'D'
                        deb = deb + importe
                    ELSE
                        hab = hab + importe
                    ENDIF
                    
                *-- Movimientos anteriores al período (van a saldo anterior)
                ELSE
                    IF fecha < dFechaDesde
                        IF debehaber = 'D'
                            sal_an = sal_an + importe
                        ELSE
                            sal_an = sal_an - importe
                        ENDIF
                    ENDIF
                ENDIF
            ENDSCAN
        ENDIF
        
        *-- Guardar resultado en tabla temporal
        SELECT aux_sumsal
        APPEND BLANK
        REPLACE codigo WITH cod, ;
                detalle WITH ALLTRIM(cuencont.nombre), ;
                acumula WITH cuencont.acumuladora, ;
                suma WITH cuencont.suma, ;
                saldo_ant WITH sal_an, ;
                debe WITH deb, ;
                haber WITH hab, ;
                saldo WITH sal_an + deb - hab, ;
                nivel WITH nivel_cuenta(cuencont.suma)
        
        SELECT cuencont
    ENDSCAN
    
    *-- ========================================================================
    *-- FASE 2: ACUMULAR SALDOS EN CUENTAS PADRE (de hoja hacia raíz)
    *-- ========================================================================
    SELECT aux_sumsal
    
    *-- Marcar cuentas sin padre (raíz del árbol)
    REPLACE ALL suma WITH codigo FOR VAL(suma) = 0 OR EMPTY(suma)
    
    *-- Ordenar por nivel descendente para acumular de abajo hacia arriba
    Index On nivel tag nivel 
    SET ORDER TO nivel DESCENDING
    GO TOP
    
    *-- Variables para tracking
    LOCAL lnMaxNivel, lnNivelActual
    
    *-- Determinar nivel máximo
    GO BOTTOM
    lnMaxNivel = nivel
    ? "MAx Nivel",lnMaxNivel 
    
    *-- Procesar desde nivel más bajo hacia arriba (hoja ? raíz)
    FOR lnNivelActual = lnMaxNivel TO 2 STEP -1
     	? "nivel actual",lnNivelActual 
        SELECT aux_sumsal
        SET ORDER TO codigo
        GO TOP
        
        SCAN FOR nivel = lnNivelActual AND VAL(suma) <> 0 AND !EMPTY(suma)
            *-- Guardar valores de la cuenta actual
            _sal = saldo
            _deb = debe
            _hab = haber
            _saldo_ant = saldo_ant
            _codigo_padre = ALLTRIM(suma)
            
            *-- Buscar cuenta padre y acumular
            IF SEEK(_codigo_padre)
                wait wind  _codigo_padre nowait
                REPLACE saldo WITH saldo + _sal, ;
                        debe WITH debe + _deb, ;
                        haber WITH haber + _hab, ;
                        saldo_ant WITH saldo_ant + _saldo_ant
            ELSE
                *-- Advertencia: cuenta padre no existe
                ? "ADVERTENCIA: Cuenta padre no encontrada:", _codigo_padre, ;
                  "para cuenta:", codigo
            ENDIF
        ENDSCAN
    ENDFOR
    
    *-- ========================================================================
    *-- FASE 3: FORMATEAR DETALLE CON INDENTACIÓN SEGÚN NIVEL
    *-- ========================================================================
    SELECT aux_sumsal
    SET ORDER TO codigo
    GO TOP
    
    SCAN
        *-- Aplicar indentación visual según nivel jerárquico
        IF nivel > 1
            REPLACE detalle WITH REPLICATE("   ", nivel - 1) + detalle
        ENDIF
    ENDSCAN
    
    *-- ========================================================================
    *-- FASE 4: ORDENAR Y PREPARAR PARA MOSTRAR
    *-- ========================================================================
    SELECT aux_sumsal
    SET ORDER TO codigo
    GO TOP
    
    WAIT CLEAR
    
    *-- Mostrar resumen
    COUNT TO lnTotal
    MESSAGEBOX("Balance generado exitosamente" + CHR(13) + ;
               "Cuentas procesadas: " + ALLTRIM(STR(lnTotal)), 64, "Proceso Completado")
    
    RETURN .T.
ENDPROC

*-- ============================================================================
*-- PROCEDIMIENTO ALTERNATIVO: ACUMULACIÓN RECURSIVA (Más elegante)
*-- ============================================================================
*-- Este método usa recursión para acumular de forma más clara

PROCEDURE AcumularCuentaPadre
    LPARAMETERS tcCodigoCuenta
    LOCAL _padre, _saldo, _debe, _haber, _saldo_ant
    
    SELECT aux_sumsal
    SET ORDER TO codigo
    SEEK tcCodigoCuenta
    
    IF !FOUND()
        RETURN
    ENDIF
    
    *-- Si no tiene padre o ya es raíz, terminar
    IF VAL(suma) = 0 OR EMPTY(suma) OR suma = codigo
        RETURN
    ENDIF
    
    *-- Obtener valores de cuenta actual
    _padre = ALLTRIM(suma)
    _saldo = saldo
    _debe = debe
    _haber = haber
    _saldo_ant = saldo_ant
    
    *-- Buscar cuenta padre
    IF SEEK(_padre)
        *-- Acumular en padre
        REPLACE saldo WITH saldo + _saldo, ;
                debe WITH debe + _debe, ;
                haber WITH haber + _haber, ;
                saldo_ant WITH saldo_ant + _saldo_ant
        
        *-- Recursión: acumular en abuelo
        AcumularCuentaPadre(_padre)
    ENDIF
ENDPROC

*-- ============================================================================
*-- PROCEDIMIENTO DE VALIDACIÓN POST-GENERACIÓN
*-- ============================================================================

PROCEDURE ValidarBalance
    LOCAL lnErrores
    lnErrores = 0
    
    SELECT aux_sumsal
    GO TOP
    
    *-- Validar que debe = haber a nivel global
    SUM debe, haber TO lnTotalDebe, lnTotalHaber FOR nivel = 1
    
    IF ABS(lnTotalDebe - lnTotalHaber) > 0.01
        lnErrores = lnErrores + 1
        ? "ERROR: Balance descuadrado"
        ? "Total Debe:", lnTotalDebe
        ? "Total Haber:", lnTotalHaber
        ? "Diferencia:", lnTotalDebe - lnTotalHaber
    ENDIF
    
    *-- Validar cuentas con saldo pero sin movimientos
    SELECT aux_sumsal
    LOCATE FOR (debe = 0 AND haber = 0) AND saldo <> saldo_ant
    IF FOUND()
        lnErrores = lnErrores + 1
        ? "ERROR: Cuenta con saldo inconsistente:", codigo
    ENDIF
    
    *-- Validar cuentas padre sin hijos
    SELECT aux_sumsal
    SET ORDER TO suma
    SCAN FOR acumula = .T.  && Si es acumuladora
        cod_actual = ALLTRIM(codigo)
        SELECT aux_sumsal
        SET ORDER TO codigo
        LOCATE FOR ALLTRIM(suma) = cod_actual
        IF !FOUND()
            ? "ADVERTENCIA: Cuenta acumuladora sin hijos:", cod_actual
        ENDIF
    ENDSCAN
    
    SET ORDER TO codigo
    
    IF lnErrores = 0
        MESSAGEBOX("? Balance validado correctamente", 64, "Validación OK")
    ELSE
        MESSAGEBOX("? Se encontraron " + ALLTRIM(STR(lnErrores)) + " errores", 48, "Errores")
    ENDIF
    
    RETURN (lnErrores = 0)
ENDPROC

*-- ============================================================================
*-- EJEMPLO DE USO
*-- ============================================================================
*-- thisform.text1.value = DATE(2024, 1, 1)  && Fecha desde
*-- thisform.text2.value = DATE(2024, 12, 31) && Fecha hasta
*-- 
*-- IF GenerarBalanceSumasYSaldos()
*--     ValidarBalance()
*--     *-- Aquí va el código para mostrar el reporte
*-- ENDIF

