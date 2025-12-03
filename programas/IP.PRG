CLEAR
?
? 'Enjoy it, by Alexandre Hedreville'

?
? 'MAC Address'
? '-----------'
? MACAddress()

?
? 'IP Address'
? '-----------'
? IPAddress()

?
? 'GUID'
? '-----------'
? GetGuid()

*!* Windows Sockets
#DEFINE WS_VERSION_REQD        257
#DEFINE WS_VERSION_MAJOR    1
#DEFINE WS_VERSION_MINOR    1
#DEFINE MIN_SOCKETS_REQD    1
#DEFINE SOCKET_ERROR        -1
#DEFINE WSADESCRIPTION_LEN     256
#DEFINE WSASYS_STATUS_LEN     128

*!* Windows NetBIOS
#DEFINE NCBENUM                     55
#DEFINE NCBASTAT                    51
#DEFINE NCBNAMSZ                    16
#DEFINE HEAP_ZERO_MEMORY            8
#DEFINE HEAP_GENERATE_EXCEPTIONS    4
#DEFINE NCBRESET                    50

*!* Devuelve las direcciones MAC
*!* Sintaxis: MACAddress()
*!* Valor devuelto: lcRetVal
*!* lcRetVal viene expresado como una cadena con el formato:00-04-76-A4-73-3A, 00-04-76-A4-72-13, ...
FUNCTION MACAddress
  LOCAL lcNBC, lcAdapter, lnAdapter, lcSource, lnSource, lcRetVal, lnLength,lnLEnum, lcLEnum
  *!* Instrucciones DECLARE DLL para manipular NetBIOS
  DECLARE INTEGER GetProcessHeap IN Win32API
  DECLARE INTEGER Netbios IN Netapi32.DLL STRING @lpNBC
  DECLARE INTEGER HeapFree IN Win32API INTEGER hHeap, INTEGER dwFlags,STRING @lpMem
  DECLARE INTEGER HeapAlloc IN Win32API INTEGER hHeap, INTEGER dwFlags,INTEGER dwBytes
  DECLARE INTEGER RtlMoveMemory IN Win32API STRING @lpDestination, INTEGER nSource, INTEGER nBytes
  *!* Valores
  lcRetVal  = ''
  lcNBC     = REPLICATE(CHR(0), 64)
  lcLEnum   = REPLICATE(CHR(0), 256)
  lcAdapter = REPLICATE(CHR(0), 600)
  *!* Reservar buffer memoria
  lnLEnum = HeapAlloc(GetProcessHeap(), BITOR(HEAP_GENERATE_EXCEPTIONS,HEAP_ZERO_MEMORY), 256)
  IF lnLEnum <> 0
    *!* Valores
    lcNBC = CHR(NCBENUM) + REPLICATE(CHR(0), 3) + LongToStr(lnLEnum) + ;
      IntToStr(256) + SUBSTR(lcNBC, 11, 544)
    *!* Enum LAN´s
    IF Netbios(@lcNBC) = 0
      *!* Leer buffer memoria
      lnSource = lnLEnum
      RtlMoveMemory(@lcLEnum, lnSource, 256)
      *!* Valores
      lnLength = ASC(SUBSTR(lcLEnum, 1, 1))
      *!* Examinar LAN`s
      FOR lnCnt = 1 TO lnLength
        *!* Valores
        lcAdapter = REPLICATE(CHR(0), 600)
        lcNBC     = CHR(NCBRESET) + REPLICATE(CHR(0), 47) +  ;
          SUBSTR(lcLEnum, lnCnt+1, 1) + REPLICATE(CHR(0), 15)
        *!* Reset LAN
        IF Netbios(@lcNBC) = 0
          *!* Reservar buffer memoria
          lnAdapter = HeapAlloc(GetProcessHeap(), ;
            BITOR(HEAP_GENERATE_EXCEPTIONS, HEAP_ZERO_MEMORY), 600)
          IF lnAdapter <> 0
            *!* Valores
            lcNBC = CHR(NCBASTAT) + REPLICATE(CHR(0), 3) +LongToStr(lnAdapter) + ;
              IntToStr(600) + '*               ' + REPLICATE(CHR(0), 22) + ;
              SUBSTR(lcLEnum, lnCnt+1, 1) + REPLICATE(CHR(0), 15)
            *!* Status LAN
            IF Netbios(@lcNBC)  = 0
              *!* Leer buffer memoria
              lnSource = lnAdapter
              RtlMoveMemory(@lcAdapter, lnSource, 600)
              *!* Componer cadena MAC con guiones y separar multiples MAC`s con comas
              lcRetVal = lcRetVal + RIGHT(DecToHex(ASC(SUBSTR(lcAdapter, 1,1))), 2) + ;
                '-' + RIGHT(DecToHex(ASC(SUBSTR(lcAdapter, 2, 1))), 2) + ;
                '-' + RIGHT(DecToHex(ASC(SUBSTR(lcAdapter, 3, 1))), 2) + ;
                '-' + RIGHT(DecToHex(ASC(SUBSTR(lcAdapter, 4, 1))), 2) + ;
                '-' + RIGHT(DecToHex(ASC(SUBSTR(lcAdapter, 5, 1))), 2) + ;
                '-' + RIGHT(DecToHex(ASC(SUBSTR(lcAdapter, 6, 1))), 2) + ;
                IIF(lnCnt = lnLength, '', ',')
            ENDIF
            *!* Liberar buffer memoria
            lcSource = LongToStr(lnAdapter)
            HeapFree(GetProcessHeap(), 0, @lcSource)
          ENDIF
        ENDIF
      ENDFOR
    ENDIF
    *!* Liberar buffer memoria
    lcSource = LongToStr(lnLEnum)
    HeapFree(GetProcessHeap(), 0, @lcSource)
  ENDIF
  *!* Retorno
  RETURN lcRetVal
