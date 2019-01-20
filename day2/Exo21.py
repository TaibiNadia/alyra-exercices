def chiffreCesar(chaine,mot):
    alpha=['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
    messageCode = ""
    taille = len(mot)
    for lettre in chaine:
        modulo = chaine.index(lettre) % taille
        position = alpha.index(lettre) + modulo
        messageCode=str(messageCode) + str(alpha[position])
    return messageCode
motCle = "abc"
texte= "adel"
print(chiffreCesar(texte,motCle))
