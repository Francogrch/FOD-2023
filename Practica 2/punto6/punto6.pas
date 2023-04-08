program punto6;
uses
	SysUtils;
const
	valor_alto = 999;
type
	detalle = record
		codLoc:integer;
		codCepa:integer;
		cantAct:integer;
		cantNue:integer;
		cantRec:integer;
		cantFal:integer;
	end;
	maestro = record
		codLoc:integer;
		nomLoc:string[20];
		nomCepa:string[20];
		codCepa:integer;
		cantAct:integer;
		cantNue:integer;
		cantRec:integer;
		cantFal:integer;
	end;
	f_maestro = file of maestro;
	f_detalle = file of detalle;
	a_detalle = array[1..10] of f_detalle;
	a_reg_detalle = array[1..10] of detalle;
	
procedure actualizarMaestro(var m:f_maestro;var a_d:a_detalle);
	procedure leer_d(var f_deta:f_detalle;var d:detalle);
	begin
		if not(eof(f_deta)) then
			read(f_deta,d)
		else
		begin
			d.codLoc:=valor_alto;
			d.codCepa:=valor_alto;
		end;
	end;
	procedure minimo(var a_d:a_detalle;var a_reg_deta:a_reg_detalle;var min_d:detalle);
	var
		i,pos:integer;
	begin
		min_d.codLoc:=valor_alto;
		for i:=1 to 10 do
		begin
			if (a_reg_deta[i].codLoc < min_d.codLoc) then
			begin
				pos:=i;
				min_d:=a_reg_deta[i];
			end;
		end;
		if (min_d.codLoc <> valor_alto) then
		begin
			read(a_d[pos],a_reg_deta[pos]);
		end;
	end;
	procedure actualizarRegistro(act:detalle;var m:f_maestro);
		procedure leer(var m:f_maestro;var reg_m:maestro);
		begin
			if not(eof(m))then
				read(m,reg_m)
			else
				reg_m.codLoc:= valor_alto;
		end;
	var
		reg_m:maestro;
	begin
		leer(m,reg_m); //NO FUNCIONA
		while (reg_m.codLoc <> valor_alto) and (reg_m.codLoc < act.codLoc) and (reg_m.codCepa < act.codCepa) do
		begin	
			writeln('CodLoc: ',reg_m.codLoc);
			writeln('Cod: ',act.codLoc);
			leer(m,reg_m);
		end;
		if (reg_m.codLoc <> valor_alto) then
		begin
			with reg_m do
			begin
				cantAct:=act.cantAct;
				cantNue:=act.cantNue;
				cantRec:=act.cantRec;
				cantFal:=act.cantFal;
			end;
			seek(m,filepos(m)-1);
			write(m,reg_m);
		end;
	end;
var
	i:integer;
	actual,min_d:detalle;
	a_reg_deta:a_reg_detalle;
begin
	for i:=1 to 10 do
	begin
		reset(a_d[i]);
		leer_d(a_d[i],a_reg_deta[i]);
	end;
	reset(m);
	minimo(a_d,a_reg_deta,min_d);
	while (min_d.codLoc <> valor_alto) do
	begin
		actual:=min_d;
		while (min_d.codCepa = actual.codCepa) do
		begin
			actual.cantFal := min_d.cantFal + actual.cantFal;
			actual.cantRec := min_d.cantRec + actual.cantRec;
			actual.cantAct:= min_d.cantAct;
			actual.cantNue:= min_d.cantNue;
			minimo(a_d,a_reg_deta,min_d);
		end;
		actualizarRegistro(actual,m);
	end;
	
	close(m);
	for i:=1 to 10 do
	begin
		close(a_d[i]);
	end;
end;
var
	i:integer;
	m:f_maestro;
	a_deta:a_detalle;

begin
	assign(m,'maestro.dat');
	for i:=1 to 10 do
	begin
		assign(a_deta[i],'detalle_' + IntToStr(i) + '.dat');
	end;
	actualizarMaestro(m,a_deta);
end.
