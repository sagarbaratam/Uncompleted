
x = [int(x) for x in input("Enter multiple value: ").split()]
print (x)
r = int(input("Enter the reference value: "))
list = []
for i in x:
    if i>r:
        list.append(i)

print (list)
        

    



