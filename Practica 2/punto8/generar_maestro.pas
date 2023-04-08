program crearArchivoClientesAleatorios;
uses
  SysUtils;
type
  cliente = record
    cod: integer;
    nom: string[20];
    ape: string[20];
    anio: integer;
    mes: integer;
    dia: integer;
    montoVenta: real;
  end;
  f_file = file of cliente;
procedure imprimirClientes(var archivo: f_file);
var
  reg: cliente;
begin
  reset(archivo);
  while not eof(archivo) do
  begin
    read(archivo, reg);
    writeln('Código: ', reg.cod);
    writeln('Nombre: ', reg.nom);
    writeln('Apellido: ', reg.ape);
    writeln('Fecha de venta: ', reg.dia, '/', reg.mes, '/', reg.anio);
    writeln('Monto de venta: $', reg.montoVenta:0:2);
    writeln;
  end;
  close(archivo);
end;
procedure ordenarArchivo(var archivo: f_file);
var
  regActual, regSiguiente, regAux: cliente;
  i, j: integer;
  cambios: boolean;
begin
  reset(archivo);
  cambios := True;
  while cambios do
  begin
    cambios := False;
    seek(archivo, 0);
    read(archivo, regActual);
    for i := 1 to filesize(archivo) - 1 do
    begin
      read(archivo, regSiguiente);
      if (regSiguiente.cod < regActual.cod) or
        ((regSiguiente.cod = regActual.cod) and (regSiguiente.anio < regActual.anio)) or
        ((regSiguiente.cod = regActual.cod) and (regSiguiente.anio = regActual.anio) and (regSiguiente.mes < regActual.mes)) then
      begin
        cambios := True;
        regAux := regActual;
        regActual := regSiguiente;
        regSiguiente := regAux;
        seek(archivo, i-1);
        write(archivo, regActual);
        seek(archivo, i);
        write(archivo, regSiguiente);
      end
      else
        regActual := regSiguiente;
    end;
  end;
  close(archivo);
end;


procedure crearArchivoClientesAleatorios(nombreArchivo: string);
var
  archivo: f_file;
  reg: cliente;
  i: integer;
begin
  // Abrir archivo para escritura
  assign(archivo, 'maestro.dat');
  rewrite(archivo);

  // Generar códigos únicos para los clientes
  randomize;
  for i := 1 to 100 do
  begin
    // generar código único
    reg.cod := random(10) + 1;

    // generar datos aleatorios
    reg.nom := 'Cliente' + IntToStr(i);
    reg.ape := 'Apellido' + IntToStr(i);
    reg.anio := random(5) + 2018;
    reg.mes := random(12) + 1;
    reg.dia := random(28) + 1;
    reg.montoVenta := random(10000) / 100;

    // agregar registro al archivo
    seek(archivo, filesize(archivo));
    write(archivo, reg);
  end;

  // Cerrar archivo
  close(archivo);
  ordenarArchivo(archivo);
  
  imprimirClientes(archivo);
end;

begin
  crearArchivoClientesAleatorios('clientes.dat');
  
end.

