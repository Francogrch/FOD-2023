program punto2;
uses
    SysUtils, StrUtils; 
const valor_alto = 999;

type
	alumno = record
		cod:integer;
		ape:string[20];
		nom:string[20];
		cantF:integer;
		cantSF:integer;
	end;
	alumno_detalle = record
		cod:integer;
		nom:string[20];
		ap_cur:boolean;
		ap_fin:boolean;
	end;
	maestro = file of alumno;
	detalle = file of alumno_detalle;

procedure crearArchivos(var m: maestro; var d: detalle);
var
    a: alumno;
    ad: alumno_detalle;
    i, j: integer;
begin
    randomize;
    rewrite(m);
    rewrite(d);
    for i := 1 to 10 do // Generar 10 alumnos aleatorios
    begin
        a.cod := i;
        a.ape := 'Apellido' + IntToStr(i);
        a.nom := 'Nombre' + IntToStr(i);
        a.cantF := Random(6); // Generar aleatoriamente la cantidad de materias con final aprobado
        a.cantSF := Random(11); // Generar aleatoriamente la cantidad de materias aprobadas sin final
        write(m, a);
        for j := 1 to a.cantF + a.cantSF do // Generar detalles aleatorios correspondientes a las materias aprobadas y no
        begin
            ad.cod := a.cod;
            ad.ap_cur := (j <= a.cantSF); // Indicar si la materia es una cursada aprobada o no
            ad.ap_fin := (j > a.cantSF); // Indicar si la materia es un final aprobado o no
            write(d, ad);
        end;
    end;
    writeln('Archivos creados exitosamente.');
end;
procedure mostrarMaestro(var m: maestro);
var
  a: alumno;
begin
  reset(m);
  while not eof(m) do begin
    read(m, a);
    writeln('Código: ', a.cod);
    writeln('Apellido: ', a.ape);
    writeln('Nombre: ', a.nom);
    writeln('Cantidad de materias con final aprobado: ', a.cantF);
    writeln('Cantidad de materias sin final aprobado: ', a.cantSF);
    writeln;
  end;
  close(m);
end;

procedure mostrarDetalle(var d: detalle);
var
  ad: alumno_detalle;
begin
  reset(d);
  while not eof(d) do begin
    read(d, ad);
    writeln('Código de alumno: ', ad.cod);
    writeln('Aprobó la cursada: ', ad.ap_cur);
    writeln('Aprobó el final: ', ad.ap_fin);
    writeln;
  end;
  close(d);
end;

procedure agregarAlumnosAleatoriosDetalle(var d: detalle; n: integer);
var
  codigos: array of integer;
  i, cod, aprobadoCursada, aprobadoFinal: integer;
  ad: alumno_detalle;
begin
  // Crear un array con los códigos de los alumnos que ya se encuentran en el archivo detalle
  reset(d);
  setlength(codigos, filesize(d));
  i := 0;

  while not eof(d) do begin
    read(d, ad);
    codigos[i] := ad.cod;
    i := i + 1;
  end;
  close(d);

  // Agregar n alumnos aleatorios al archivo detalle con códigos existentes
  randomize;
  reset(d);
  for i := 1 to n do begin
    cod := codigos[random(length(codigos))];
    aprobadoCursada := random(2); // 0 = no aprobado, 1 = aprobado
    aprobadoFinal := random(2); // 0 = no aprobado, 1 = aprobado
    seek(d, filesize(d));
    ad.cod := cod;
    ad.ap_cur := aprobadoCursada = 1;
    ad.ap_fin := aprobadoFinal = 1;
    write(d, ad);
  end;
  close(d);
end;



procedure leer(var f_deta:detalle;var d:alumno_detalle);
begin
	if not(eof(f_deta)) then
		read(f_deta,d)
	else
		d.cod:=valor_alto;
end;
procedure punto1(var m:maestro;var d:detalle);
var
	act:alumno_detalle;
	a:alumno;
	ad:alumno_detalle;
	cantF,cantSF:integer;
begin
	reset(m);
	reset(d);
	leer(d,ad);
	while (ad.cod <> valor_alto) do
	begin
		cantF:=0;
		cantSF:=0;
		act:=ad;
		while (act.cod = ad.cod) do //Suma uno de mas
		begin
			if (act.ap_cur = True) then
				cantSF:= cantSF + 1;
			if (act.ap_fin = True) then
				cantF:= cantF + 1;
			leer(d,ad)
		end;
		if not(eof(m)) then
		begin
			read(m,a);
			a.cantF:= cantF;
			a.cantSF:= cantSF;
			seek(m,(filePos(m)-1));
			write(m,a);
		end;
	end;
	close(m);
	close(d);
end;
procedure punto_b(var txt:Text;var m:maestro);
var
	a:alumno;
begin
	reset(m);
	rewrite(txt);
	while not(eof(m)) do
	begin
		read(m,a);
		if (a.cantF = 0) and (a.cantSF > 4) then
		begin
			with a do writeln(txt,' ',nom,' ',ape,' ',cod, ' ', cantF,' ',cantSF,' ');
		end;
	end;
	close(txt);
	close(m);
end;

var
	m:maestro;
	d:detalle;
	txt:Text;
begin
	assign(m,'punto2_maestro.dat');
	assign(d,'punto2_detalle.dat');
	assign(txt,'punto2_txt_b.txt');
	agregarAlumnosAleatoriosDetalle(d,10);
	mostrarMaestro(m);
	punto1(m,d);
	writeln('-----------------------------------------------');
	mostrarMaestro(m);
	writeln('-----------------------------------------------');
	mostrarDetalle(d);
	punto_b(txt,m);
end.
