import random
userinput = -1
solution = random.randint(0,100)
print(solution)
print(type(solution))
userinput = int(input("Donnez un nombre entre 1 et 100 : "))
print(userinput)
print(type(userinput))
if userinput < solution:
    if userinput < solution and solution-userinput<=5:
        print("sol est plus grand que votre nbre mais tres proche")
    elif userinput < solution and solution-userinput>6 and solution-userinput<10:
         print("sol est plus grand que votre nbre mais proche")
    else :
        print("sol est plus grand que votre nbre")
elif userinput > solution:
        if userinput > solution and userinput-solution<=5:
            print("sol est plus petit que votre nbre mais tres proche")
        elif userinput > solution and userinput-solution>6 and userinput-solution<10:
            print("sol est plus petit que votre nbre mais proche")
        else:
            print("sol est plus petit que votre nbre")
else:        
      print("Bingo!!!!!")  
