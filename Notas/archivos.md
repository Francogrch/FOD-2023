# Archivos
## Creacion de archivos

Es necesario la creacion de un tipo de dato el cual va a definir la variable de tipo file of, con el tipo de dato que almacene el archivo.

El *assign* sirve para generar la relacion dentro del programa del nombre del archivo y la variable. Recibe una variable de tipo file of, y un texto, que sera el nombre del archivo.

Con el *rewrite* crea el archivo y lo abre, en el caso que exista lo pisa. Recibe la variable de tipo file of .

El *write* sirve para escribir en el archivo una linea. Escribe y el puntero del archivo automaticamente va a la proxima linea. 

Y por ultimo hay que cerrar el archivo con *close*. Recibe la variable de tipo archivo.

    type
        type_name = file of [type]
    var
        file: type_name
        line: [type]
    begin
        assign(file, 'name_file')
        rewrite(file)
        write(arch_num, line);
        close(file)
    end.

## Consulta

El *reset* abre el archivo. Recibe la variable de tipo archivo.

El *eof* es una funcion que retorna True o False si es o no el End Of File del archivo. Recibe la variable de tipo archivo.

El *read* sirve para leer una linea del archivo. Recibe la variable de tipo archivo y una variable donde almacenara la linea.


    type
        type_name = file of [type]
    var
        file: type_name
        line: [type]
    begin
        assign(file, 'name_file')
        reset(file)
        while not(eof(file)) do
            read(file, line)
            writeln(line)
        close(file)
    end.


## Mantenimiento
### Archivos secuenciales

### Actualizacion maestro con 1 detalle

#### Precondiciones:
- Existe un archivo maestro.
- Existe un único archivo detalle que modifica al maestro.
- Cada registro del detalle modifica a un solo registro del maestro que seguro existe. 
- No todos los registros del maestro son necesariamente modificados.
- Cada elemento del maestro que se modifica, es alterado por un solo un elemento del archivo detalle. 
- Ambos archivos están ordenados por igual criterio.


        type 
        producto = record
                    cod: string[4];                   
            descripcion: string[30];     
            pu: real;  {precio unitario}                  
            stock: integer;               
                end;
                venta_prod = record
                    cod: string[4];               
                    cant_vendida: integer;   
                end;
        var
            mae: maestro;
            det: detalle;
            regm: producto;
            regd: venta_prod;
                
        begin
            assign(mae, 'maestro.dat');
            assign(det, 'detalle.dat');
            reset(mae);
            reset(det);
            //Loop archivo detalle
            while not(EOF(det)) do 
            begin 
                read(mae, regm); // Lectura archivo maestro
                read(det, regd); // Lectura archivo detalle
                //Se busca en el maestro el producto del detalle
                while (regm.cod <> regd.cod) do
                        read(mae, regm);
                        regm.stock := regm.stock-regd.cant_vendida; // Se modifica el stock del producto con la cantidad vendida de ese producto
                        seek(mae, filepos(mae)-1); // Se reubica el puntero en el maestro
                        write(mae, regm); // Se actualiza el maestro

            end; // Fin while archivo detalle
            close(det);
            close(mae);  
        end.

#### Precondiciones:
- Existe un archivo maestro.
- Existe un único archivo detalle que modifica al maestro.
- Cada registro del detalle modifica a un registro del maestro que seguro existe.
- No todos los registros del maestro son necesariamente modificados. 
- Cada elemento del archivo maestro puede no ser modificado, o ser modificado por uno o más elementos del detalle.
- Ambos archivos están ordenados por igual criterio.

#### Algoritmo:

        Asigna y abre los archivos
        Mientras no sea el fin del archivo maestro:
            Lee maestro
            Lee detalle
            Se busca en el maestro el registro del detalle con un while
                Se guarda el cod actual para luego compararlo
                Con otro while se suman los detalles iguales
                    se lee otro detalle
            Se actualiza en el maestro
                Se reubica al mestro en el anterior  
                Se guarda en el maestro  

