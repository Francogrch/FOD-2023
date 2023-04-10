program generarArchivosDetalles;

type
  maestro = record
    nom: string[20];
    cantA: integer;
    totE: integer;
  end;

  detalle = record
    nom: string[20];
    codLoc: integer;
    cantA: integer;
    cantE: integer;
  end;

var
  archivoMaestro: file of maestro;
  archivoDetalle1, archivoDetalle2: file of detalle;
  regDetalle1, regDetalle2: detalle;
  regMaestro: maestro;
  i: integer;

begin
  // Abrir archivo maestro para lectura
  assign(archivoMaestro, 'maestro.dat');
  reset(archivoMaestro);

  // Crear y abrir archivos detalle para escritura
  assign(archivoDetalle1, 'detalle1.dat');
  rewrite(archivoDetalle1);

  assign(archivoDetalle2, 'detalle2.dat');
  rewrite(archivoDetalle2);

  // Leer registro del archivo maestro
  read(archivoMaestro, regMaestro);

  // Generar nombres aleatorios y ordenarlos
  randomize;

  // Generar detalles y escribir en los archivos correspondientes
  while not eof(archivoMaestro) do begin
    for i := 1 to 5 do begin
      regDetalle1.nom := regMaestro.nom;
      regDetalle1.codLoc := i;
      regDetalle1.cantA := random(100);
      regDetalle1.cantE := random(100);
      write(archivoDetalle1, regDetalle1);
    end;

    for i := 6 to 10 do begin
      regDetalle2.nom := regMaestro.nom;
      regDetalle2.codLoc := i;
      regDetalle2.cantA := random(100);
      regDetalle2.cantE := random(100);
      write(archivoDetalle2, regDetalle2);
    end;

    read(archivoMaestro, regMaestro);
  end;

  // Cerrar archivos
  close(archivoMaestro);
  close(archivoDetalle1);
  close(archivoDetalle2);
end.


