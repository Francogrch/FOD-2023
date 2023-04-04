program punto1;
uses
  SysUtils;
const valor_alto = 999;
type
	empleado = record
		cod:integer;
		nom:string[20];
		monto:real;
	end;
	arch_emp = file of empleado;
	
procedure crear_y_cargar_archivo(var f_emp: arch_emp); //CHATgpt
var
  e: empleado;
  i: integer;
begin
  Randomize; // Inicializar generador de números aleatorios
  for i := 1 to 5 do // Cambia 50 por la cantidad de empleados que desees crear
  begin
    e.cod := i;
    e.nom := 'Empleado ' + IntToStr(i);
    e.monto := Random(1000); // Asignar un valor aleatorio de 0 a 999.99
    write(f_emp, e);
    e.cod := i;
    e.nom := 'Empleado ' + IntToStr(i);
    e.monto := Random(1000); // Asignar un valor aleatorio de 0 a 999.99
    write(f_emp, e);
  end;
end;

procedure mostrar_empleados(var f_emp: arch_emp);//CHATgpt
var
  e: empleado;
begin
  reset(f_emp);
  while not eof(f_emp) do
  begin
    read(f_emp, e);
    writeln('Código: ', e.cod);
    writeln('Nombre: ', e.nom);
    writeln('Monto: $', e.monto:0:2); // Formatear el monto para que muestre dos decimales
    writeln;
  end;
  close(f_emp);
end;

procedure leer(var f_emp:arch_emp;var e:empleado);
begin
	if not(eof(f_emp)) then
		read(f_emp,e)
	else
		e.cod:= valor_alto;
end;
var
	f_emp,f_eN:arch_emp;
	e,act:empleado;
begin
	assign(f_emp,'punto1_e.dat');
	assign(f_eN, 'punto1_n.dat');
	reset(f_emp);
	//rewrite(f_emp);
	//crear_y_cargar_archivo(f_emp);
	rewrite(f_eN);
	leer(f_emp,e);
	while (e.cod <> valor_alto) do
	begin
		act:=e;
		act.monto:=0;
		while (act.cod = e.cod) and (e.cod <> valor_alto) do
		begin
			act.monto:= act.monto + e.monto;
			leer(f_emp,e);
		end;
		write(f_eN,act);
	end;
	
	close(f_eN);
	close(f_emp);
	
	writeln('--------------------------------------Viejo');
	mostrar_empleados(f_emp);
	writeln('----------------------------------Nuevo');
	mostrar_empleados(f_eN);
end.
		