Ejemplo:

        type 
            producto = record
                        cod: string[4];                   
                descripcion: string[30];     
                pu: real;                    
                stock: integer;               
                    end;
                    venta_prod = record
                        cod: string[4];               
                        cant_vendida: integer;   
                    end;
                    detalle = file of venta_prod;     
                    maestro = file of producto;
        var
            mae:  maestro;
            det:  detalle;
            regm: producto;
            regd: venta_prod;
            cod_actual: string[4];
            tot_vendido: integer;
        begin  {Inicio del programa}
            assign(mae, 'maestro');
            assign(det, 'detalle');
            reset(mae);
            reset(det);

            {Loop archivo detalle}
            while not(EOF(det)) do 
            begin 
                read(mae, regm); // Lectura archivo maestro
                read(det, regd); // Lectura archivo detalle
                {Se busca en el maestro el producto del detalle}	
                while (regm.cod <> regd.cod) do
                        read(mae, regm);
                {Se totaliza la cantidad vendida del detalle}
                        cod_actual := regd.cod;
                        tot_vendido := 0; 		
                    while (regd.cod = cod_actual) do 
                    begin
                        tot_vendido:=tot_vendido+regd.cant_vendida; 
                        read(det, regd);
                    end;
                regm.stock := regm.stock – tot_vendido; // Se actualiza el stock del producto con la cantidad vendida del mismo
                seek(mae, filepos(mae)-1); // se reubica el puntero en el maestro
                write(mae, regm); // se actualiza el maestro
            end;

            close(det);
            close(mae);
        end.

### Merge

Proceso mediante el cual se genera un nuevo archivo a partir de otros archivos existentes.
### Merge - Productos unicos

#### Algoritmo:
    Constante valorAlto.
    Se necesitan dos procedimientos leer y minimo
    -leer(archivo, salida):
        si el archivo no esta en EOF retorna el siguiente valor en salida, si no retorna valorAlto en salida
    -minimo(cantArch*,cantVarInd*,min):
        se calcula el minimo comparando las variables individuales con ifs 
            se utiliza el leer con el archivo del minimo, para que el puntero del archivo continue
    Pasos:

        Se asignan los archivos
        Se abren los archivos
        Se leen todos los detalles
        Se calcula el minimo
        Mientras el minimo sea diferente a valorAlto
            Se escribe en el maestro
            Se calcula el minimo
        Se cierran los archivos


Ejemplo:


    program ejemplo;

    const valor_alto = 999999;

    type
        producto = record
            codigo: integer;
            descripcion: string[30];
            pu: real;
            cant: integer;
        end;
        arc_productos = file of producto;

    var
        det1, det2, det3, mae: arc_productos;
        min, regd1, regd2, regd3: producto;
    procedure leer (var archivo: arc_productos;
        var dato: producto);
        begin
        if (not(EOF(archivo))) then
            read (archivo, dato)
        else
            dato.codigo := valor_alto;
        end;
    procedure minimo(var det1, det2, det3: arc_productos; var r1, r2, r3, min: producto);
    begin
        if (r1.codigo<=r2.codigo) and (r1.codigo<=r3.codigo)then 
        begin
            min := r1;
            leer(det1, r1);
        end
        else
        begin
            if (r2.cod <= r3.cod) then 
            begin
                min := r2;
                leer(det2, r2);
            end
            else 
            begin
                min := r3;
                leer(det3, r3)
            end;
        end;
    end;

    {programa principal}
    begin
        assign (mae, 'maestro');
        assign (det1, 'detalle1');
        assign (det2, 'detalle2');
        assign (det3, 'detalle3');

        rewrite (mae);
        reset (det1);
        reset (det2);
        reset (det3);

        leer (det1, regd1);
        leer (det2, regd2);
        leer (det3, regd3);

        minimo (det1, det2, det3,
        regd1, regd2, regd3, min);

        {se procesan todos los registros de los
        archivos detalle}
        while (min.codigo <> valoralto) do 
        begin
            write (mae, min);
            minimo (det1, det2, det3,
            regd1, regd2, regd3, min);
        end;
        
        close (det1);
        close (det2);
        close (det3);
        close (mae);
    end.

