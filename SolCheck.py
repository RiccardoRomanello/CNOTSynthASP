import numpy as np
import qiskit

def apply_xor(M, M1, i, j):
    M[i, :] = np.logical_xor(M1[i, :], M1[j, :])
    return M

# xor_node(1,2,1) xor_node(5,2,1) xor_node(6,4,1) xor_node(7,8,1) 
# xor_node(1,7,2) xor_node(2,1,2) xor_node(3,6,2) xor_node(4,2,2) xor_node(5,6,2) xor_node(6,3,2) xor_node(7,5,2) 
# xor_node(1,4,3) xor_node(2,7,3) xor_node(3,2,3) xor_node(5,4,3) xor_node(8,7,3)

input = [[(1, 2), (5, 2), (6, 4), (7, 8)], [(1, 7), (2, 1), (3, 6), (4, 2), (5, 6), (6, 3), (7, 5)], [(1, 4), (2, 7), (3, 2), (5, 4), (8, 7)]]

M = np.identity(8)

for step in input:
    M1 = M.copy()
    for i, j in step: 
        M = apply_xor(M, M1, i - 1, j - 1)


# disegno pure il circuito che non si sa mai



print(M)
