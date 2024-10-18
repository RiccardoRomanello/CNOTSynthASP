topology = "s(0, 1). s(1, 0). s(1, 2). s(1, 4). s(2, 1). s(2, 3). s(3, 2). s(3, 7). s(4, 1). s(4, 5). s(4, 6). s(5, 4). s(6, 4). s(6, 7). s(6, 8). s(7, 3). s(7, 6).s(8, 6).\n\n"

ns = [4, 5, 6, 7, 8]

tests = 10

for n in ns:
    for t in range(tests):
        file_name = 'With Topology/input/input_' + str(n) + '_' + str(t) + '.lp'
        with open(file_name, 'r') as f:
            content = f.readlines()
            f.close()
        
        new_content = content[:-3] + [topology] + content[-3:]

        with open(file_name, 'w') as f:
            f.writelines(new_content)
            f.close()
    
