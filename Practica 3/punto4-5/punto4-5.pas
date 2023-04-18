program punto4;
const
	valor_alto = 999;
type
	reg_flor = record
		nombre:String[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;
procedure leer(var a:tArchFlores;var f:reg_flor);
begin
	if not(eof(a)) then
		read(a,f)
	else
		f.codigo:= valor_alto;
end;
procedure agregarFlor(var a:tArchFlores; nombre:string; codigo:integer); //Algoritmo dar alta CORREGIDO/FUNCIONA PERFECTO
var
	pos,posCa:integer;
	f:reg_flor;
begin
	reset(a);
	read(a,f);
	posCa:=f.codigo;
	if posCa <> 0 then
	begin
		seek(a,abs(posCa));
		read(a,f);
		//No puede haber un codigo mayor a 0? NO, porque si hay solo un registro a pisar lo que estamos moviendo a la cabecera es 0
		pos:=f.codigo;
		seek(a,filepos(a)-1);
		f.codigo:=codigo;
		f.nombre:=nombre;
		write(a,f);
		seek(a,0);
		f.codigo:=pos;
		write(a,f);
	end
	else
	begin
		seek(a,filesize(a));
		f.codigo:=codigo;
		f.nombre:=nombre;
		write(a,f);
	end;
	close(a);
end;
procedure imprimirFlores(var a:tArchFlores);
	procedure imprimir(f:reg_flor);
	begin
		writeln('Codigo: ',f.codigo);
		writeln('Nombre: ',f.codigo);
		writeln('---------------------');
	end;
var
	f:reg_flor;
begin
	leer(a,f);
	while f.codigo <> valor_alto do
	begin
		if f.nombre[0] <> '^' then
			imprimir(f)
	end;
end;
procedure elimianrFlor(var a:tArchFlores; flor:reg_flor);
var
	act:reg_flor;
	encontre:boolean;
	pos,posCa:integer;
begin
	encontre:=false;
	leer(a,act);
	posCa:=act.codigo;
	while not(encontre) and (act.codigo <> valor_alto) do
	begin
		if (act.codigo = flor.codigo) then
			encontre:=true;
		leer(a,act);
	end;
	if encontre then
	begin
		pos:=filepos(a)-1; // Guardo la posicion a eliminar
		seek(a,pos);
		read(a,act);
		act.nombre:= '^' + act.nombre; //Modifico nombre
		act.codigo:=posCa; //Swap con la cabecera
		seek(a,pos);
		write(a,act);
		seek(a,0);
		read(a,act);
		act.codigo:=pos * -1;
		seek(a,0);
		write(a,act);
	end;
end;

var
	a:tArchFlores;
begin
	assign(a,'flores.dat');
	agregarFlor(a,'Flor',123);
	imprimirFlores(a);
end. 
