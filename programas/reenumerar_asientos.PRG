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

IF MESSAGEBOX('Generar N° de Asientos Contables para el Periodo: ' + _periodosele, 36, 'Asistente') = 6
    
    STORE 0 TO _inicio, c, a
    STORE "" TO uni, _nuevo
    _inicio = 2

    * Configurar filtros
    SELECT detacont
    SET FILTER TO periodo = _periodosele
    SET ORDER TO fecha
    
    SELECT movicont 
    SET FILTER TO periodo = _periodosele
    SET ORDER TO unico
    
    * Preparar tabla de bancos
    SELECT movimientos_bancos
    REPLACE ALL nuevo_asiconci WITH asiconci
    
    * Contar registros
    SELECT detacont
    GO TOP
    COUNT TO c
    
    IF c = 0
        MESSAGEBOX("No hay Asientos Cargados en este Periodo", 48, "Control")
        RETURN
    ENDIF
    
    * Procesar asientos
    GO TOP
    SCAN
        uni = detacont.unico
        
        * Verificar si existe en movicont
        SELECT movicont
        SEEK uni
        
        IF FOUND()
            * Actualizar todos los movimientos con el mismo unico
            SCAN WHILE unico = uni
                REPLACE nuevo_nro WITH PADL(ALLTRIM(STR(_inicio)), 6, "0")
            ENDSCAN
            
            * Actualizar detacont
            SELECT detacont
            REPLACE nuevo_nro WITH PADL(ALLTRIM(STR(_inicio)), 6, "0")
            
            * Actualizar movimientos_bancos
            SELECT movimientos_bancos
            SET ORDER TO asiconci
            IF SEEK(_periodosele + detacont.nroasiento)
                _nuevo = ALLTRIM(_periodosele) + PADL(ALLTRIM(STR(_inicio)), 6, "0")
                REPLACE nuevo_asiconci WITH _nuevo,unico with uni WHILE asiconci = _periodosele + detacont.nroasiento
            ENDIF
            
            * Incrementar contador
            _inicio = _inicio + 1
        ELSE
            * Asiento sin movimientos - decidir qué hacer
            * Opción A: Marcar para eliminar
            SELECT detacont
            DELETE
            
            * Opción B: Mantener pero sin renumerar (comentar DELETE de arriba)
            * (no hacer nada)
        ENDIF
        
        a = a + 1
        SELECT detacont
    ENDSCAN
    
    * DESCOMENTAR PARA APLICAR CAMBIOS DEFINITIVOS:
*!*	    /*
    SELECT detacont
    SET FILTER TO
    REPLACE ALL NroAsiento WITH Nuevo_Nro FOR periodo = _periodosele AND !EMPTY(Nuevo_Nro)
    
    SELECT movicont 
    SET FILTER TO
    REPLACE ALL NroAsiento WITH Nuevo_Nro FOR periodo = _periodosele AND !EMPTY(Nuevo_Nro)
    
    SELECT movimientos_bancos
    REPLACE ALL asiconci WITH nuevo_asiconci FOR !EMPTY(nuevo_asiconci)
*!*	    
*!*	    * Limpiar registros marcados
*!*	    SELECT detacont
*!*	    DELETE ALL FOR DELETED()
*!*	    PACK
*!*	    */
ENDIF