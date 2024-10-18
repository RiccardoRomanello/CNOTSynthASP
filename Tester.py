# per ogni input test, devo provare i layer finché non trovo il primo che risolve e tenermi il tempo 
import os

basic_path = "With Topology"
asp_source = "cnot_synthesis_dag_graph_constr.lp"

ns = [4, 5, 6, 7, 8]
test = 10

for n in ns:
    for t in range(test):
        file_name = basic_path + '/input/input_' + str(n) + '_' + str(t) + '.lp'
        file_name_out = basic_path + '/output/output_' + str(n) + '_' + str(t) + '.lp'
        file_name_result = basic_path + '/results/result_' + str(n) + '_' + str(t) + '.lp'
        for l in range(1, 30):
            found = False
            
            with open(file_name, 'r') as f:
                file_content = f.readlines()

            file_content[-1] = '#const l = ' + str(l) + '.'

            with open(file_name, 'w') as f:
                f.writelines(file_content)

            os.system("clingo --parallel-mode 8,compete " + asp_source + " \"" + file_name + "\" > \"" + file_name_out + "\"")
            with open(file_name_out, 'r') as f:
                content = f.readlines()
                # if not ("UNSATISFIABLE" in content[3]):
                if not ("UNSATISFIABLE" in content[4]) and not ("UNSATISFIABLE" in content[3]):
                    result = content[-5:]
                    optimum = result[0]
                    time = result[-3]
                    found = True
                else:
                    print('Input with size ' + str(n) + ' test case ' + str(t) + ' unsatisfiable with ' + str(l) + ' layers')

            if found: 
                with open(file_name_result, 'w') as f:
                    print(str(optimum) + '\n' + str(time) + '\n' + 'l = ' + str(l), file = f)
                
                found = False
                break

        