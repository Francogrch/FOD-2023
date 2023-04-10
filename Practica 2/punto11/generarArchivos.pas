program generarArchivos;

uses SysUtils, Math;

type
  maestro = record
    nom: string[20];
    cantA: integer;
    totE: integer;
  end;

const
  MAX = 100;
  CANT_MAX = 10;

var
  archivoMaestro: file of maestro;
  m: maestro;
  i, j, n, c: integer;
  nom: string[20];
  nombres: array[1..MAX] of string[20];

begin
  // Generar nombres aleatorios y ordenarlos
  randomize;
  for i := 1 to MAX do
    nombres[i] := 'nom' + IntToStr(i);
  for i := 1 to MAX - 1 do
    for j := i + 1 to MAX do
      if nombres[i] > nombres[j] then
      begin
        nom := nombres[i];
        nombres[i] := nombres[j];
        nombres[j] := nom;
      end;
  
  // Generar archivo maestro con valores aleatorios
  assign(archivoMaestro, 'maestro.dat');
  Rewrite(archivoMaestro);
  for i := 1 to MAX do
  begin
    m.nom := nombres[i];
    m.cantA := RandomRange(1, CANT_MAX);
    m.totE := RandomRange(1, m.cantA * CANT_MAX);
    Write(archivoMaestro, m);
  end;
  Close(archivoMaestro);

  writeln('Archivo maestro generado correctamente');
end.
