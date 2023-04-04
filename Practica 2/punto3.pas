progr	am punto3;
const valor_alto = 999;
type
	producto = record
		cod:integer;
		nom:string[20];
		des:string[20];
		stcDis:integer;
		stcMin:integer;
		precio:real;
	end;
	venta = record
		cod:integer;
		cantVen:integer;
	end;
	maestro = file of producto;
	detalle = file of venta;
	a_detalles = array[1..30] of detalle;
var
	a_deta:a_detalles;
	i:integer;
	m: maestro;
begin
	assign(m, 'punto3_maestro.dat');
	for (i:=1 to 30) do
	begin
		assign(a_deta[i],'punto3_detalle' +str(i)+ '.dat');
		rewrite(a_deta[i]);
	end;
	
end;
