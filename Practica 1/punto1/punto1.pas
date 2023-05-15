{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.
* 	}
program punto1;
type
	nombre = String[10];
	numero = file of integer;

var
	n:nombre;
	arch_num:numero;
	num:integer;
begin
	writeln('Ingresar nombre de archivo: ');
	readln(n);
	Assign(arch_num, (n)); // Creamos la relacion del nombre del archivo con la variable
	rewrite(arch_num); // Creamos el archivo
	writeln('Ingresar numeros para agregar hasta ingresar el 30000');
	readln(num);
	while num <> 30000 do
	begin
		write(arch_num, num);// Agregamos al archivo num
		readln(num);
	end;
	close(arch_num);
end.
