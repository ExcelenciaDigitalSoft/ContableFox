*SELECT * FROM cuencont  INTO CURSOR curCuentas readwrite 
*SELECT * FROM movicont where Left(periodo,4)='2024' INTO CURSOR curMovimientos

&& Iniciar el entorno
CLEAR
Close  table all 
&& Definir variables
LOCAL lcTitulo, lnTotalMovimientos, lnSaldoCuenta, lnDiferencia
LOCAL lnSumaDebitos, lnSumaCreditos, lnSumaTotal
LOCAL lcMensaje, lcInforme

&& Configurar el título de la ventana
lcTitulo = "Verificación de Balance Contable"

&& Abrir las tablas
USE cuencont  IN 0 Alias Cuentas 
USE movicont IN 0 
SELECT * FROM movicont where Left(periodo,4)='2022' and Between(fecha,{01/12/2021},{30/11/2022}) order by nroasiento INTO CURSOR Movimientos 

&& Inicializar variables de suma
lnSumaDebitos = 0
lnSumaCreditos = 0
lnSumaTotal = 0

&& Calcular suma total de movimientos
SELECT Movimientos

&& Iniciar el entorno
CLEAR

&& Definir variables
LOCAL lcTitulo, lnSaldoTeorico, lnSaldoRegistro, lnDiferencia
LOCAL lcMensaje, lcInforme

&& Configurar el título de la ventana
lcTitulo = "Verificación de Balance Contable"

&& Seleccionar todos los registros de Cuentas

    
    && Seleccionar movimientos de la cuenta actual
    SELECT Movimientos
     DO WHILE NOT EOF() 
   lcCodigoCuenta = nroasiento
    
    && Inicializar variables de suma para la cuenta actual
    lnSumaDebitos = 0
    lnSumaCreditos = 0
    lnSaldoTeorico = 0
    lntotal=0
    && Calcular suma de movimientos para la cuenta actual
    DO WHILE NOT EOF() and nroasiento = lcCodigoCuenta
        IF debehaber == 'D'
            lnSumaDebitos = lnSumaDebitos + Importe
        EndIf 
        IF debehaber == 'H'
            lnSumaCreditos = lnSumaCreditos + Importe
        ENDIF
        skip
    ENDDO
    
    && Calcular el saldo teórico para la cuenta actual
    lnSaldoTeorico = lnSumaDebitos - lnSumaCreditos
    
  
    && Verificar si hay una diferencia
    IF lnSaldoTeorico != 0
        lcMensaje = "Diferencia detectada en la cuenta: " +     lcCodigoCuenta + " Diferencia: " + STR(lnSaldoTeorico , 10, 2)
        ? lcMensaje
        lntotal=lntotal+lnSaldoTeorico 
        && Opcional: Grabar la diferencia en un log
        && USE LogDiferencias IN 0
        && INSERT INTO LogDiferencias VALUES (DateTime(), Nombre, lnDiferencia)
        && USE IN LogDiferencias
    ENDIF
 
ENDDO
&& Cerrar las tablas
USE IN Cuentas
USE IN Movimientos
? lntotal
&& Mostrar mensaje final
WAIT "Revisión de balance finalizada. Verifique los mensajes mostrados para detalles."

