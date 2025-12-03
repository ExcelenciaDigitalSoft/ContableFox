select * ,max(val(numero_comprobante)) as ultimo from movimientos_bancos ;
where tipo_banco="S" and codigo_banco="001" and chequera="000001"


