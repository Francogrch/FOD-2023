program punto4;
uses SysUtils;
const valor_alto = 999;

type
	detalle = record
		cod_usuario: integer;
		fecha: string[20];
		tiempo_sesion:integer;
	end;
	maestro = record
		cod_usuario: integer;
		fecha: string[20];
		tiempo_total_de_sesiones_abiertas:integer;
	end;
	deta = file of detalle;
	mae = file of maestro;
	a_deta = array[1..5] of deta;
	
procedure crearMaestro(var a_de:a_deta;var m:mae);
	procedure minimo(var a:a_deta;var min:detalle);
		procedure leer(var det:deta;var d:detalle);
		begin
			if not(eof(det)) then
				read(det,d)
			else
				d.cod_usuario:=valor_alto;
		end;
	var
		i:integer;
		d:detalle;
		pos:integer;
	begin
		min.cod_usuario:=valor_alto;
		for i:=1 to 5 do
		begin
			if not(eof(a[i])) then
			begin
				read(a[i],d);
				if d.cod_usuario < min.cod_usuario then
				begin
					min:=d;
					pos:=i;
				end;
				seek(a[i],filepos(a[i])-1)
			end;
			if min.cod_usuario <> valor_alto then
				leer(a[pos],min);
		end;
	end;
var	
	i:integer;
	min:detalle;
	act:detalle;
	nuevo:maestro;
begin
	for i:=1 to 5 do
	begin
		reset(a_de[i]);
	end;
	rewrite(m);
	minimo(a_de,min);
	while (min.cod_usuario <> valor_alto) do
	begin
		act:=min;
		while (min.cod_usuario = act.cod_usuario) do
		begin
			act.tiempo_sesion:= act.tiempo_sesion + min.tiempo_sesion;
			minimo(a_de,min);
		end;
		nuevo.cod_usuario:=act.cod_usuario;
		nuevo.fecha:=act.fecha;
		nuevo.tiempo_total_de_sesiones_abiertas:=act.tiempo_sesion;
		write(m,nuevo);
		minimo(a_de,min);
	end;
end;
var
	a_de:a_deta;
	m:mae;
	nom:string[20];
	i:integer;
begin
	assign(m,'/var/log/maestro.dat');
	for i:=1 to 5 do
	begin
		nom:='logs_pc_' + IntToStr(i) + '.dat';
		assign(a_de[i],nom);
	end;
	crearMaestro(a_de,m);
end.
