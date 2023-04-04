{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program punto2;
type
	arch= file of integer;
	nombre = string[20];
var
	arch_num:arch;
	nom:nombre;
	prom:real;
	cant:integer;
	num:integer;
begin
	cant:=0;
	writeln('Ingresar nombre del archivo: ');
	readln(nom);
	Assign(arch_num,nom); // Relacion entre nombre y variable
	reset(arch_num);
	prom:=0;
	while not(eof(arch_num)) do
	begin
		read(arch_num,num);
		writeln(num);
		if num < 1500 then
		begin
			cant:=cant+1;
		end;
		prom:=prom+num;
	end;
	prom:= prom / (FileSize(arch_num));
	writeln('El promedio es ', prom:2, ' y la cantidad de numeros menores a 1500 es ',cant );
	close(arch_num);
end.
