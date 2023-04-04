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
	a_minimo = array[1..5] of detalle;
procedure crearMaestro(var a_de:a_deta;var m:mae);
	procedure leer(var file_d:deta;var a_min:detalle);	
	var
		d:detalle;
	begin
		if not(eof(file_d)) then
		begin
			read(file_d,d);
			a_min:=d;
		end
		else
			a_min.cod_usuario:=valor_alto;
	end;
	procedure minimo(var a:a_deta;var a_min:a_minimo;var min:detalle);
	var
		i:integer;
		pos:integer;
	begin
		min.cod_usuario:=valor_alto;//el minimo lo igual al valor alto
		for i:=1 to 5 do //reviso vector y saco la posision donde se encuentra el minimo
		begin
			if a_min[i].cod_usuario < min.cod_usuario then //si es menor guardo posicion
			begin
				min:=a_min[i];
				pos:=i;
			end;
		end;
		if min.cod_usuario <> valor_alto then //Si los archivos del vector no llegaron al final
				leer(a[pos],min); //leo en la posicion del minimo, y al leer se adelanta la poscion del archivo que esta en el vector de archivos
	end;
var	
	i:integer;
	min:detalle;
	act:detalle;
	nuevo:maestro;
	a_min:a_minimo;
begin
	for i:=1 to 5 do
	begin
		reset(a_de[i]);
		leer(a_de[i],a_min[i])//Inicializo el vector de archivos en el primer elemento de cada archivo
	end;
	rewrite(m);
	
	minimo(a_de,a_min,min);//Calculo el minimo
	while (min.cod_usuario <> valor_alto) do
	begin
		act:=min;
		while (min.cod_usuario = act.cod_usuario) do //Reviusa fecha
		begin
			while (min.cod_usuario = act.cod_usuario) and (act.fecha = min.fecha) do
			begin
				act.tiempo_sesion:= act.tiempo_sesion + min.tiempo_sesion;
				minimo(a_de,a_min,min);
			end;//De esta manera queda ordenado primero por codigo y luego por fecha
		end;
		//Conversion
		nuevo.cod_usuario:=act.cod_usuario;
		nuevo.fecha:=act.fecha;
		nuevo.tiempo_total_de_sesiones_abiertas:=act.tiempo_sesion;
		write(m,nuevo);
		minimo(a_de,a_min,min);
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
