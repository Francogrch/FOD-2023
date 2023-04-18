program punto7;
type
	str20 = string[20];
	ave = record
		cod:integer;
		nom:str20;
		fam:str20;
		des:str20;
		zona:str20;
	end;
	arch_aves = file of ave;
procedure leer1(var av:ave);
begin
	writeln('Codigo: ');
	readln(av.cod);
	if (av.cod <> 500000) then
	begin
		writeln('Nombre: ');
		readln(av.nom);
		writeln('Familia: ');
		readln(av.fam);
		writeln('Descripcion: ');
		readln(av.des);
		writeln('Zona: ');
		readln(av.zona);
	end;
end;
function buscar(var a:arch_aves;av:ave):integer;
var
	act:ave;
	e:boolean;
begin
	e:=false;
	while not(eof(a)) and not(e) do
	begin
		read(a,act);
		if act.cod = av.cod then
			e:=true
	end;
	if e then
		buscar:=filepos(a)-1
	else
		buscar:=-1;
end;
procedure marcar(var a:arch_aves;pos:integer);
var
	av:ave;
begin
	seek(a,pos);
	read(a,av);
	av.nom:= '^' + av.nom;
	seek(a,pos);
	write(a,av);
end;
procedure mover_eliminar(var a:arch_aves;pos:integer);
var
	aux:ave;
begin
	seek(a,filesize(a)-1);
	read(a,aux);
	seek(a,pos);
	write(a,aux);
	seek(a,filesize(a)-1);
	truncate(a);// Pone EOF al puntero
end;
var
	av:ave;
	a:arch_aves;
	pos:integer;
begin
	assign(a,'aves.dat');
	leer1(av);
	while av.cod <> 500000 do
	begin
		reset(a);
		pos:= buscar(a,av);
		if (pos <> -1) then
		begin
			marcar(a,pos);
			mover_eliminar(a,pos);
		end
		else
			close(a);
	end;
end.
