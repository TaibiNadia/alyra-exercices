def calculerDifficulte(cible):
    cMax=2.7 * 10**67
    print("cMax"+str(cMax))
    c = int(cible, 16)
    diff=cMax / c
    return diff
print("Difficulte 1 : " + str(calculerDifficulte("0x1c0ae493")))
