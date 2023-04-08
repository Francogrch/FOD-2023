program punto9;
const
	valor_alto = 999;
type

	mesa = record
		codProv:integer;
		codLoc:integer;
		num:integer;
		votos:integer;
	end;
	f_maestro = file of mesa;
procedure leer(var m:f_maestro;var reg:mesa);
begin
	if not(eof(m)) then
		read(m,reg)
	else
		reg.codLoc:= valor_alto;
end;
var
	provAct,locAct,votosLoc,votosProv,votosGeneral:integer;
	m:f_maestro;
	reg_m:mesa;
begin
	assign(m,'mesas.dat');
	reset(m);
	votosGeneral:= 0;
	leer(m,reg_m);
	while (reg_m.codProv <> valor_alto) do
	begin
		votosProv:=0;
		provAct:=reg_m.codProv;
		writeln('Codigo de Provincia ',provAct);
		while (provAct = reg_m.codProv) do
		begin
			votosLoc:=0;
			locAct:=reg_m.codLoc;
			writeln('Codigo de Localidad       Total de votos');
			while(locAct = reg_m.codLoc) and (reg_m.codProv = provAct) do
			begin
				leer(m,reg_m);
				votosLoc:=votosLoc + reg_m.votos;
			end;
			writeln(locAct,'                       ',votosLoc);
			votosProv:= votosLoc + votosProv;
		end;
		writeln('Total de votos Provincia: ',votosProv);
		votosGeneral:=votosProv+votosGeneral;
		writeln('--------------------------------------------------------');
	end;
	writeln('Total General de votos: ',votosGeneral);
	close(m);
end.
