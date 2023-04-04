program punto5;
uses System
const valor_alto = 99999;
const cantArch = 10;
type
	direccion = record
		calle:string[20];
		nro:integer;
		piso:integer;
		depto:integer;
		ciudad:string[20];
	end;
	persona = record
		nom:String[20];
		ape:String[20];
		dni:integer;
	end;
	detalle_nac = record
		nrPa:integer;
		nom:String[20];
		ape:String[20];
		dire:direccion;
		matrMed:integer;
		madre: persona;
		padre: persona;
	end;
	detalle_fall = record
		nrPa:integer;
		nom:String[20];
		ape:String[20];
		dni:integer;
		matMed:integer;
		fecha:integer;
		hora:integer;
		lugar:direccion;
	end;
	maestro = record
		nrPa:integer;
		nom:String[20];
		ape:String[20];
		dni:integer;
		dire:direccion;
		matMed_n:integer;
		madre:persona;
		padre:persona;
		vive:boolean;
		matMed_f:integer;
		fecha:integer;
		hora:integer;
		lugar:direccion;
	end;
	f_nacimiento:file of detalle_nac;
	f_fallecimiento:file of detalle_fall;
	a_nac: array[1..cantArch] of  f_nacimiento;
	a_fal: array[1..cantArch] of  f_fallecimiento;
	ta_reg_nac: array [1..cantArch] of detalle_nac;
	ta_reg_fal: array [1..cantArch] of detalle_fal;
	arch_maestro: file of maestro;
procedure crearMaestro(var a_file_nacimiento:a_nac;var a_file_fallecimiento:a_fal;var m:maestro)
var
	i:integer;
	min_nac:detalle_nac;
	min_fal:detalle_fall;
	a_reg_nac:ta_reg_nac;
	a_reg_fal:ta_reg_fal;
	minimo_maestro:maestro;
begin
	for (i:=1 to cantArch) do
	begin
		reset(a_file_nacimiento[i],'punto5_nacimiento_' + i + '.dat');
		reset(a_file_fallecimiento[i],'punto5_fallecimiento_' + i + '.dat')
		leer(a_file_nacimiento[i],a_reg_nac[i]);
		leer(a_file_fallecimiento[i],a_reg_fal[i]);
	end;
	rewrite(m);
	minimo_nac();
	minimo_fall();
	while (min_nac <> valor_alto) or (min_fal <> valor_alto) do
	begin
		if min_nac
		if (min_nac.nom = min_fal.nom) then
			juntarMin(min_nac,min_fal,minimoMaestro);
		
	end;
end;
var
	a_file_nacimiento:a_nac;
	a_file_fallecimiento:a_fal;
	i:integer;
	nom:string[20];
	m:maestro;
begin
	for (i:=1 to cantArch) do
	begin
		assign(a_file_nacimiento[i],'punto5_nacimiento_' + i + '.dat');
		assign(a_file_fallecimiento[i],'punto5_fallecimiento_' + i + '.dat')
	end;
	assign(m,'maestro.dat');
	crearMaestro(a_file_nacimiento,a_file_fallecimiento,m);
end.
