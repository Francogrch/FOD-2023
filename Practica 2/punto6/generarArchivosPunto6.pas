program generar_archivos;
uses 
	SysUtils;
type
    detalle = record
        codLoc: integer;
        codCepa: integer;
        cantAct: integer;
        cantNue: integer;
        cantRec: integer;
        cantFal: integer;
    end;
    maestro = record
        codLoc: integer;
        nomLoc: string[20];
        nomCepa: string[20];
        codCepa: integer;
        cantAct: integer;
        cantNue: integer;
        cantRec: integer;
        cantFal: integer;
    end;
    arch_detalle = file of detalle;
procedure imprimir_datos();
var
	i, j: integer;
	det: detalle;
	mast: maestro;
	det_files: array[1..10] of file of detalle;
	f_mast: file of maestro;
begin
	// Imprimir detalles
	for i := 1 to 10 do begin
		assign(det_files[i], 'detalle_' + IntToStr(i) + '.dat');
		reset(det_files[i]);

		writeln('Detalle ', i, ':');
		writeln('------------------------------------');
		writeln('CodLoc | CodCepa | CantAct | CantNue | CantRec | CantFal');

		while not eof(det_files[i]) do begin
			read(det_files[i], det);
			with det do
				writeln(codLoc:6, ' | ', codCepa:7, ' | ', cantAct:7, ' | ', cantNue:7, ' | ', cantRec:7, ' | ', cantFal:7);
		end;

		close(det_files[i]);
		writeln();
	end;

	// Imprimir maestro
	assign(f_mast, 'maestro.dat');
	reset(f_mast);

	writeln('Maestro:');
	writeln('------------------------------------');
	writeln('CodLoc | NomLoc                | CodCepa | NomCepa               | CantAct | CantNue | CantRec | CantFal');

	while not eof(f_mast) do begin
		read(f_mast, mast);
		with mast do
			writeln(codLoc:6, ' | ', nomLoc:20, ' | ', codCepa:7, ' | ', nomCepa:20, ' | ', cantAct:7, ' | ', cantNue:7, ' | ', cantRec:7, ' | ', cantFal:7);
	end;

	close(f_mast);
end;

// Ordenar registros por codLoc y codCepa
procedure OrdenarRegistros(var archivo: arch_detalle);
var
  i, j: Integer;
  regActual, regSig: detalle;
  tamArchivo: Integer;
begin
  tamArchivo := filesize(archivo);
  for i := tamArchivo - 1 downto 1 do
    for j := 0 to i - 1 do begin
      // Leer registro actual
      seek(archivo, j);
      read(archivo, regActual);
      
      // Leer registro siguiente
      seek(archivo, j + 1);
      read(archivo, regSig);
      
      // Si el codLoc del registro siguiente es menor, intercambiar registros
      if (regSig.codLoc < regActual.codLoc) or
         ((regSig.codLoc = regActual.codLoc) and (regSig.codCepa < regActual.codCepa)) then begin
        seek(archivo, j);
        write(archivo, regSig);
        
        seek(archivo, j + 1);
        write(archivo, regActual);
      end;
    end;
end;

// Ordenar todos los archivos detalle
procedure OrdenarArchivosDetalle();
var
  i: Integer;
  archivo: file of detalle;
begin
  for i := 1 to 10 do begin
    assign(archivo, 'detalle_' + IntToStr(i) + '.dat');
    reset(archivo);
    OrdenarRegistros(archivo);
    close(archivo);
  end;
end;
var
    i, j: integer;
    det: detalle;
    mast: maestro;
    f_det: file of detalle;
    f_mast: file of maestro;
    det_files: array[1..10] of file of detalle;
	temp_file: file of detalle;
	temp_det: detalle;
begin
    randomize;

    // Generar archivo maestro
    assign(f_mast, 'maestro.dat');
    rewrite(f_mast);

    for i := 1 to 100 do begin
        mast.codLoc := i;
        mast.nomLoc := 'Localidad ' + IntToStr(i);
        mast.codCepa := i mod 5 + 1;
        mast.nomCepa := 'Cepa ' + IntToStr(mast.codCepa);
        mast.cantAct := Random(1000);
        mast.cantNue := Random(100);
        mast.cantRec := Random(mast.cantAct - mast.cantNue);
        mast.cantFal := Random(mast.cantNue);
        write(f_mast, mast);
    end;

    close(f_mast);

    // Generar archivos detalle
    for i := 1 to 10 do begin
        assign(det_files[i], 'detalle_' + IntToStr(i) + '.dat');
        rewrite(det_files[i]);

        for j := 1 to 10 do begin
            det.codLoc := Random(100) + 1;
            det.codCepa := det.codLoc mod 5 + 1;
            det.cantAct := Random(100);
            det.cantNue := Random(10);
            det.cantRec := Random(det.cantAct - det.cantNue);
            det.cantFal := Random(det.cantNue);
            write(det_files[i], det);
        end;

        close(det_files[i]);
     end;
		OrdenarArchivosDetalle();
        // Ordenar archivos detalle por codLoc y codCepa
		imprimir_datos();
end.
