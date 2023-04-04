program punto7;
uses Crt;
type
	novela = record
		cod:integer;
		p:real;
		gen:string[20];
		nom:string[20];
	end;
	f_nov=file of novela;
procedure Menu(var x:char);
begin
    writeln('+-----------------------------------+');
    writeln('|              MENU                 |');
    writeln('+-----------------------------------+');
    writeln('|  a. Crear  binario desde txt      |');
    writeln('|  b. Agregar novela                |');
    writeln('|  c. Modificar novela              |');
    writeln('|  d. Crear txt desde binario       |');
    writeln('|  x. Salir del programa            |');
    writeln('+-----------------------------------+');
    write('Seleccione una opcion: ');
    readln(x);
    ClrScr;
end;

procedure crearBinarioTxt(var b:f_nov;var txt:Text);
var
	nov:novela;
begin
	assign(b,'novelas');
	assign(txt,'novelas.txt');
	rewrite(b);
	reset(txt);
	
	while not(eof(txt)) do
	begin
		with nov do readln(txt,cod,p,gen);
		readln(txt,nov.nom);
		write(b,nov);
	end;
	close(b);
	close(txt);
	readln();
	writeln('Creado con exito.');
	readln();
	ClrScr;
end;


procedure agregar(var f:f_nov);
	procedure leer1(var n: novela);
	begin
		writeln('Ingresar los datos de la novela:');
		write('Código: ');
		readln(n.cod);
		write('Precio: $');
		readln(n.p);
		write('Género: ');
		readln(n.gen);
		write('Nombre: ');
		readln(n.nom);
	end;
var
	n:novela;
begin
	assign(f,'novelas');
	reset(f);
	leer1(n);
	seek(f,(fileSize(f)-1));
	write(f,n);
	close(f);
	writeln('Agregado con exito.');
	readln();
	ClrScr;
end;

procedure modificar(var f:f_nov);
var
	cod:integer;
	n:novela;
	x:char;
begin
	assign(f,'novelas');
	reset(f);
	writeln('Codigo a modificar: ');
	readln(cod);
	n.cod:=0;
	while not(eof(f)) and (cod <> n.cod) do
	begin
		read(f,n);
	end;
	if cod = n.cod then
	begin
		writeln('Que quieres modificar?');
		writeln('	a.Precio');
		writeln('	b.Genero');
		writeln('	c.Nombre');
		readln(x);
		if x = 'a' then
		begin
			writeln('Precio nuevo: ');
			readln(n.p);
		end
		else if x = 'b' then
		begin
			writeln('Genero nuevo: ');
			readln(n.gen);
		end
		else
		begin
			writeln('Nombre nuevo: ');
			readln(n.nom);
		end;
		seek(f,(filePos(f)-1));
		write(f,n);
		writeln('Modificado con exito.');
	end
	else
	begin
		writeln('El codigo no existe.');
	end;
	readln();
	ClrScr;
	close(f);
end;

procedure binToTxt(var f:f_nov;var txt:Text);
var
	n:novela;
begin
	assign(f,'novelas');
	assign(txt,'exportNovelas.txt');
	reset(f);
	rewrite(txt);
	while not(eof(f)) do
	begin
		read(f,n);
		with n do writeln(txt,cod,' ',p,' ',gen);
		writeln(txt,n.nom);
	end;
	close(f);
	close(txt);
	writeln('Archivo creado con exito.');
	readln();
	ClrScr;
end;

var
	fileN:f_nov;
	txt:Text;
	x:char;
begin
	x:=' ';
	while (x <> 'x') do
	begin
		Menu(x);
		case x of
			'a': crearBinarioTxt(fileN,txt);
			'b': agregar(fileN);
			'c': modificar(fileN);
			'd': binToTxt(fileN,txt);
		end;
	end;
end.
