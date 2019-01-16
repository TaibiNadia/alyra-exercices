def palin(mot):
    if len(mot)==0 or len(mot)==1:
        return True
    elif mot[0] == mot[len(mot)-1]:
        return palin(mot[1:-1])
    else:
        return False
    
chaine="ESOPE RESTE ICI ET SE REPOSE"
chaine=chaine.replace(" ", "")
    
if palin(chaine):
    print("Palindrome")
else:
    print("Not palindrome")
