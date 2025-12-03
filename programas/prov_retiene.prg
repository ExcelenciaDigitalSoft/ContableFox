select * ,verfield("Proveedores",proveedor_ingreso,"Cuit","Codigo") as cuit,verfield("Proveedores",proveedor_ingreso,"brutos","Codigo") as brutos ;
from retenciones  order by proveedor_ingreso ;
Group by proveedor_ingreso
