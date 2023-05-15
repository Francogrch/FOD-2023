#Practica 4
---------------
##Respuestas Escritas
1. Un Arbol B de orden M tiene una estructura de un arbol multicamino donde:
   - Cada nodo tiene como maximo M hijos y M-1 elementos
   - La raiz no tiene descendientes directos o tiene al menos dos
   - In nodo con X descendietes directos tiene X-1 elementos
   - Todos los nodos tiene como minimo (M/2)-1 elementos y como maximo M-1 elementos (menos la raiz)
   - Todos los nodos terminales se encuntran al mismo nivel
La clave poara identificacion para organizar los elementos puede ser, el DNI o el Legajo, ya que contiene valores unicos e irrepetibles, mientras que en año de ingreso se puede repetir. La eleccion entre el DNI o el Legajo, va a depender del uso que se le de.
2. Un Arbol B+ contiene las propiedades de un arbol B de acceso aleatorio rapido y permiten ademas un recorrido secuancial rapido.
Ademas de que cada nodo esta relacionado con sus nodos hijos, tambien estaran relacionados con los nodos adyacentes a su mismo nivel (recorrido secuancial).
La gran diferencia con los Arboles B es que todas las clves se encuntran en las hojas(ultimo nivel), y en los nodos padres hay una copia.
a) Siempre y cuando el arbol este ordenado por DNI
Algoritmo:
    1. Busca la clave en en nodo y si no es hija continuo (raiz)
    2. Toma el puntero anterior a la clave mayor en comparacion a la buscadada
    3. Si el puntero es nulo no esta la clave
    4. En el caso que tenga mas elementos vuelve al paso 1
   
    b) Debido a que el archivo no esta ordenado por nombres, se puede hacer una busqueda secuencial de todas las hojas, ya que los Arboles B+ tiene esa propiedad.

    c) La ventaja es que puedo hacer una busqueda secuencial, mientras que en los arboles B tendira que recorrer todo el arbol en el caso que tenga que buscar algun elemento por otro criterio que no sea por el cual este ordenado el arbol.
3. a) El procedimiento PosicionarYLeerNodo() lee el arbol que se le pasa por valor (NRR), retorna el nodo que se le pasa por referencia, A que es el archivo, que se pasa por referencia tambien.
   b) El procedimiento claveEncontrada() lee los elementos del nodo que se le pasa por valor, toma la clave, pasada por valor, y retorna la posicion en pos, pasada por referencia, y un booleano clave_encontrada (por referencia), en el caso que se halla encontrado en ese nodo. El A es el archivo, pasado por referencia tambien.
   c) El error que hay es que el en if (nodo == null) va a dar error, ya que no esta declarado, y en el caso que lo este siempre sera null, ya que en ningun momento se modifica, el codgio quedaria asi:

            procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado,A)
            var 
                clave_encontrada: boolean;
                nodo: array;
            begin
                posicionarYLeerNodo(A, nodo, NRR);
                if (nodo = null) then
                    resultado := false; 
                else begin
                    claveEncontrada(A, nodo, clave, pos, clave_encontrada);
                    if (clave_encontrada) then begin
                        NRR_encontrado := NRR; 
                        pos_encontrada := pos; 
                        resultado := true;
                    end
                end
                else
                    buscar(nodo.hijo[pos], clave, NRR_encontrado, pos_encontrada,
                    resultado,A)
            end;

4. Overflow: esto ocurre cuando un nodo esta lleno y se quiere agrear un valor
   Underflow: esto ocurre cuando se quiere eliminar un valor del nodo pero al hacerlo el nodo queda con menos del minimo que puede almacenar.
   Redistribucion: esto ocurrre cuando hay underflow y es necesario tomar los valores de algun nodo hermano y agregarlos al nodo actual para que no ocurrra el underflow
   Fusion o concatenacion: Ocurre en underflow ,en el caso que el nodo hermano tenga la cantidad minima de elementos, entonces se pueden fusionar los valores del nodo actual con los valores del nodo hermano.
