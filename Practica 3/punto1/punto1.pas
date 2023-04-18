program punto1;
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
function estaEnArch(var a:arch_empl;e:empleado):boolean;
var
	x:empleado;
	esta:boolean;
begin
	esta:=false;
	while not(eof(a)) and not (esta)  do
	begin
		read(a,x);
		if (x.n = e.n) then
			esta:=true;
	end;
	estaEnArch:=esta;
end;
procedure agregarArch(var a:arch_empl;e:empleado);
begin
	Seek(a, (FileSize(a) - 1));
	write(a,e);
end;
procedure agregarEmp(var arch:arch_empl);
var
	i,x:integer;
	e:empleado;
begin
	asignar(arch);
	reset(arch);
	writeln('Cuantos empleados quieres agregar: ');
	readln(x);
	for i:=1 to x do
	begin
		leer1(e);
		if not(estaEnArch(arch,e)) then
			agregarArch(arch,e)
	end;
	close(arch);
end;
procedure modificarAnio(var a:arch_empl);
	function buscarPos(var a:arch_empl;num:integer):integer;
	var
		esta:boolean;
		pos:integer;
		e:empleado;
	begin
		esta:=false;
		pos:=-1;
		while not(EoF(a)) and not(esta) do
		begin
			pos:=pos+1;
			read(a,e);
			if e.n = num then
				esta:=true;
		end;
		buscarPos:=pos;
	end;
	procedure cambiarEdad(var a:arch_empl;p:integer);
	var
		e:empleado;
		n:integer;
	begin
		Seek(a,p);
		read(a,e);
		writeln('Edad modificada: ');
		readln(n);
		e.edad:=n;
		Seek(a,filepos(a) -1);
		write(a,e);
		writeln('Ya se modifico la edad.');
	end;
var
	i,x,num,pos:integer;
begin
	asignar(a);
	reset(a);
	writeln('Cuantos empleados quieres modificar: ');
	readln(x);
	for i:=1 to x do
	begin
		writeln('Numero de empleado a modificar: ');
		readln(num);
		pos:=buscarPos(a,num);
		if pos <> -1 then
			cambiarEdad(a,pos)
		else
			writeln('El numero no corresponde a ningun empleado');
	end;
	close(a);
end;
procedure exportarTxt(var a:arch_empl);
var
	carga:Text;
	nomArch:string[20];
	x:empleado;
begin
	asignar(a);
	writeln('Nombre archivo TXT: ');
	readln(nomArch);
	assign(carga,nomArch);
	reset(a);
	rewrite(carga);
	while not(eof(a)) do
	begin
		read(a,x);
		with x do writeln(carga,' ',nom,' ',ape,' ',n,' ',edad,' ',dni);
	end;
	close(carga);
	close(a);
end;

procedure armarTxtFaltaDni(var a:arch_empl);
var
	t:Text;
	x:empleado;
begin
	asignar(a);
	reset(a);
	assign(t,'faltaDNIEmpleado.txt');
	rewrite(t);
	while not (eof(a)) do
	begin
		read(a,x);
		if (x.dni = 0) then
		begin
			with x do writeln(t,' ',nom,' ',ape,' ',n,' ',edad,' ',dni);
		end;
	end;
	close(a);
	close(t);
	writeln('El archivo se a generado con exito.')
end;
procedure eliminarPos(var a:arch_empl);
var
	x:integer;
	e:empleado;
begin
	asignar(a);
	reset(a);
	writeln('Posicion a eliminar: ');
	readln(x);
	seek(a,filesize(a)-1);
	read(a,e);
	seek(a,x);
	write(a,e);
	seek(a,(filesize(a)-2));
	truncate(a);
end;
//PRINCIPAL
{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar edad a uno o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00)
e. 1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.
* }
var
	arch:arch_empl;
	e:char;
begin
	e:='a';
	while (e <> 'x') do
		begin
		writeln('Elegir opcion:');
		writeln('a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.');
		writeln('b. Abrir el archivo anteriormente generado');
		writeln('	1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
		writeln('	2. Listar en pantalla los empleados de a uno por línea.');
		writeln('	3. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
		writeln('c. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado. Tener en cuenta que no se debe agregar al archivo un empleado con un número de empleado ya registrado (control de unicidad)');
		writeln('d. Modificar anios a empleado/os.');
		writeln('e. Crear un TXT con la informacion');
		writeln('f. Crear faltaDNIEmpleado.txt');
		writeln('g. Realizar baja en posicion escrita por teclado.');
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
		if e = 'c' then
			agregarEmp(arch);
		if e = 'd' then
			modificarAnio(arch);
		if e = 'e' then
			exportarTxt(arch);
		if e = 'f' then
			armarTxtfaltaDNI(arch);
		if e = 'g' then
			eliminarPos(arch);
	end;
end.
