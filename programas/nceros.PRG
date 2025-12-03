Parameters xcod
xCeros=0
FOR i = LEN(xcod) TO 1 step -1
    IF SUBSTR(xcod, i, 1) = "0"
        xCeros = xCeros + 1
    ENDIF
EndFor
Xceros=LEN(xcod)-xCeros
Return xCeros