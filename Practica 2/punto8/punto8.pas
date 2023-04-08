program punto8;
uses
	SysUtils;
const
	valor_alto=9999;
type
	cliente = record
		cod:integer;
		nom:string[20];
		ape:string[20];
		anio:integer;
		mes:integer;
		dia:integer;
		montoVenta:real;
	end;
	f_maestro = file of cliente;

procedure leer(var m:f_maestro;var reg:cliente);
begin
	if not(eof(m)) then
		read(m,reg)
	else
		reg.cod:=valor_alto;
end;

var
	c,act:cliente;
	codAct,anioAct,mesAct:integer;
	m:f_maestro;
	monto_empresa:real;
begin
	monto_empresa:=0;
	assign(m,'maestro.dat');
	reset(m);
	leer(m,c);
	while (c.cod <> valor_alto) do
	begin
		act:=c;
		codAct:=c.cod;
		writeln('Codigo: '+ IntToStr(act.cod)+ '. Nombre: '+ act.nom + act.ape);
		while (c.cod = codAct) do
		begin
			anioAct:=c.anio;
			while (c.cod = codAct) and (anioAct = c.anio) do
			begin
				mesAct:=c.mes;
				while (c.cod = codAct) and (anioAct = c.anio) and (mesAct = c.mes) do
				begin
					act.montoVenta:=act.montoventa + c.montoVenta;
					leer(m,c);
				end;
				writeln('VentaMes: ', act.montoVenta:2:2);
				act.montoVenta:=act.montoventa + c.montoVenta;
				leer(m,c);
			end;
			writeln('VentaAnio: ', act.montoVenta:2:2);
			act.montoVenta:=act.montoventa + c.montoVenta;
			leer(m,c);
		end;
		monto_empresa:=monto_empresa + act.montoVenta;
		leer(m,c);
	end;
	writeln('Monto Total: ',monto_empresa:2:2);
	close(m);
end.
