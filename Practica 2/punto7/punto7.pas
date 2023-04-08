program punto7;
uses
	SysUtils;
const
	valor_alto = 9999;
type
	producto = record
		cod:integer;
		nom:string[20];
		precio:integer;
		stcAct:integer;
		stcMin:integer;
	end;
	venta = record
		cod:integer;
		cant:integer;
	end;
	f_maestro = file of producto;
	f_detalle  = file of venta;

procedure generarMaestro(var m:f_maestro);
var
	i:integer;
	p:producto;
begin
	Randomize;
	rewrite(m);
	for i:=1 to 15 do
	begin
		p.cod:=i;
		p.nom:=IntToStr(i);
		p.precio:=Random(100);
		p.stcAct:=Random(10);
		p.stcMin:=Random(10);
		write(m,p);
	end;
	close(m);
	writeln('Archivo Maestro generado con exito.');
	readln();
end;
procedure leer_m(var f:f_maestro;var reg:producto);
begin
	if not(eof(f)) then
		read(f,reg)
	else
		reg.cod:=valor_alto;
end;
	
procedure generarDetalles(var d:f_detalle);
var
	i,pas:integer;
	v:venta;
begin
	rewrite(d);
	Randomize;
	pas:=1;
	for i:=1 to 20 do
	begin
		v.cod:=pas;
		v.cant:=Random(10);
		write(d,v);
		pas:=random(3) + pas;
	end;
	close(d);
	writeln('Archivo DETALLE generado con exito.');
	readln();
end;

procedure actualizarMaestro(var m:f_maestro;var d:f_detalle);
	procedure leer_d(var f:f_detalle;var reg:venta);
	begin
		if not(eof(f)) then
			read(f,reg)
		else
			reg.cod:=valor_alto;
	end;
var
	reg_d:venta;
	reg_m:producto;
begin
	reset(d);
	reset(m);
	leer_d(d,reg_d);
	leer_m(m,reg_m);
	while (reg_d.cod <> valor_alto) do
	begin
		while (reg_d.cod > reg_m.cod) do
		begin
			leer_m(m,reg_m)
		end;
		if (reg_d.cod = reg_m.cod) then
		begin
			reg_m.stcAct:= reg_m.stcAct - reg_d.cant;
			seek(m,filepos(m)-1);
			write(m,reg_m);
		end;
		leer_d(d,reg_d);
	end;
	
	close(m);
	close(d);
	writeln('Archivo MAESTRO actualizado con exito.');
	readln();
end;
procedure listarStockMinimo(var txt:Text;var m:f_maestro);
var
	p:producto;
begin
	reset(m);
	rewrite(txt);
	leer_m(m,p);
	while (p.cod <> valor_alto) do
	begin
		if p.stcAct < p.stcMin then
		begin
			with p do 
			begin
			writeln(txt,'Cod: ' + IntToStr(cod) + '.Nombre: ' + nom + '. Precio '+IntToStr(precio) +'.StockA: '+IntToStr(stcAct)+'.Stock Min: '+IntToStr(stcMin) );
			end;
		end;
		leer_m(m,p);
	end; 
	close(m);
	close(txt);
	writeln('Archivo TXT generado con exito.');
	readln();
end;
var
	m:f_maestro;
	d:f_detalle;
	txt:Text;
begin
	assign(m,'maestro.dat');
	assign(d,'detalle.dat');
	assign(txt,'stock_minimo.txt');
	generarMaestro(m);
	generarDetalles(d);
	actualizarMaestro(m,d);
	listarStockMinimo(txt,m);
	
end.
