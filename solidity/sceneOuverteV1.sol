//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.25;
contract SceneOuverte {
string[12] passagesArtistes;
uint tour;
uint creneauxLibres = 12;
function sInscrire(string nomArtiste) public {
  if (creneauxLibres>0) {
    passagesArtistes[creneauxLibres] = nomArtiste;
    creneauxLibres-=1;
  }
}
function passageArtisteSuivant() public returns(string) {
  if (tour<12){
    tour+=1;
    return passagesArtistes[tour];
    }else return "Fin";
}
function artisteEnCours () public constant returns(string){
  return passagesArtistes[tour];
} 
}
