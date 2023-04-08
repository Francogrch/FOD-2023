program generar_archivo_aleatorio;

type
    mesa = record
        codProv: integer;
        codLoc: integer;
        num: integer;
        votos: integer;
    end;

var
    archivo: file of mesa;
    registro: mesa;
    cantMesas, i: integer;

begin
    writeln('Ingrese la cantidad de mesas a registrar:');
    readln(cantMesas);

    assign(archivo, 'mesas.dat');
    rewrite(archivo);

    randomize; // Inicializa el generador de números aleatorios

    for i := 1 to cantMesas do begin
        registro.codProv := Random(100); // Genera un número aleatorio entre 0 y 99
        registro.codLoc := Random(1000); // Genera un número aleatorio entre 0 y 999
        registro.num := Random(100); // Genera un número aleatorio entre 0 y 99
        registro.votos := Random(1000); // Genera un número aleatorio entre 0 y 999

        write(archivo, registro);
    end;

    close(archivo);
end.
