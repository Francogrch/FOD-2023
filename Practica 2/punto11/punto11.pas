program punto11;
uses
	SysUtils;
const
	valor_alto = 'ZZZZZZZZZ';
	cantDeta = 2;
type
	maestro = record
		nom:string[20];
		cantA:integer;
		totE:integer;
	end;
	detalle = record
		nom:string[20];
		codLoc:integer;
		cantA:integer;
		cantE:integer;
	end;
	f_maestro = file of maestro;
	f_detalle = file of detalle;
	a_detalle = array[1..cantDeta] of f_detalle; 
	a_reg_detalle = array[1..cantDeta] of detalle;
procedure actualizarMaestro(var m:f_maestro;var a_d:a_detalle);
	procedure leer_d(var f_d:f_detalle;var d:detalle);
	begin
		if not(eof(f_d)) then
			read(f_d,d)
		else
			d.nom:=valor_alto;
	end;
	procedure leer_m(var f_m:f_maestro;var m:maestro);
	begin
		if not(eof(f_m)) then
			read(f_m,m)
		else
			m.nom:=valor_alto;
	end;
	procedure minimo(var a_reg:a_reg_detalle;var a_file_deta:a_detalle;var d:detalle);
	var
		pos:integer;
	begin
		if a_reg[1].nom <= a_reg[2].nom then
		begin
			pos:=1;
			d:=a_reg[1];
		end
		else
		begin
			pos:=2;
			d:=a_reg[2];
		end;
		if d.nom <> valor_alto then
		begin
			leer_d(a_file_deta[pos],a_reg[pos]);
		end;
	end;
var
	a_reg:a_reg_detalle;
	i:integer;
	reg_m:maestro;
	reg_d,actual_d:detalle;
begin
	reset(m);
	for i:=1 to cantDeta do
	begin
		reset(a_d[i]);
		leer_d(a_d[i],a_reg[i]);
	end;

	minimo(a_reg,a_d,reg_d);
	
	while (reg_d.nom <> valor_alto) do
	begin
		actual_d:=reg_d;
		actual_d.cantA:=0;
		actual_d.cantE:=0;
		while (reg_d.nom = actual_d.nom) do
		begin
			actual_d.cantA:=actual_d.cantA + reg_d.cantA;
			actual_d.cantE:=actual_d.cantE + reg_d.cantE;
			minimo(a_reg,a_d,reg_d);
		end;
		leer_m(m,reg_m);
		while (reg_m.nom <> actual_d.nom) do
		begin
			leer_m(m,reg_m);
		end;

		reg_m.cantA:=reg_m.cantA+actual_d.cantA;
		reg_m.totE:=reg_m.totE+actual_d.cantE;
		seek(m,filepos(m)-1);
		write(m,reg_m);
		
	end;
	close(m);
	for i:=1 to cantDeta do
	begin
		close(a_d[i]);
	end;
end;

// Procedimiento para imprimir todos los registros del archivo maestro
procedure imprimirMaestro(var archivoMaestro:f_maestro);
var
  regMaestro: maestro;
begin
  writeln('--- Registros del archivo maestro ---');
  reset(archivoMaestro);
  while not eof(archivoMaestro) do
  begin
    read(archivoMaestro, regMaestro);
    writeln('Nombre: ', regMaestro.nom);
    writeln('Cantidad A: ', regMaestro.cantA);
    writeln('Total E: ', regMaestro.totE);
    writeln();
  end;
  close(archivoMaestro);
end;

// Procedimiento para imprimir todos los registros de un archivo detalle
procedure imprimirDetalle(var archivoDetalle:f_detalle;nombreArchivo:string);
var
  regDetalle: detalle;
begin
  writeln('--- Registros del archivo detalle ', nombreArchivo, ' ---');
  assign(archivoDetalle, nombreArchivo);
  reset(archivoDetalle);
  while not eof(archivoDetalle) do
  begin
    read(archivoDetalle, regDetalle);
    writeln('Nombre: ', regDetalle.nom);
    writeln('Codigo Localidad: ', regDetalle.codLoc);
    writeln('Cantidad A: ', regDetalle.cantA);
    writeln('Cantidad E: ', regDetalle.cantE);
    writeln();
  end;
  close(archivoDetalle);
end;


var
	m:f_maestro;
	a_d:a_detalle;
	i:integer;
begin
	for i:=1 to cantDeta do
	begin
		assign(a_d[i],'detalle'+IntToStr(i)+'.dat');
	end;

	assign(m,'maestro.dat');
	imprimirMaestro(m);
	readln();
	writeln('--------------------------');
	actualizarMaestro(m,a_d);
	imprimirMaestro(m);
	readln();
	writeln('--------------------------');
	imprimirDetalle(a_d[1],'detalle2.dat');
	
end.
