program punto12;
const
	valor_alto = 999;
type
	maestro = record
		anio:integer;
		mes:integer;
		dia:integer;
		idUsuario:integer;
		tiempo:integer;
	end;
	f_maestro = file of maestro;

procedure imprimir_maestro(var m:f_maestro);
var
  reg_m:maestro;
begin
  reset(m);
  while not eof(m) do
  begin
    read(m,reg_m);
    with reg_m do
    begin
      writeln('Anio: ', anio, ' Mes: ', mes, ' Dia: ', dia, ' IdUsuario: ', idUsuario, ' Tiempo: ', tiempo);
    end;
  end;
  close(m);
end;

procedure informar(var m:f_maestro);
	procedure leer(var m:f_maestro;var reg:maestro);
	begin
		if not(eof(m)) then
			read(m,reg)
		else
			reg.anio:= valor_alto;
	end;

var
	anio,totalDiaMes,totalMes,totalAnio:integer;
	mesAct,diaAct:integer;
	reg_actual:maestro;
	reg_m:maestro;
begin
	writeln('Anio a informar:');
	readln(anio);
	leer(m,reg_m);
	while (reg_m.anio <> valor_alto) and (reg_m.anio <> anio) do
	begin
		leer(m,reg_m);
	end;
	if reg_m.anio <> anio then
		writeln('Anio no encontrado')
	else
	begin
		totalAnio:=0;
		while (reg_m.anio = anio) do
		begin
			writeln('Anio ',anio);
			mesAct:=reg_m.mes;
			writeln('Mes: ',mesAct);
			totalMes:=0;
			while(mesAct = reg_m.mes) and (reg_m.anio = anio) do
			begin
				diaAct:=reg_m.dia;
				writeln('Dia: ',diaAct);
				totalDiaMes:=0;
				while(diaAct = reg_m.dia) and (mesAct = reg_m.mes) and (reg_m.anio = anio) do
				begin
					reg_actual:=reg_m;
					reg_actual.tiempo:=0;
					while(reg_actual.idUsuario = reg_m.idUsuario) and (diaAct = reg_m.dia) and (mesAct = reg_m.mes) and (reg_m.anio = anio) do
					begin
						reg_actual.tiempo:=reg_m.tiempo + reg_actual.tiempo;
						totalDiaMes:=totalDiaMes + reg_actual.tiempo;
						leer(m,reg_m);
					end;
					with reg_actual do begin
					writeln('idUsuario: ',idUsuario,' Tiempo total: ',tiempo,' en el dia ',dia,' mes ',mes);
					end;
				end;
				writeln('Tiempo total ',totalDiaMes,' acceso dia ',reg_actual.dia,' mes ', reg_actual.mes);
				totalMes:=totalDiaMes + totalMes;
			end;
			totalAnio:=totalAnio+totalMes;
			writeln('Total mes ',reg_actual.mes,' ',totalMes);
		end;
		writeln('Total anio ',anio,' ',totalAnio);
	end;
end;
var
	m:f_maestro;
begin
	assign(m,'maestro.dat');
	imprimir_maestro(m);
	reset(m);
	informar(m);
	close(m);
end.
