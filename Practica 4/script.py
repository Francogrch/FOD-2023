import os
"""AI is creating summary for 
"""

num = input('Ingrese el numero de practica: ')
header = f"Arbol {input('Ingrese el tipo de arbol: ')} - Orden: {input('Ingrese el orden: ')}- Underflow: {input('Politica de Overflow: ')}"
#STRING = "+80, +50, +70, +120, +23, +52, +59, +65, +30, +40, +45, +31, +34, +38, +60, +63, +64, -23,-30, -31, -40, -45, -38."
string = input('Operaciones (separada por coma): ')
NAME_FILE = "punto" + str(num) + ".txt"
PATH = str(os.path.join(os.getcwd(), NAME_FILE))
try:
    with open(PATH, "x",encoding="UTF-8") as fil:
        l_str = string.replace(".","").replace(" ","").split(',')
        l_str = map(lambda x: "("+x+")",l_str)
        fil.write(header + '\n')
        fil.write("Operaciones"+ '\n')
        fil.write(string + '\n')
        for elem in l_str:
            fil.write('-'*50+ '\n')
            fil.write(elem+ '\n')
        print('Archivo creado con exito')
except FileExistsError:
    print('ERROR, El archivo ya existe')
    
