def chainAlea(n):
    import random
    i=1
    chaine=""
    while i<=n:
        c  = random.randrange(65, 90)
        car = chr(c)
        chaine = chaine + car
        i+=1
    return (chaine)
def rechercheDebut(debChaine, nb):
    taille=len(debChaine)
    trouve=False
    while trouve == False:
        testentier = chainAlea(nb)
        test = testentier [0:taille]
        print(test)
        if test == debChaine:
           trouve = True
    return(testentier)
    
print(rechercheDebut("AA", 8))
        
