program generarArchivos;

uses SysUtils, Math;

type
  maestro = record
    nom: string[20];
    cantA: integer;
    totE: integer;
  end;

const
  MAX = 5;
  CANT_MAX = 10;

var
  archivoMaestro: file of maestro;
  m,c: maestro;
  i, j, n: integer;
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
  Reset(archivoMaestro);
  n := FileSize(archivoMaestro);
  for i := 1 to n - 1 do
    for j := i + 1 to n do
    begin
      Seek(archivoMaestro, i - 1);
      Read(archivoMaestro, m);
      Seek(archivoMaestro, j - 1);
      Read(archivoMaestro, c);
      if m.nom > c.nom then
      begin
        Seek(archivoMaestro, i - 1);
        Write(archivoMaestro, c);
        Seek(archivoMaestro, j - 1);
        Write(archivoMaestro, m);
      end;
    end;
  Close(archivoMaestro);

  writeln('Archivo maestro ordenado correctamente');
end.
