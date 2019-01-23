def recompense(hBloc):
    fourche = hBloc //  210000
    print("Fourche"+ str(fourche))
    rec = 50
    if fourche == 0:
        rec = 50
    else:   
        i=1
        while i <= fourche + 1:
            rec=round(rec/i,2)
            i+=1
    print("Fourche : " + str(fourche))
    print("Recompense : " + str(rec))
    return fourche
print(recompense(320000))
   
