def occur(texte):
    texte2=[]
    dis=''.join(set( texte))
    for l in dis:
        nbOcc =texte.count(l)
        print(str(nbOcc)+l+"\t")

occur("Etre contesté, c’est être constaté")


    
