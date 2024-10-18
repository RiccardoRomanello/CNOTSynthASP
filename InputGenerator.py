import numpy as np
import random

# generate n different binary numbers from 1 to 2**m - 1
def generate_different(n, m):
    possibilities = np.array((range(1, 2**m-1))) # tutti i numeri generabili
    np.random.shuffle(possibilities) # random shuffle delle possiblità
    matrix = possibilities[:n] # prendo i primi n numeri che saranno quelli buoni
    matrix = [bin(k)[2:].zfill(m) for k in matrix] # prendo ogni numero, lo converto in binario e lo fillo
    
    return matrix

def matrix_to_fact(M, s, file_name):
    with open(file_name, 'a') as f:
        for i, el in enumerate(M):
            for j in range(len(el)):
                print(s + "(" + str(i+1) + ", " + str(j+1) + ", " + el[j] + "). ", end='', file=f)
            print(file=f)
        print(file=f)

ns = [4, 5, 6, 7, 8]

tests = 10 


for n in ns:
    for i in range(tests):
        test_name = 'input/input_' + str(n) + '_' + str(i) + '.lp'
        
        k = random.randint(1, n)
        G = generate_different(n, n)
        F = generate_different(k, n)

        matrix_to_fact(G, 'g', test_name)
        matrix_to_fact(F, 'f', test_name)
        
        with open(test_name, 'a') as f:
            print('#const n = ' + str(n) + '.', file=f)
            print('#const k = ' + str(k) + '.', file=f)
            print('#const l = 1.', file=f)



