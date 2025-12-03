Close Tables all
*Use D:\Sistemas\Proyectos\UPCNContable\ch_pendientes In 1 Alias ch
use H:\Conta-UPCN\archivos\chupcn In 1 Alias ch
USE movimientos_bancos in 2 Alias movban
Select movban
Delete For tipo_banco = 'S'
sele ch
Go top
Scan
	Scatter memvar
	m.codigo_banco = '004'
	m.det_codban = 'BCO. SAN JUAN CTA. CTE.'
	m.chequera = '000000'
	m.tipo_banco = 'S'
	m.numero_comprobante = ceros(Alltrim(Str(m.némero)),10)
	m.fecha_emision = m.fecha
	m.fecha_vencimiento = m.vencimient
	m.fecha_ingreso = {}
	m.importe = Abs(m.importe)
	m.detalle = Alltrim(m.observacio)
	m.tipo_movimiento = '001'
	m.debe_haber = 'H'
	Select movban
	Append Blank
	Gather memvar
	Select ch	
Endscan
Close Tables all
MessageBox("Proceso Terminado.",48,"Control")