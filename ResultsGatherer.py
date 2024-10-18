ns = [4, 5, 6]

tests = 10 

for n in ns:
    sum = 0.0
    for t in range(tests):
        file_name = 'results/result_' + str(n) + '_' + str(t) + '.lp'
        with open(file_name, 'r') as f:
            content = f.readlines()
            time = content[2].split('(')[0].split(':')[1][:-2].strip()
            sum = sum + float(time)
    
    res = sum/10
    print('n: ' + str(n) + ', avg time: ' + str(res))