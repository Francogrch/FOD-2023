## Hashing
- Tecninca para generar una direccion base unica para una clave dada
- Acceso rapido por clave (mas rapido que arboles)

### Tipos de dispersion
- Direccionamiento estatico : espacio para dispersar registros
- Direccionamiento dinamico: espacio para dispersar registros
  
### Parametros:
- Cuantos registros entran en la direccion de datos
- Densidad de empaquetamiento (que proporcion del espacio esta siendo ocupada por registros)
- Metodo de tratamiento de desborde 

### Conceptos
- Funcion de dispersion: caja negra que a partir de una clave genera la direccion fisica done debe almacenarse el registro
- Colision: Situacion aen la que un registro es asignado a una direccion que ya posee uno o mas registros
- Desborde: situacion en la cual una clave carece de espacio para guardarse en la direccion asignada
- Densidad de empaquetamiiento: relacion entre el espacio disponible y la cantidad de registros que se pueden almacenar. DE: (Cantidad de Registros insertados / Cantidad total de espacio)
- Clave sinonima: Es cuando una clave tiene una misma direccion que otra
- Clave instrusa : Es cuando una clave se guarda en una direccion que no es la que le genero la funcion de hash
- 


### Metodos para desbrodes
- Saturacion progresiva
- Saturacion progresiva encadenada
- Saturacion progresiva encadenada con arera de desborde separada
- Dispersion doble

### *Saturacion progresiva*
Al momento que hay una saturacion, va a buscar secuencialmente a partir de la direccion dada por la funcion hash una cubeta que tenga espacio.
Nota: El nodo por debajo de la direccion que tenga espacio

### Bajas (Marca de Borrado)
Sirven para que la busqueda de una clave no termine antes
- Si la cubeta no esta llena, no se deja marca de borrado y se borra la clave sin problema
- Si la cubeta donde esta la clave a borrar esta llena, hay que leer la cubeta que siguente y revisar si no esta vacia 

### *Saturacion progresiva encadenada*
Cada nodo aparte del registro se usa un enlace para las claves sinonimas, usando estos enlaces como una lista invertida
- Al momento de la saturacion se busca una direccion secuencialmente que este vacia. Y se guarda en el enlace de la direccion base, direccion que se acaba de encontrar (direccion que se guardo realmente la clave) 
- Al momento de que halla una saturacion y la clave almacenada en la direccion donde guardare una clave, es un instruso, se reacomoda el intruso (se busca secuenciamente un espacio y se actualiza el enlace en su direccion original (se aplica la funcion y se toma el indice que esta guardado en la direccion de la funcion hash))
### Bajas
Se busca haciendo funcion hash, y recorriendo la lista
- Se encuentra al cominezo de la lista
  Copias el nodo entero del enlace y lo escribis en la direccion de la clave a borrar
  La clave deja de ser un intruso
- Se encuntra al medio de la lista
    Actualizas el enlace de la clave anterior con el enlace de la clave a borrar
### *Saturacion progresiva encadenada con area de desborde separada*
Se utiliza otro archivo para las claves sinonimas
Al momento de desborde:
- Se guarda la clave en el area de desborde con el enlace del archivo principal
- Se actualiza enlace de archivo principal en direccion que retorna funcion de hash
### Bajas
Se aplica funcion, se recorren los enlaces, se encuntra el elemento y se actualiza los enlaces

### *Dispersion doble*
- No utiliza enlaces
- Se utiliza una segunda funcion de desplazamiento en caso que la primera de la misma direccion
Al momento que hay desborde se aplica una funcion de desplazamiento, y se lleva a ese lugar y se marca como intruso
### Bajas
Se aplica la funcion hash, si no esta se aplica funcion de desplazamiento hasta que se encuntra o hasta que llega a un nodo vacio
Siempre que se borra se hace una marca de borrado  
