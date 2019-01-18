def division(nbre,hexa):
    
    val = 0
    if nbre<1:
        if nbre > 9:
           val = hexaVal(nbre)
        else:
            val=nbre
        hexa.append(val)
        #print(hexa)
        return hexa
    else:
        val = nbre % 16
        if val > 9:
           val = hexaVal(val)
        
        hexa.append(str(val)) 
        nbre = nbre//16
        return division(nbre,hexa)
        
def hexaVal(n):
    v = ""
    if n == 10:
       v = "a"
    if n == 11:
         v ="b"
    if n == 12:
         v = "c"
    if n == 13:
         v = "d"
    if n == 14:
         v = "e"
    if n == 15:   
        v = "f"
    return v

valeurHexa = []
# Le nombre est donné ici il aurait fallu le lire a l ecran
x=466321 
print ("*****"+str(division(x,valeurHexa))+"***")
k=len(valeurHexa)
i=0
nbHexa=""
print("Little Endian "+"\t")
while i< k:
    print(str(valeurHexa[i])+"\t")
    nbHexa = nbHexa + str(valeurHexa[i])
    i+=1
taille = len(nbHexa)    
nbHexa = "0x" + nbHexa
print (nbHexa)
print (taille)
i=k-1
print("Big Endian "+"\t")
while i>= 0:
    print(str(valeurHexa[i])+"\t")
    i-=1


if x > 253:
    if taille == 2:
       nbHexa="fe"+ nbHexa
    if taille == 3:
       nbHexa="fe"+ nbHexa + "00" 
    if taille == 4:
       nbHexa="fe"+ nbHexa
    if taille == 5:
       nbHexa="fe"+ nbHexa + "000000"
    if taille == 6:
       nbHexa="fe"+ nbHexa + "0000"   
    if taille == 7:
       nbHexa="fe"+ nbHexa + "00"
    if taille == 8:
       nbHexa="fe"+ nbHexa   
print (nbHexa)        
