program punto5;
uses Crt;
type
	str20 = String[20];
	celular = record
		cod : integer;
		nom : str20;
		des : str20;
		marca: str20;
		precio: real;
		stmin:integer;
		stdis:integer;
	end;
	filePhone=file of celular;

procedure Menu(var e:char);
begin
	writeln('Elegir opcion: ');
	writeln('	a.Crear archivo a partir de TXT.');
	writeln('	b.Listar celulares con stock menor al minimo.');
	writeln('	c.Listar celulares con cierta descripcion.');
	writeln('	d.Exportar TXT con celulares iguales.');
	writeln('	x.Salir');	
	readln(e);
end;

procedure crearRegistro(var fP:filePhone);
var
	txt:Text;
	nom:str20;
	cel:celular;
begin
	writeln('Como quieres llamar al archivo de registros?');
	readln(nom);
	
	assign(fP,nom);
	assign(txt,'celulares.txt');
	
	rewrite(fP);
	reset(txt);
	while not(eof(txt)) do
	begin
		with cel do readln(txt,cod,precio,marca);
		with cel do readln(txt,stdis,stmin,des);
		with cel do readln(txt,nom);
		write(fP,cel);
	end;
	close(txt);
	close(fP);
	writeln('El archivo se creo con exito.');
	readln();
	ClrScr;
end;
procedure print1(x:celular);
begin
	writeln('----------------');
	writeln('Codigo: ',x.cod);
	writeln('Marca: ',x.marca);
	writeln('Nombre: ',x.nom);
	writeln('Descripcion: ',x.des);
	writeln('Precio: ',x.precio:2:2);
	writeln('Stock Min.: ',x.stmin);
	writeln('Stock Disp.: ',x.stdis);
end;
procedure listarStockMin(var fP:filePhone);
var
	x:celular;
begin
	assign(fP, 'celulares');
	reset(fP);
	while not(eof(fP)) do
	begin
		read(fP,x);
		if (x.stmin > x.stdis) then
			print1(x);
	end;
	close(fP);
	writeln('----------------');
	writeln('Fin de la lista.');
	readln();
	ClrScr;
end;

procedure buscarDes(var fP:filePhone);
var
	str:str20;
	x:celular;
begin
	writeln('Descripcion a buscar: ');
	readln(str);
	str:= ' ' + str;
	assign(fP,'celulares');
	reset(fP);
	while not(eof(fP)) do
	begin
		read(fP,x);
		if x.des = str then
			print1(x);
	end;
	close(fP);
	writeln('----------------');
	writeln('Termino la lista');
	readln();
	ClrScr;
end;
procedure celIgualTxt(var fP:filePhone);
var
	txt:Text;
	nom:str20;
	x:celular;
begin
	writeln('Como se llama el archivo de registros: ');
	readln(nom);
	assign(fP,nom);
	assign(txt,'celulares2.txt');
	reset(fP);
	rewrite(txt);
	while not(eof(fP))do
	begin
		read(fP,x);
		with x do writeln(txt,cod,' ',precio:2:2,' ',marca);
		with x do writeln(txt,stdis,' ',stmin,' ',des);
		with x do writeln(txt,nom);
	end;
	close(fP);
	close(txt);
	writeln('Archivo creado');
	readln();
	ClrScr;
end;
//Principal
var
	fP:filePhone;
	elec:char;
Begin
	elec:='/';
	while (elec <> 'x') do
	begin
		Menu(elec);
		ClrScr;
		case elec of
			'a': crearRegistro(fP);
			'b': listarStockMin(fP);
			'c': buscarDes(fP);
			'd': celIgualTxt(fP);
	end;
end;
end.

