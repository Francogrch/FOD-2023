program punto8;
type
	str20 = string[20];
	distro = record
		nom:str20;
		anio:integer;
		kernel:integer;
		cantD:integer;
		des:str20;
	end;
	arch_linux = file of distro;

procedure leer1(var d:distro);
begin
	writeln('Nombre: ');
	readln(d.nom);
	writeln('Anio: ');
	readln(d.anio);
	writeln('Kernel: ');
	readln(d.kernel);
	writeln('Cant. Desarrolladores: ');
	readln(d.cantD);
	writeln('Descripcion: ');
	readln(d.des);
end;
function existeDistribucion(var a:arch_linux;d:distro):boolean;
var
	act:distro;
	encontro:boolean;
begin
	encontro:=false;
	reset(a);
	while not(eof(a)) and not(encontro)do
	begin
		read(a,act);
		if act.nom = d.nom then
			encontro:=true
	end;
	existeDistribucion:=encontro;
	close(a);
end;

procedure altaDistribucion(var a:arch_linux);
var
	posCa:integer;
	aux:distro;
	d:distro;
begin
	leer1(d);
	if not(existeDistribucion(a,d)) then
	begin
		reset(a);
		read(a,aux);
		posCa:=aux.cantD * -1;
		seek(a,posCa);
		read(a,aux);
		posCa:=aux.cantD;
		seek(a,filepos(a)-1);
		write(a,d);
		seek(a,0);
		aux.cantD:=posCa;
		write(a,aux);
	end
	else
		writeln('Ya existe la distribucion');
	close(a);
end;

procedure bajaDistribucion(var a:arch_linux);
var
	pos:integer;
	d,aux:distro;
	e:boolean;
begin
	reset(a);
	e:=false;
	leer1(d);
	if (existeDistribucion(a,d)) then
	begin
		read(a,aux);
		pos:=aux.cantD;
		while not(eof(a)) and not(e)do
		begin
			read(a,aux);
			if aux.nom = d.nom then
				e:=true;
		end;
		aux.cantD:=pos;
		aux.nom:= '^' + aux.nom;
		pos:=filepos(a)-1;
		seek(a,pos);
		write(a,aux);
		seek(a,0);
		read(a,aux);
		aux.cantD:= pos * -1;
		seek(a,0);
		write(a,aux);
	end
	else
		writeln('Distribucion no existente');
	close(a);
end;
var
	a:arch_linux;
begin
	assign(a,'distros.dat');
	altaDistribucion(a);
	bajaDistribucion(a);
end.
