program punto3;
uses
	SysUtils;
type
	str_20 = string[20];
	novela = record
		cod:integer;
		gen:str_20;
		nom:str_20;
		dur:integer;
		dire:str_20;
		pre:integer;
	end;
	maestro = file of novela;
procedure imprimirMenu(var e:char);
begin
	writeln('------------------MENU--------------------');
	writeln('a. Crear y cargar archivo.');
	writeln('b.Abrir archivo');
	writeln('	1.Dar de alta una novela.');
	writeln('	2.Modificar novela por cod.');
	writeln('	3.Eliminar novela');
	writeln('c.Listar novelas.txt');
	readln(e);
end;
procedure leer(var n:novela);
	begin
		writeln('Codigo: ');
		readln(n.cod);
		if n.cod <> 999 then
		begin
			writeln('Genero: ');
			readln(n.gen);
			writeln('Nombre: ');
			readln(n.nom);
			writeln('Duracion: ');
			readln(n.dur);
			writeln('Director:');
			readln(n.dire);
			writeln('Precio: ');
			readln(n.pre);
		end;
	end;
procedure puntoA(var m:maestro);
var
	n:novela;
begin
	rewrite(m);
	n.cod:= 0;
	write(m,n);
	leer(n);
	while (n.cod <> 999) do
	begin
		write(m,n);
		leer(n);
	end;
	close(m);
	writeln('Archivo creado')
end;
procedure puntoB(var m:maestro);
	procedure darAlta(var m:maestro);
	var
		n:novela;
		pos:integer;
	begin
		reset(m);
		read(m,n);
		if n.cod < 0 then
		begin
			pos:= n.cod * -1;
			seek(m,pos);
			read(m,n);
			if (n.cod < 0) then
			begin
				seek(m,0);
				write(m,n);
			end
			else
			begin
				seek(m,0);
				n.cod:= 0;
				write(m, n);
			end;
			seek(m,pos);
		end
		else
		begin
			seek(m,filesize(m));
		end;
		leer(n);
		write(m,n);
		close(m);
	end;
	procedure modif(var m:maestro);
	var
		encontre:boolean;
		n,act:novela;
	begin
		reset(m);
		encontre:= False;
		leer(n);
		while (not(encontre) and not(eof(m))) do
		begin
			read(m,act);
			if act.cod = n.cod then
				encontre:=True;
		end;
		if encontre = True then
		begin
			seek(m,filepos(m)-1);
			write(m,n);
		end;
		close(m);
	end;
	procedure eliminar(var m:maestro);
	var
		n:novela;
		cod,pos,posVi:integer;
		encontre:boolean;
	begin
		reset(m);
		writeln('Codigo de novela a eliminar: ');
		readln(cod);
		encontre:= false;
		read(m,n);
		posVi:=n.cod;//PosicionVieja
		pos:=0;
		while not(encontre) and not(eof(m)) do
		begin
			read(m,n);
			if (n.cod = cod) then
				encontre:=true;
			pos:= pos + 1;
		end;
		if encontre then
		begin
			n.cod:= posVi;
			seek(m,filepos(m)-1);
			write(m,n);
			seek(m,0);
			n.cod:=pos * -1;
			write(m,n);
		end;
		close(m);
	end;
var
	x:integer;
begin
	readln(x);
	case x of
		1: darAlta(m);
		2: modif(m);
		3: eliminar(m);
	end;
end;
procedure puntoC(var m:maestro);
var
	n:novela;
	txt:Text;
	linea:String;
begin
	assign(txt,'novelas.txt');
	reset(m);
	rewrite(txt);
	while not(eof(m)) do
	begin
		read(m,n);
		linea:= IntToStr(n.cod) +' '+ n.gen +' '+ n.nom +' '+ IntToStr(n.dur) +' '+ n.dire +' '+ IntToStr(n.pre);
		writeln(txt,linea);
	end;
	close(m);
	close(txt);
end;
var
	m:maestro;
	e:char;
begin
	assign(m,'peliculas.dat');
	imprimirMenu(e);
	case e of
		'a': puntoA(m);
		'b': puntoB(m);
		'c': puntoC(m);
	end;	
end.
