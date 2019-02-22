pragma solidity ^0.5.3;
contract Cartes{
    mapping(uint=>bytes32) hashImage;
    string[] cartes;

   function ajouterCarte(string memory s) public {
       cartes.push(s);
   }

   function recuperer(uint ind) view public returns (bytes32) {
       return hashImage[ind];
   }
   function nbCartes() public view returns(uint){
       return cartes.length;
   }
}
