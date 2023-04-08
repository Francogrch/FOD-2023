program punto10;
uses
	SysUtils;
const
	valor_alto = 999;
type
	empleado = record
		depto:integer;
		divi:integer;
		numEmp:integer;
		cat:integer; // varia entre 1 y 15
		cantHor:integer;
	end;
	f_maestro = file of empleado;
	a_valores = array[1..15] of integer;
procedure leer(var m:f_maestro;var reg:empleado);
begin
	if not(eof(m)) then
		read(m,reg)
	else
		reg.depto:=valor_alto;
end;
procedure cargarMonto(var txt:Text;var a_m:a_valores);
var
	valor:string;
	i:integer;
begin
	reset(txt);
	for i:=1 to 15 do
	begin
		readln(txt,valor);
		a_m[i]:=StrToInt(valor);
	end;
	close(txt);
end;
var
	a_monto:a_valores;
	reg:empleado;
	m:f_maestro;
	txt:Text;
	deptoAct,diviAct:integer;
	empAct:empleado;
	horasDiv,horasDep,monDiv,monDep: integer;
	impEmpl:integer;
begin
	assign(m,'empleados.dat');
	assign(txt,'montos.txt');
	reset(m);
	cargarMonto(txt,a_monto);
	leer(m,reg);
	while (reg.depto <> valor_alto) do
	begin
		deptoAct:=reg.depto;
		writeln('Departameto: ',deptoAct);
		horasDep:=0;
		monDep:=0;
		while (deptoAct = reg.depto) do
		begin
			monDiv:=0;
			horasDiv:=0;
			diviAct:=reg.divi;
			writeln('Division: ',diviAct);
			writeln('Numero de Empleado   Total de Hs.   Importe a cobrar');
			while (diviAct = reg.divi) and (deptoAct = reg.depto) do
			begin
				empAct:=reg;
				empAct.cantHor:=0;
				while (empAct.numEmp = reg.numEmp) and (diviAct = reg.divi) and (deptoAct = reg.depto) do
				begin
					empAct.cantHor:=empAct.cantHor + reg.cantHor;
					leer(m,reg);
				end;
				impEmpl:=empAct.cantHor * a_monto[empAct.cat];
				writeln(empAct.numEmp,'                     ',empAct.cantHor,'                ',impEmpl);
				horasDiv:=horasDiv + empAct.cantHor;
				monDiv:=impEmpl + monDiv;
				writeln('------------------------------------');
			end;
			writeln('Total de horas division: ',horasDiv);
			writeln('Monto total por division: ',monDiv);
			writeln('----------------------------------------------');
			horasDep:=horasDep + horasDiv;
			monDep:=monDep + monDiv;
		end;
		writeln('Total horas departamento: ',horasDep);
		writeln('Total monto departamento: ',monDep);
		writeln('-------------------------------------------------------------');
	end;
end.
