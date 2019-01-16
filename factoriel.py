def fact(nb):
    if nb<2:
        return 1    
    else:
        return nb*fact(nb-1)
        
print(fact(6))
