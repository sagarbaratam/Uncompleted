import sys 
count = 0

var = sys.stdin.readlines()
#print (var)
#var1 = [ line for line in var.split()]

for i in var:
    if i.isalpha()==False:
        if i.startswith(('4','5','6')) == True:
            print (i,"Valid")
        else:
            print(i ,"Invalid")

    else:
        print(i,"Invalid")
        


import sys
import itertools 
count = 0

var = sys.stdin.readlines()


for i in var:
    if i.isalpha()==False:
        if i.startswith(('4','5','6')) == True:
            for j in i:
                if i.isdigit()==True:
                    count+=1
                    if count==16:
                        print(i, "Valid")
                    else:
                        print("Invalid")
                else:
                    print("Invalid")
        else:
            print("Invalid")

    else:
        print("Invalid")






import sys
import itertools 
count = 0

var1 = sys.stdin.readlines()

var2 = map(str.rstrip,var1)

print(var1)
var = []
t = [len(var2[j]) for j in range(len(var2)) ]
dict = {var2[i]:t[i] for i in range(len(var2))}
for i in dict:
    if dict[i]>=16:
        var.append(i)


s = [i  for i in var for j in i if (j.isspace()==True)]
t = [var[j] for j in range(len(var)) if len(var[j])==16 or 19]
 


    
for i in var:
    if i.isalpha()==False and i.startswith(('4','5','6')) == True and i not in s and i in t:
       print ("Valid")
    else:
       print("Invalid")
                
    


