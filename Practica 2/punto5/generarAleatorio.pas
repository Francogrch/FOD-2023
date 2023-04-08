program generar_archivos;
uses SysUtils;
type
  direccion = record
		calle:string[20];
		nro:integer;
		piso:integer;
		depto:integer;
		ciudad:string[20];
	end;
  persona = record
		nom:String[20];
		ape:String[20];
		dni:integer;
	end;
  detalle_nac = record
    nrPa: integer;
    nom: string[20];
    ape: string[20];
    dire: direccion;
    matrMed: integer;
    madre: persona;
    padre: persona;
  end;

  detalle_fall = record
    nrPa: integer;
    nom: string[20];
    ape: string[20];
    dni: integer;
    matMed: integer;
    fecha: integer;
    hora: integer;
    lugar: direccion;
  end;

var
  a_file_nacimiento: array[1..10] of file of detalle_nac;
  a_file_fallecimiento: array[1..10] of file of detalle_fall;
  detalleNac: detalle_nac;
  detalleFall: detalle_fall;
  i, cantArch: integer;
  personaRandom: persona;
  direRandom: direccion;
begin
  randomize;
  cantArch := 10;

  for i := 1 to cantArch do
  begin
    assign(a_file_nacimiento[i], 'punto5_nacimiento_' + IntToStr(i) + '.dat');
    rewrite(a_file_nacimiento[i]);

    assign(a_file_fallecimiento[i], 'punto5_fallecimiento_' + IntToStr(i) + '.dat');
    rewrite(a_file_fallecimiento[i]);
  end;

  for i := 1 to 100 do
  begin
    personaRandom.nom := 'nombre' + IntToStr(i);
    personaRandom.ape := 'apellido' + IntToStr(i);
    personaRandom.dni := random(100000000) + 1;
	
	direRandom.calle := 'calle' + IntToStr(i);
	direRandom.nro:=random(500);
	direRandom.piso:=random(10);
	direRandom.depto:=random(30);
	direRandom.ciudad:='ciudad' + IntToStr(i);
	
    detalleNac.nrPa := i;
    detalleNac.nom := personaRandom.nom;
    detalleNac.ape := personaRandom.ape;
    detalleNac.matrMed := random(1000) + 1;
    detalleNac.madre := personaRandom;
    detalleNac.padre := personaRandom;
    detalleNac.dire:= direRandom;
	
	
	if (i MOD 5 = 0) then
	begin
		detalleFall.nrPa := i;
		detalleFall.nom := personaRandom.nom;
		detalleFall.ape := personaRandom.ape;
		detalleFall.dni := personaRandom.dni;
		detalleFall.matMed := random(1000) + 1;
		detalleFall.fecha := random(31) + 1;
		detalleFall.hora := random(24);
		detalleFall.lugar := direRandom;
		write(a_file_fallecimiento[random(cantArch) + 1], detalleFall);
	end;
    write(a_file_nacimiento[random(cantArch) + 1], detalleNac);
  end;

  for i := 1 to cantArch do
  begin
    close(a_file_nacimiento[i]);
    close(a_file_fallecimiento[i]);
  end;

end.
