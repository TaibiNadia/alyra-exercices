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
print ("*****"+str(division(466321,valeurHexa))+"***")
k=len(valeurHexa)
i=0
print("Little Endian "+"\t")
while i< k:
    print(str(valeurHexa[i])+"\t")
    i+=1
i=k-1
print("Big Endian "+"\t")
while i> 0:
    print(str(valeurHexa[i])+"\t")
    i-=1    
