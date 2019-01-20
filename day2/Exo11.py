def chiffreCesar(chaine,decalage):
    alpha=['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
    messageCode = ""
    for lettre in chaine:
        position = chaine.index(lettre)
        messageCode=str(messageCode) + str(alpha[position+decalage])
    return messageCode
cle = 99
texte= "aaaaaa"
while cle != 0:
    cle = int(input("Entrez votre cle de decalage : "))
    print(chiffreCesar(texte,cle))

