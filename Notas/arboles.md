# Arboles

## Arboles B

### Propiedades
- Cada nodo del árbol puede contener como máximo M descendientes directos (hijos) y M-1 elementos.
- La raíz no posee descendientes directos o tiene al menos dos.
- Un nodo con X descendientes directos contiene X-1 elementos.
- Todos los nodos (salvo la raíz) tienen como mínimo [M/2] – 1 elementos y como máximo M-1 elementos.
- Todos los nodos terminales se encuentran al mismo nivel.

### Overflow

- Se crea un nuevo nodo.
- La primera mitad de las claves se mantiene en el nodo con overflow.
- La segunda mitad de las claves se traslada al nuevo nodo.
- La menor de las claves de la segunda mitad se promociona al nodo padre.

### Bajas

- Si la clave a eliminar no está en una hoja, se debe reemplazar con la menor clave del subárbol derecho.
- Si el nodo hoja contiene por lo menos el mínimo número de claves, luego de la eliminación, no se requiere ninguna acción adicional.
- En caso contrario, se debe tratar el underflow
- Primero se intenta redistribuir con un hermano adyacente. La redistribución es un proceso mediante el cual se trata de dejar cada nodo lo más equitativamente cargado posible. 
- Si la redistribución no es posible, entonces se debe fusionar con el hermano adyacente.

### Políticas para la resolución de underflow:
*Política izquierda*: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible, se fusiona con hermano adyacente izquierdo.
*Política derecha*: se intenta redistribuir con el hermano adyacente derecho, si no es posible, se fusiona con hermano adyacente derecho.
*Política izquierda o derecha*: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible,  se intenta con el hermano adyacente derecho, si tampoco es posible, se fusiona con hermano adyacente izquierdo.
*Política derecha o izquierda*: se intenta redistribuir con el hermano adyacente derecho, si no es posible,  se intenta con el hermano adyacente izquierdo, si tampoco es posible, se fusiona con hermano adyacente derecho.

*Casos especiales*: en cualquier política si se tratase de un nodo hoja de un extremo del árbol debe intentarse redistribuir con el hermano adyacente que el mismo posea.
Aclaración: 
- En caso de underflow lo primero que se intenta SIEMPRE es redistribuir si el hermano adyacente se encuentra en condiciones de hacer la redistribución y no se produce underflow en el.

## Arboles B+

- Constituyen una mejora sobre los árboles B, pues conservan la propiedad de acceso aleatorio rápido y permiten además un recorrido secuencial rápido. 
- *Conjunto índice*: Proporciona acceso indizado a los registros. Todas las claves se encuentran en las hojas, duplicándose en la raíz y nodos interiores aquellas que resulten necesarias para definir los caminos de búsqueda.
- *Conjunto secuencia*: Contiene todos los registros del archivo. Las hojas se vinculan para facilitar el recorrido secuencial rápido. Cuando se lee en orden lógico, lista todos los registros por el orden de la clave.
  
### Busqueda
- La operación de búsqueda en árboles B+ es similar a la operación de búsqueda en árboles B. El proceso es simple, ya que todas las claves se encuentran en las hojas, deberá continuarse con la búsqueda hasta el último nivel del árbol.

 Insersion
El nodo afectado se divide en 2, distribuyéndose las claves lo más equitativamente posible. Una copia de la clave del medio o de la menor de las claves mayores (casos de overflow con cantidad pares de elementos) se promociona al nodo padre. El nodo con overflow se divide a la mitad. 

La copia de la clave sólo se realiza en un overflow ocurrido a nivel de hoja. 
Caso contrario -> igual tratamiento que en árboles B.

### Bajas
La operación de eliminación en árboles B+ es más simple que en árboles B. Esto ocurre porque las claves a eliminar siempre se encuentran en las páginas hojas. En general deben distinguirse los siguientes casos, dado un árbol B+ de orden M:

Si al eliminar una clave, la cantidad de claves que queda es mayor o igual que [M/2]-1, entonces termina la operación. Las claves de los nodos raíz o internos no se modifican por más que sean una copia de la clave eliminada en las hojas. 

### Underflow

- Si al eliminar una clave, la cantidad de llaves es menor a [M/2]-1, entonces debe realizarse una redistribución de claves, tanto en el índice como en las páginas hojas.
- Si la redistribución no es posible, entonces debe realizarse una fusión entre los nodos.

### Políticas para la resolución de underflow

*Política izquierda*: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible, se fusiona con hermano adyacente izquierdo.
*Política derecha*: se intenta redistribuir con el hermano adyacente derecho, si no es posible, se fusiona con hermano adyacente derecho.
*Política izquierda o derecha*: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible,  se intenta con el hermano adyacente derecho, si tampoco es posible, se fusiona con hermano adyacente izquierdo.
*Política derecha o izquierda*: se intenta redistribuir con el hermano adyacente derecho, si no es posible,  se intenta con el hermano adyacente izquierdo, si tampoco es posible, se fusiona con hermano adyacente derecho.



