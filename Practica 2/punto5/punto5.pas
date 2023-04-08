program punto5;
uses SysUtils;
const 
	valor_alto = 9999;
	cantArch = 10;
	valorDefault = -1;
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
	f_nacimiento = file of detalle_nac;
	f_fallecimiento = file of detalle_fall;
	a_nac = array[1..cantArch] of  f_nacimiento;
	a_fal = array[1..cantArch] of  f_fallecimiento;
	ta_reg_nac = array [1..cantArch] of detalle_nac;
	ta_reg_fal = array [1..cantArch] of detalle_fall;
	arch_maestro = file of maestro;
procedure crearMaestro(var a_file_nacimiento:a_nac;var a_file_fallecimiento:a_fal;var m:arch_maestro);
	procedure leer_nac(var file_nac:f_nacimiento;var det:detalle_nac);
	begin
		if not(eof(file_nac)) then
			read(file_nac,det)
		else
			det.nrPa:= valor_alto;
	end;
	procedure leer_fal(var file_fal:f_fallecimiento;var det:detalle_fall);
	begin
		if not(eof(file_fal)) then
			read(file_fal,det)
		else
			det.nrPa:= valor_alto;
	end;
	procedure minimo_nac(var a_file:a_nac;var a_reg:ta_reg_nac;var min:detalle_nac);
	var
		i,pos:integer;
	begin
		min.nrPa:=valor_alto;
		for i:=1 to cantArch do
		begin
			if (a_reg[i].nrPa < min.NrPa) then
			begin
				min:=a_reg[i];
				pos:=i;
			end;
		end;
		if min.nrPa <> valor_alto then
			leer_nac(a_file[pos],a_reg[pos]);
	end;
	procedure minimo_fal(var a_file:a_fal;var a_reg:ta_reg_fal;var min:detalle_fall);
	var
		i,pos:integer;
	begin
		min.nrPa:=valor_alto;
		for i:=1 to cantArch do
		begin
			if (a_reg[i].nrPa < min.NrPa) then
			begin
				min:=a_reg[i];
				pos:=i;
			end;
		end;
		if min.nrPa <> valor_alto then
			leer_fal(a_file[pos],a_reg[pos])
	end;
	procedure armarMinNac(min_nac:detalle_nac;var m:maestro);
	var
		m_default:persona;
		p_default:persona;
		str_default: String[20];
	begin
		
		str_default:=IntToStr(valorDefault);
		with m_default do
		begin
			nom:=str_default;
			ape:=str_default;
			dni:=valorDefault;
		end;
		with p_default do
		begin
			nom:=str_default;
			ape:=str_default;
			dni:=valorDefault;
		end;
		with min_nac do
		begin
			m.nrPa:=nrPa;
			m.nom:=nom;
			m.ape:=ape;
			m.dire:=dire;
			m.matMed_n:=matrMed;
			m.vive:=true;
			//Valores Default
			m.madre:=m_default;
			m.padre:=p_default;
			m.matMed_f:=valorDefault;
			m.fecha:=valorDefault;
			m.hora:=valorDefault;
			m.lugar:=dire;
		end;
	end;
	procedure juntarMin(d_nac:detalle_nac;d_fal:detalle_fall;var r_mae:maestro);
	begin
		with d_nac do
		begin
			r_mae.nrPa:=nrPa;
			r_mae.nom:=nom;
			r_mae.ape:=ape;
			r_mae.dire:=dire;
			r_mae.matMed_n:=matrMed;
			r_mae.madre:=madre;
			r_mae.padre:=padre;
			r_mae.vive:=false;
		end;
		with d_fal do
		begin	
			r_mae.matMed_f:=matMed;
			r_mae.fecha:=fecha;
			r_mae.hora:=hora;
			r_mae.lugar:=lugar;
		end;
	end;
var
	i:integer;
	min_nac:detalle_nac;
	min_fal:detalle_fall;
	a_reg_nac:ta_reg_nac;
	a_reg_fal:ta_reg_fal;
	minimo_maestro:maestro;
begin
	for i:=1 to cantArch do
	begin
		reset(a_file_nacimiento[i]);
		reset(a_file_fallecimiento[i]);
		leer_nac(a_file_nacimiento[i],a_reg_nac[i]);
		leer_fal(a_file_fallecimiento[i],a_reg_fal[i]);
	end;
	rewrite(m);
	minimo_nac(a_file_nacimiento,a_reg_nac,min_nac);
	minimo_fal(a_file_fallecimiento,a_reg_fal,min_fal);
	while (min_nac.nrPa <> valor_alto) do
	begin
		while (min_nac.nrPa < min_fal.nrPa) and (min_nac.nrPa <> valor_alto) do
		begin
			armarMinNac(min_nac,minimo_maestro);
			write(m,minimo_maestro);//Agregar Maestro
			minimo_nac(a_file_nacimiento,a_reg_nac,min_nac);
		end;
		if (min_nac.nrPa <> valor_alto) and (min_nac.nrPA = min_fal.nrPa) then
		begin
			juntarMin(min_nac,min_fal,minimo_maestro);
			write(m,minimo_maestro);//Agregar Maestro
			minimo_nac(a_file_nacimiento,a_reg_nac,min_nac);
			minimo_fal(a_file_fallecimiento,a_reg_fal,min_fal);
		end;
	end;
	
	for i:=1 to cantArch do
	begin
		close(a_file_nacimiento[i]);
		close(a_file_fallecimiento[i]);
	end;
	close(m);
	writeln('Archivo maestro generado correctamente.');
	readln();
end;
procedure crearTxt(var m:arch_maestro;var txt:Text);
var
	r_m:maestro;
	linea:String;
begin
	reset(m);
	assign(txt,'MaestroTexto.txt');
	rewrite(txt);
	read(m,r_m);
	while not(eof(m)) do
	begin
		linea:= '-Numero Partida: '+ IntToStr(r_m.nrPa) + '.Nombre: '+r_m.nom + '.Apellido: '+r_m.ape; 
		writeln(txt,linea);
		linea:= 'Direccion: '+ r_m.dire.calle + '.MatriculaMedicoNacimiento: '+IntToStr(r_m.matMed_n) + '.Nombre Madre: '+r_m.madre.nom + '.Nombre Padre: '+r_m.padre.nom + '.Vive: '+BoolToStr(r_m.vive) + '.MatMed_f: '+IntToStr(r_m.matMed_f) + '.Lugar: ' + r_m.lugar.calle;
		writeln(txt,linea);
		read(m,r_m);
	end;
	close(m);
	close(txt);
	writeln('Archivo de texto generado correctamente.');
	readln();
end;
var
	a_file_nacimiento:a_nac;
	a_file_fallecimiento:a_fal;
	i:integer;
	m:arch_maestro;
	txt:Text;
begin
	for i:=1 to cantArch do
	begin
		assign(a_file_nacimiento[i],'punto5_nacimiento_' + IntToStr(i) + '.dat');
		assign(a_file_fallecimiento[i],'punto5_fallecimiento_' + IntToStr(i) + '.dat')
	end;
	assign(m,'maestro.dat');
	crearMaestro(a_file_nacimiento,a_file_fallecimiento,m);
	crearTxt(m,txt);
end.
