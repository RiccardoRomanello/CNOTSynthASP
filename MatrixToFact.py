n = 8

with open("input.txt", 'r') as file:
    for i, line in enumerate(file.readlines()):
        line = line.split(", ")
        for j, element in enumerate(line):
            print("g(" + str(i+1) + ", " + str(j+1) + ", " + element.strip() + "). ", end='')

        print()
    file.close()
         
    