ENDFUNC

*!* Devuelve las direcciones IP
*!* Sintaxis: IPAddress()
*!* Valor devuelto: lcRetVal
*!* lcRetVal viene expresado como una cadena con el formato:
192.100.100.100, 192.100.100.101, ...
FUNCTION IPAddress
  LOCAL lnCnt, lpWSAData, lpWSHostEnt, lpHostName, lcRetVal, lpHostIp_Addr,;
    lpHostEnt_Addr, lnHostEnt_Lenght, lnHostEnt_AddrList
  *!* Instrucciones DECLARE DLL para manipular Windows Sockets
  DECLARE INTEGER WSAGetLastError IN WSock32.DLL
  DECLARE INTEGER WSAStartup IN WSock32.DLL INTEGER wVersionRequested ,STRING @lpWSAData
  DECLARE INTEGER WSACleanup IN WSock32.DLL
  DECLARE INTEGER gethostname IN WSock32.DLL STRING @lpHostName, INTEGER iHostNameLenght
  DECLARE INTEGER gethostbyname IN WSock32.DLL STRING lpHostName
  DECLARE RtlMoveMemory IN Win32API STRING @lpDest, INTEGER nSource, INTEGER nBytes
  *!* Valores
  lcRetVal           = ''
  lpHostName         = SPACE(256)
  lnHostEnt_Addr     = 0
  lnHostEnt_Lenght   = 0
  lnHostEnt_AddrList = 0
  lnHostIp_Addr      = 0
  lpTempIp_Addr      = CHR(0)
  lpHostIp_Addr      = REPLICATE(CHR(0), 4)
  lpWSHostEnt        = REPLICATE(CHR(0), 4 +4 +2 +2 +4)
  lpWSAData          = REPLICATE(CHR(0), 2 +2 + ;
    WSADESCRIPTION_LEN +1 +WSASYS_STATUS_LEN +1 +2 +2 +4)
  *!* Iniciar Windows Sockets
  IF WSAStartup(WS_VERSION_REQD, @lpWSAData) =  0
    *!* Valores
    lnVersion    = StrToInt(SUBSTR(lpWSAData, 1, 2))
    lnMaxSockets = StrToInt(SUBSTR(lpWSAData, 391, 2))
    *!* Determinar si Windows Sockets responde
    IF gethostname(@lpHostName, 256) <> SOCKET_ERROR
      *!* Valores
      lpHostName = ALLTRIM(lpHostName)
      lnHostEnt_Addr = gethostbyname(lpHostName)
      *!* Determinar si Windows Sockets no dio error
      IF lnHostEnt_Addr <> 0
        *!* Mover bloques de memoria
        RtlMoveMemory(@lpWSHostEnt, lnHostEnt_Addr, 16)
        *!* Valores
        lnHostEnt_AddrList = StrToLong(SUBSTR(lpWSHostEnt, 13, 4))
        lnHostEnt_Lenght   = StrToInt(SUBSTR(lpWSHostEnt, 11, 2))
        *!* Obtener todas las direcciones IP de la máquina
        DO WHILE .T.
          *!* Mover bloques de memoria
          RtlMoveMemory(@lpHostIp_Addr, lnHostEnt_AddrList, 4)
          *!* Valores
          lnHostIp_Addr = StrToLong(lpHostIp_Addr)
          *!* No hay o no quedan más direcciones validas
          IF lnHostIp_Addr = 0
            EXIT
          ELSE
            *!* Separar multiples IP`s con comas
            lcRetVal = lcRetVal + IIF(EMPTY(lcRetVal), '', ',')
          ENDIF
          lpTempIp_Addr = REPLICATE(CHR(0), lnHostEnt_Lenght)
          *!* Mover bloques de memoria
          RtlMoveMemory(@lpTempIp_Addr, lnHostIp_Addr, lnHostEnt_Lenght)
          *!* Componer cadena IP con puntos
          FOR lnCnt = 1 TO lnHostEnt_Lenght
            lcRetVal = lcRetVal + TRANSFORM(ASC(SUBSTR(lpTempIp_Addr, lnCnt,1))) + ;
              IIF(lnCnt = lnHostEnt_Lenght, '', '.')
          ENDFOR
          *!* Continuar con la siguiente direccion
          lnHostEnt_AddrList = lnHostEnt_AddrList + 4
        ENDDO
      ENDIF
    ENDIF
  ENDIF
  *!* Parar Windows Sockets
  IF WSACleanup() <> 0
    lcRetVal = ''
  ENDIF
  *!* Retorno
  RETURN lcRetVal
ENDFUNC

*!* Obtiene un GUID en formato {nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn}
*!* Sintaxis: GetGuid()
*!* Valor devuelto: lcGuid
FUNCTION GetGuid
  LOCAL lnCnt, lcGuid, lcData1, lcData2, lcData3, lcData4, lcData5
  *!* Instrucciones DECLARE DLL para manipular obtener un GUID
  DECLARE INTEGER CoCreateGuid IN Ole32.DLL STRING @lpGuid
  *!* Valores
  lnCnt   = 0
  lcGuid  = ''
  lcData1 = ''
  lcData2 = ''
  lcData3 = ''
  lcData4 = ''
  lcData5 = ''
  lpGuid  = REPLICATE(CHR(0), 17)
  *!* Obtener el GUID
  IF CoCreateGuid(@lpGuid) = 0
    *!* Valores
    lcData1 = RIGHT(TRANSFORM(StrToLong(LEFT(lpGuid, 4)), '@0'), 8)
&& Los 8 primeros digitos
    lcData2 = RIGHT(TRANSFORM(StrToLong(SUBSTR(lpGuid, 5, 2)), '@0'), 4)
&& Los 4 segundos digitos
    lcData3 = RIGHT(TRANSFORM(StrToLong(SUBSTR(lpGuid, 7, 2)), '@0'), 4)
&& Los 4 terceros digitos
    lcData4 = RIGHT(TRANSFORM(StrToLong(SUBSTR(lpGuid, 9, 1)), '@0'), 2) + ;
      RIGHT(TRANSFORM(StrToLong(SUBSTR(lpGuid, 10, 1)), '@0'), 2)
&& Los 4 cuartos digitos
    lcData5 = ''
    *!* Los 12 digitos finales
    FOR lnCnt = 1 TO 6
      lcData5 = lcData5 + RIGHT(TRANSFORM(StrToLong(SUBSTR(lpGuid, 10 +lnCnt, 1))), 2)
    ENDFOR
    *!* Verifica la longitud de los 12 digitos finales. Si son menores de 12 es que el resto son 0
    IF LEN(lcData5) < 12
      lcData5 = lcData5 + REPLICATE('0', 12 - LEN(lcData5))
    ENDIF
    *!* Valores
    lcGuid = '{' + lcData1 + '-' + lcData2 + '-' + lcData3 + '-' + lcData4 +'-' + lcData5 + '}'
  ENDIF
  *!* Retorno
  RETURN lcGuid
ENDFUNC

****************************************************************************
****
** Libreria de funciones de conversion de tipo
**
****************************************************************************
****

*!* Convierte un long integer a un 4-byte character string
*!* Sintaxis: LongToStr(tnLongVal)
*!* Valor devuelto: lcRetStr
*!* Argumentos: tnLongVal
*!* lnLongVal especifica el long integer a convertir
FUNCTION LongToStr
  LPARAMETERS tnLongVal
  LOCAL lnCnt, lcRetStr, lnLongVal
  *!* Valores
  lcRetStr  = ''
  lnLongVal = IIF(EMPTY(tnLongVal), 0, tnLongVal)
  *!* Convertir
  FOR lnCnt = 24 TO 0 STEP -8
    lcRetStr  = CHR(INT(lnLongVal/(2^lnCnt))) + lcRetStr
    lnLongVal = MOD(lnLongVal, (2^lnCnt))
  NEXT
  *!* Retorno
  RETURN lcRetStr
ENDFUNC

*!* Convierte un 4-byte character string a un long integer
*!* Sintaxis: StrToLong(tcLongStr)
*!* Valor devuelto: lnRetval
*!* Argumentos: tcLongStr
*!* tcLongStr especifica el 4-byte character string a convertir
FUNCTION StrToLong
  LPARAMETERS tcLongStr
  LOCAL lnCnt, lnRetVal, lcLongStr
  *!* Valores
  lnRetVal  = 0
  lcLongStr = IIF(EMPTY(tcLongStr), '', tcLongStr)
  *!* Convertir
  FOR lnCnt = 0 TO 24 STEP 8
    lnRetVal  = lnRetVal + (ASC(lcLongStr) * (2^lnCnt))
    lcLongStr = RIGHT(lcLongStr, LEN(lcLongStr) - 1)
  NEXT
  *!* Retorno
  RETURN lnRetVal
ENDFUNC

*!* Convierte un integer a un 2-byte character string
*!* Sintaxis: IntToStr(tnIntVal)
*!* Valor devuelto: lcRetStr
*!* Argumentos: tnIntVal
*!* lnIntVal especifica el integer a convertir
FUNCTION IntToStr
  LPARAMETERS tnIntVal
  LOCAL lnCnt, lcRetStr, lnIntVal
  *!* Valores
  lcRetStr = ''
  lnIntVal = IIF(EMPTY(tnIntVal), 0, tnIntVal)
  *!* Convertir
  FOR lnCnt = 8 TO 0 STEP -8
    lcRetStr = CHR(INT(lnIntVal/(2^lnCnt))) + lcRetStr
    lnIntVal = MOD(lnIntVal, (2^lnCnt))
  NEXT
  *!* Retorno
  RETURN lcRetStr
ENDFUNC

*!* Convierte un 2-byte character string a un integer
*!* Sintaxis: StrToInt(tcIntStr)
*!* Valor devuelto: lnRetval
*!* Argumentos: tcIntStr
*!* tcIntStr especifica el 2-byte character string a convertir
FUNCTION StrToInt
  LPARAMETERS tcIntStr
  LOCAL lnCnt, lnRetVal, lcIntStr
  *!* Valores
  lnRetVal = 0
  lcIntStr = IIF(EMPTY(tcIntStr), '', tcIntStr)
  *!* Convertir
  FOR lnCnt = 0 TO 8 STEP 8
    lnRetVal = lnRetVal + (ASC(lcIntStr) * (2^lnCnt))
    lcIntStr = RIGHT(lcIntStr, LEN(lcIntStr) - 1)
  NEXT
  *!* Retorno
  RETURN lnRetVal
ENDFUNC

*!* Convierte un numero decimal a una hex character string
*!* Sintaxis: DecToHex(tnDecNumber)
*!* Valor devuelto: lcHexNumber
*!* Argumentos: tnDecNumber
*!* tnDecNumber especifica el numero decimal a convertir
FUNCTION DecToHex
  LPARAMETERS tnDecNumber
  LOCAL lnLength, lnTempHex, lcHexNumber, lnDecNumber
  *!* Valores
  lcHexNumber = ''
  lnDecNumber = IIF(EMPTY(tnDecNumber), 0, tnDecNumber)
  *!* Convertir
  DO CASE
    CASE lnDecNumber = 0
      lcHexNumber = '0x00000000'
    CASE lnDecNumber > 0
      lcHexNumber = TRANSFORM(lnDecNumber, '@0')
    OTHERWISE
      lcHexNumber = TRANSFORM(ABS(lnDecNumber), '@0')
      lnLength    = IIF(SUBSTR(lcHexNumber, 3, 1) = ;
        '0', LEN(SUBSTR(lcHexNumber, NotAt('0', lcHexNumber, 2))), ;
        LEN(TRANSFORM(ABS(lnDecNumber), '@0')) - 2)
      lnTempHex   = 0xFFFFFFFF
      lcHexNumber = TRANSFORM(lnTempHex - ABS(lnDecNumber) + 1, '@0')
  ENDCASE
  *!* Retorno
  RETURN lcHexNumber
ENDFUNC


