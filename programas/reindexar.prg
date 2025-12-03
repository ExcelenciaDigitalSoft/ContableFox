if messagebox('Confirma Reidexar',36,'Reindexar')=6
CLOSE TABLE ALL
set talk wind
set talk on
use AUX_BENI.DBF                excl
pack
use AUX_CAJA.DBF                excl
pack
use AUX_DEUDAELE.DBF            excl
pack
use AUX_FAC.DBF                 excl
pack
reind                                                                                                                                                                                                
use AUX_FACTURACION.DBF         excl
pack
reind                                 
use AUX_FACTURACION2.DBF        excl
pack
reind                                 
use AUX_FICHA.DBF               excl
pack
reind                                 
use BENEFICIARIOS.DBF           excl
pack
reind                                 
use CAJA.DBF                    excl
pack
reind                                                                                                                                                                                                
use COBRADORES.DBF              excl
pack
reind                                 
use CONTRASEÑA.DBF              excl
pack
reind                                 
use CUOTAS.DBF                  excl
pack
reind                                                                                                                                                                                                
use DATOS.DBF                   excl
pack
reind                                                                                                                                                                                              
use DEUDA.DBF                   excl
pack
reind                                                                                                                                                                                            
use EGRESOS.DBF                 excl
pack
reind                                                                                                                                                                                               
use ENCABEZADO.DBF              excl
pack
reind                                 
use FACTURACION.DBF             excl
pack
reind                                 
use IMP_FACTURACION.DBF         excl
pack
reind                                 
use INGRESOS.DBF                excl
pack
reind                                                                                                                                                                                             
use OPERADORES.DBF              excl
pack
reind                                 
use PADRON.DBF                  excl
pack
reind                                                                                                                                                                                              
use PAGOS.DBF                   excl
pack
reind                                                                                                                                                                                             
use TIPO_CAJA.DBF               excl
pack
reind                                 
use TIPO_DOCUMENTO.DBF          excl
pack
reind                                 
set talk off
CLOSE TABLE ALL
endif