program ordenarMaestro;
uses
	Math;
type
  maestro = record
    anio: integer;
    mes: integer;
    dia: integer;
    idUsuario: integer;
    tiempo: integer;
  end;

const
  MAX = 100;
  ANIO_MIN = 2020;
  ANIO_MAX = 2022;
  MES_MIN = 1;
  MES_MAX = 12;
  DIA_MIN = 1;
  DIA_MAX = 31;
  ID_MIN = 1;
  ID_MAX = 50;
  TIEMPO_MIN = 1;
  TIEMPO_MAX = 100;

var
  archivoMaestro: file of maestro;
  m: maestro;
  i, j: integer;
  anio, mes, dia, idUsuario, tiempo: integer;

begin
  randomize;

  // Generar archivo maestro con valores aleatorios
  assign(archivoMaestro, 'maestro.dat');
  Rewrite(archivoMaestro);
  for i := 1 to MAX do
  begin
    anio := RandomRange(ANIO_MIN, ANIO_MAX + 1);
    mes := RandomRange(MES_MIN, MES_MAX + 1);
    dia := RandomRange(DIA_MIN, DIA_MAX + 1);
    idUsuario := RandomRange(ID_MIN, ID_MAX + 1);
    tiempo := RandomRange(TIEMPO_MIN, TIEMPO_MAX + 1);

    m.anio := anio;
    m.mes := mes;
    m.dia := dia;
    m.idUsuario := idUsuario;
    m.tiempo := tiempo;

    Write(archivoMaestro, m);
  end;
  Close(archivoMaestro);

  // Ordenar archivo maestro por anio, mes, dia e idUsuario
  Reset(archivoMaestro);
  for i := 1 to MAX - 1 do
    for j := i + 1 to MAX do
      begin
        Seek(archivoMaestro, i - 1);
        Read(archivoMaestro, m);
        anio := m.anio;
        mes := m.mes;
        dia := m.dia;
        idUsuario := m.idUsuario;

        Seek(archivoMaestro, j - 1);
        Read(archivoMaestro, m);

        if (m.anio < anio) or
           ((m.anio = anio) and (m.mes < mes)) or
           ((m.anio = anio) and (m.mes = mes) and (m.dia < dia)) or
           ((m.anio = anio) and (m.mes = mes) and (m.dia = dia) and (m.idUsuario < idUsuario)) then
        begin
          Seek(archivoMaestro, i - 1);
          Write(archivoMaestro, m);

          Seek(archivoMaestro, j - 1);
          Write(archivoMaestro, m);

          anio := m.anio;
          mes := m.mes;
          dia := m.dia;
          idUsuario := m.idUsuario;
        end;
      end;
  Close(archivoMaestro);

  writeln('Archivo maestro generado y ordenado correctamente');
end.

