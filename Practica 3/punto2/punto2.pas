program punto2;
type
	str_20 = string[20];
	asistente = record
		nro:integer;
		ape:str_20;
		nom:str_20;
		email:str_20;
		tel:integer;
		dni:integer;
	end;
	maestro = file of asistente;
procedure cargarMaestro(var m:maestro);
	procedure leer1(var a:asistente);
	begin
		writeln('Numero de asistente: ');
		readln(a.nro);
		if a.nro <> 0 then
		begin
			writeln('Apellido: ');
			readln(a.ape);
			writeln('Nombre: ');
			readln(a.nom);
			writeln('Email: ');
			readln(a.email);
			writeln('Telefono: ');
			readln(a.tel);
			writeln('DNI: ');
			readln(a.dni);
		end;
	end;
var
	a:asistente;
begin
	writeln('CARGAR MAESTRO');
	rewrite(m);
	leer1(a);
	while a.nro <> 0 do
	begin
		write(m,a);
		leer1(a);
	end;
	close(m);
	writeln('Archivo creado.');
end;
procedure eliminacionLogica(var m:maestro);
var
	a:asistente;
begin
	reset(m);
	while not(eof(m)) do
	begin
		read(m,a);
		if a.nro < 1000 then
		begin
			a.nom:= '@' + a.nom;
			seek(m,filepos(m)-1);
			write(m,a); 
		end;
	end;
	close(m);
end;
procedure imprimir_maestro(var m:maestro);
	procedure imprimir(a:asistente);
	begin
		writeln('Codigo: ',a.nro);
		writeln('Apellido: ',a.ape);
		writeln('Nombre: ',a.nom);
		writeln('Email: ',a.email);
		writeln('Telefono: ',a.tel);
		writeln('DNI: ',a.dni);
		writeln('-------------------');
	end;
var
	a:asistente;
begin
	reset(m);
	while not(eof(m)) do
	begin
		read(m,a);
		imprimir(a);
	end;
	writeln('--------------------------------FIN IMPRESION--------------------------------');
	close(m);
end;
var
	m:maestro;
begin
	assign(m,'maestro.dat');
	//cargarMaestro(m);
	imprimir_maestro(m);
	eliminacionLogica(m);
	imprimir_maestro(m);
end.
