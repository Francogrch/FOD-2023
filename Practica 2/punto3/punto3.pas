program punto3;
uses SysUtils;
const valor_alto = 999;
const dF = 3;

type
	producto = record
		cod:integer;
		nom:string[20];
		des:string[20];
		stcDis:integer;
		stcMin:integer;
		precio:real;
	end;
	venta = record
		cod:integer;
		cantVen:integer;
	end;
	maestro = file of producto;
	detalle = file of venta;
	a_detalles = array[1..dF] of detalle;
	
	
	
procedure generarArchivosPrueba();
const
  cantProductos = 10;
  cantDetalles = 10;
var
  maestro: file of producto;
  detalles: array[1..cantDetalles] of file of venta;
  prod: producto;
  ven: venta;
  i, j: integer;
begin
  // Generar archivo maestro con 10 productos
  assign(maestro, 'punto3_maestro.dat');
  rewrite(maestro);
  for i := 1 to cantProductos do
  begin
    prod.cod := i;
    prod.nom := 'Producto ' + IntToStr(i);
    prod.des := 'Descripcion del producto ' + IntToStr(i);
    prod.stcDis := 100;
    prod.stcMin := 20;
    prod.precio := 10.5;
    write(maestro, prod);
  end;
  close(maestro);

  // Generar archivos detalle con ventas aleatorias
  for i := 1 to cantDetalles do
  begin
    assign(detalles[i],'punto3_detalle' + IntToStr(i) + '.dat');
    rewrite(detalles[i]);
    for j := 1 to cantProductos do
    begin
      ven.cod := j;
      ven.cantVen := Random(80) + 20; // Cantidad aleatoria entre 20 y 99
      write(detalles[i], ven);
    end;
    close(detalles[i]);
  end;
end;

procedure imprimirMaestro(var m: maestro);
var
  p: producto;
begin
  reset(m);
  while not eof(m) do
  begin
    read(m, p);
    writeln('Código: ', p.cod);
    writeln('Nombre: ', p.nom);
    writeln('Descripción: ', p.des);
    writeln('Stock disponible: ', p.stcDis);
    writeln('Stock mínimo: ', p.stcMin);
    writeln('Precio: ', p.precio);
    writeln('------------------------');
  end;
  close(m);
end;

procedure actualizarStock(var a_deta:a_detalles;var m:maestro);
	procedure minimo(a:a_detalles;var min:venta);
	var
		i:integer;
		v:venta;
	begin
		min.cod:=valor_alto;
		for i:=1 to dF do
		begin
			if not(eof(a[i])) then
			begin
				read(a[i],v);
				if (v.cod < min.cod) then
					min:=v;
			end;
		end;
	end;
	
	procedure actualizarMaestro(var m:maestro; v:venta);
	var
		p:producto;
	begin
		if not(eof(m)) then
		begin
			read(m,p);
			if (v.cod > p.cod) then
			begin
				while (v.cod > p.cod) do
				begin
					read(m,p);
				end;
			end;
			if (v.cod = p.cod) then
			begin
				p.stcDis:= p.stcDis - v.cantVen;
				seek(m,filePos(m)-1);
				write(m,p);
			end
			
		end;
	end;
var
	p_min:venta;
	i:integer;
begin
	assign(m, 'punto3_maestro.dat');
	for i:=1 to dF do
	begin
		reset(a_deta[i]);
	end;
	reset(m);
	minimo(a_deta,p_min);
	while (p_min.cod <> valor_alto) do
	begin
		actualizarMaestro(m,p_min);
		minimo(a_deta,p_min);
	end;
	close(m);
	for i:=1 to dF do
	begin
		close(a_deta[i]);
	end;
end;

procedure generarTxt(var m:maestro);
var
	txt:Text;
	p:producto;
begin
	assign(txt,'prod_debajo_stock.txt');
	reset(m);
	rewrite(txt);
	while not(eof(m)) do
	begin
		read(m,p);
		if (p.stcDis < p.stcMin) then
		begin
			with p do writeln(txt,' ',nom,' ',des,' ',stcDis,' ',precio:2:2);
		end;
	end;
	close(m);
	close(txt);
end;
var
	a_deta:a_detalles;
	i:integer;
	m: maestro;
	n:string[20];
begin
	generarArchivosPrueba();
	assign(m, 'punto3_maestro.dat');
	imprimirMaestro(m);
	writeln('-------------Test-------------');
	
	for i:=1 to dF do
	begin
		n:= 'punto3_detalle' +IntToStr(i)+ '.dat';
		assign(a_deta[i],n);
	end;
	actualizarStock(a_deta,m);
	imprimirMaestro(m);
	generarTxt(m);
end.
