{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
	i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
	ii. Listar en pantalla los empleados de a uno por línea.
	iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}
program punto3;
type
	empleado = record
		n:integer;
		ape:string[10];
		nom:string[10];
		edad:integer;
		dni:integer;
	end;
	arch_empl = file of empleado;

procedure asignar(var a:arch_empl);
var
	nom:string[10];
begin
	writeln('Escribir nombre de archivo: ');
	readln(nom);
	Assign(a, nom);
end;
procedure leer1(var e:empleado);
begin
	writeln('Apellido: ');
	readln(e.ape);
	if e.ape <> 'fin' then
	begin
		writeln('Numero: ');
		readln(e.n);
		writeln('Nombre: ');
		readln(e.nom);
		writeln('Edad: ');
		readln(e.edad);
		writeln('DNI: ');
		readln(e.dni);
	end;
end;

procedure crearArchivo(var arch:arch_empl);
var
	e:empleado;
begin
	asignar(arch);
	rewrite(arch);
	leer1(e);
	while (e.ape <> 'fin') do
	begin
		write(arch,e);
		leer1(e);
	end;
	close(arch);
end;

procedure imprimir1(e:empleado);
begin
	writeln('Numero: ',e.n);
	writeln('Nombre: ',e.nom);
	writeln('Apellido: ',e.ape);
	writeln('Edad: ',e.edad);
	writeln('DNI: ',e.dni);
	writeln('------------------');
end;

procedure listarEmpX(var arch:arch_empl);
var
	y:string[10];
	x:empleado;
begin
	asignar(arch);
	writeln('Personas con appelido o nombre: ');
	readln(y);
	reset(arch);
	writeln('------------------');
	while not (eof(arch)) do
	begin
		read(arch, x);
		if (y = x.nom) or (y = x.ape) then
		begin
			imprimir1(x);
		end;
	end;
	close(arch);
end;

procedure listarEmp(var arch:arch_empl);
var
	x:empleado;
begin
	asignar(arch);
	reset(arch);
	writeln('------------------');
	while not (EoF(arch)) do
	begin
		read(arch,x);
		imprimir1(x);
	end;

	close(arch);
end;
procedure listarEmpJ(var arch:arch_empl);
var
	x:empleado;
begin
	asignar(arch);
	reset(arch);
	writeln('------------------');
	while not (eof(arch))do
	begin
		read(arch,x);
		if (x.edad > 70) then
			imprimir1(x);
	end;
	close(arch);
end;
//PRINCIPAL
var
	arch:arch_empl;
	e:char;
begin
	while (e <> 'x') do
		begin
		writeln('Elegir opcion:');
		writeln('a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.');
		writeln('b. Abrir el archivo anteriormente generado');
		writeln('	1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
		writeln('	2. Listar en pantalla los empleados de a uno por línea.');
		writeln('	3. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
		writeln('x. FIN.');
		readln(e);
		if e = 'a' then
		begin
			crearArchivo(arch);
		end;
		if e = 'b' then
		begin
			readln(e);
			if e = '1' then
				listarEmpX(arch);
			if e = '2' then
				listarEmp(arch);
			if e = '3' then
				listarEmpJ(arch);
		end;
		
	end;
end.
