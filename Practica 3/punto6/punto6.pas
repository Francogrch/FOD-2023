program punto6;
type
	str20 = string[20];
	prenda = record
		cod_prenda:integer;
		descripcion:str20;
		colores:str20;
		tipo_prenda:integer;
		stock:integer;
		precio_unitario:integer;
	end;
	arch_prenda = file of prenda;
	arch_detalle = file of integer;

procedure bajasLogicas(var a:arch_prenda;var d:arch_detalle);
	function buscar(var a:arch_prenda;cod:integer):integer;
	var
		p:prenda;
		encontro:boolean;
	begin
		encontro:=false;
		seek(a,0);
		while not(eof(a)) and not(encontro) do
		begin
			read(a,p);
			if p.cod_prenda = cod then
				encontro:=true;
		end;
		if encontro then
			buscar:=filepos(a)-1
		else
			buscar:=-1;
	end;
	procedure eliminacionLogica(var a:arch_prenda;pos:integer);
	var
		p:prenda;
	begin
		seek(a,pos);
		read(a,p);
		p.stock:= p.stock *-1;
		seek(a,pos);
		write(a,p);
	end;
var
	cod,pos:integer;
begin
	reset(a);
	reset(d);
	while not(eof(d)) do
	begin
		read(d,cod);
		pos:= buscar(a,cod);
		if pos <> -1 then
		begin
			eliminacionLogica(a,pos)
		end;
	end;
	close(a);
	close(d);
end;
procedure generarNuevo(var a:arch_prenda;var aN:arch_prenda);
var
	p:prenda;
begin
	reset(a);
	rewrite(aN);
	while not(eof(a)) do
	begin
		read(a,p);
		if p.stock >= 0 then
			write(aN,p);
	end;
	close(a);
	close(aN);
end;
var
	a,aN:arch_prenda;
	d:arch_detalle;
begin
	assign(a,'maestro.dat');
	assign(d,'detalle.dat');
	assign(aN,'maestroNuevo.dat');
	bajasLogicas(a,d);
	generarNuevo(a,aN);
end.
