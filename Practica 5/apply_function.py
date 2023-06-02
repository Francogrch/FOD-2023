def funcion1(num):
    return num % 6


def funcion2(num):
    return num % 5 + 1


while True:
    num = int(input('Numero: '))
    print(f"f1({num}) = {funcion1(num)}\nf2({num}) = {funcion2(num)}")