### Merge - Productos repetidos

    while (min.codigo <> valoralto) do begin
        aux:= min;
        total := 0;
        while (min.codigo = aux.codigo) do begin
            total := total + min.cant;
            minimo (det1, det2, det3,
            regd1, regd2, regd3, min);
        end;
        aux.cant := total;
        write (mae, aux);
    end;


### Corte de control
Proceso mediante el cual la información de un archivo es presentada en forma organizada de acuerdo a la estructura que posee el archivo.

*Ejemplo*

Se almacena en un archivo la información de ventas de una cadena de electrodomésticos. Dichas ventas han sido efectuadas por los vendedores de cada sucursal de cada ciudad de cada provincia del país.
Es necesario informar al gerente de ventas de la empresa, el total vendido en cada sucursal, ciudad y provincia, así como el total final.
#### Precondiciones:

- El archivo se encuentra ordenado por provincia, ciudad y sucursal

- En diferentes provincias pueden existir ciudades con el mismo nombre, y en diferentes ciudades pueden existir sucursales con igual denominación. 

#### Algoritmo:


    Pasos:
        Se asigna el archivo
        Se abre el archivo
        Se lee utilizando el procedimiento leer
        Operaciones sobre el primer nivel de orden (contadores)
        Mientras registro sea diferente a valor alto
            Se guarda el actual
            Operaciones sobre el segundo nivel de orden
            Mientras registro sea igual que el actual
                Se guarda el actual
                Operaciones sobre el tercer nivel de orden
                Mientras registro sea igual que el actual2 y registro sea igual que actual3
                    leer siguiente (procedimiento)
                Se opera sobre los resultados del tercer nivel
            Se opera con los resultados del segundo nivel
        Se opera con los resultados finales
        Se cierra el archivo






Ejemplo

        program ejemplo;
            const valor_alto = ‘ZZZ’;
            type
                nombre = string[30];
                reg_venta = record
                    vendedor: integer;
                    monto: real;
                    sucursal: nombre;
                    ciudad: nombre;
                    provincia: nombre;		
                end;

            ventas = file of reg_venta;
        var
            reg: reg_venta;
            archivo: ventas;
            total, totProv, totCiudad, totSuc: integer;
            prov, ciudad, sucursal: nombre;   

        procedure leer(var archivo: ventas; 
                                var dato: reg_venta);
        begin
            if (not(EOF(archivo))) then 
                read (archivo, dato)
            else 
                dato.provincia := valor_alto;
        end;


        begin
            assign(archivo, 'archivo_ventas');
            reset(archivo);

            leer(archivo, reg);
            total := 0;
            while (reg.provincia <> valor_alto)do 
            begin
                writeln(‘Provincia:’, reg.provincia); 	
                prov := reg.provincia;
                totProv := 0;
                while (prov = reg.provincia) do 
                begin
                    writeln(‘Ciudad:’, reg.ciudad); 	
                    ciudad := reg.ciudad;
                    totCiudad := 0;
                    while (prov = reg.provincia) and (ciudad = reg.ciudad) do 
                    begin
                        writeln(‘Sucursal:’,reg.sucursal);
                        sucursal := reg.sucursal;
                        totSuc := 0;
                        while (prov = reg.provincia) and (ciudad = reg.ciudad) and (sucursal = reg.sucursal) do begin
                            write(“Vendedor:”, reg.vendedor);
                            writeln(reg.monto);
                            totSuc := totSuc + reg.monto;
                            leer(archivo, reg);
                        end;
                        writeln(“Total Sucursal”,totSuc);
                        totCiudad := totCiudad + totSuc;
                    end;{while (prov = reg.provincia) and (ciudad = reg.ciudad)}
                    writeln(“Total Ciudad”, totCiudad);
                    totProv := totProv + totCiudad;
                end;{while(prov = reg.provincia)}
                writeln(“Total Provincia”, totProv);
                total := total + totProv,
            end;{while(reg.provincia <> valor_alto)}
            writeln(“Total Empresa”, total);
            close(archivo);	
        end.