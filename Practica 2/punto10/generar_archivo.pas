program generar_archivo;

type
  empleado = record
    depto: integer;
    divi: integer;
    numEmp: integer;
    cat: integer;
    cantHor: integer;
  end;
	f_arch = file of empleado;
const
  CANT_EMPLEADOS = 100;

procedure generarRegistros(var archivo: f_arch);
var
  emp: empleado;
  i: integer;
begin
  for i := 1 to CANT_EMPLEADOS do
  begin
    emp.depto := Random(10); // valores entre 0 y 9
    emp.divi := Random(10); // valores entre 0 y 9
    emp.numEmp := i;
    emp.cat := Random(15) + 1; // valores entre 1 y 15 inclusive
    emp.cantHor := Random(40) + 120; // valores entre 120 y 159 inclusive
    Write(archivo, emp);
  end;
end;

procedure ordenarRegistros(var archivo: f_arch);
var
  regActual, regSiguiente, aux: empleado;
  i, j, cantRegistros: integer;
begin
  // Obtener la cantidad de registros en el archivo
  cantRegistros := FileSize(archivo);

  // Algoritmo de ordenamiento de la burbuja
  for i := 1 to cantRegistros - 1 do
  begin
    for j := 1 to cantRegistros - i do
    begin
      Seek(archivo, j-1);
      Read(archivo, regActual);
      Read(archivo, regSiguiente);

      if (regActual.depto > regSiguiente.depto) or
         ((regActual.depto = regSiguiente.depto) and (regActual.divi > regSiguiente.divi)) or
         ((regActual.depto = regSiguiente.depto) and (regActual.divi = regSiguiente.divi) and (regActual.numEmp > regSiguiente.numEmp)) then
      begin
        // Intercambio de registros
        aux := regActual;
        Seek(archivo, j-1);
        Write(archivo, regSiguiente);
        Write(archivo, aux);
      end;
    end;
  end;
end;
var
  archivo: file of empleado;
begin
  Assign(archivo, 'empleados.dat');
  Rewrite(archivo);
  generarRegistros(archivo);
  Close(archivo);

  Reset(archivo);
  ordenarRegistros(archivo);
  Close(archivo);
end.
