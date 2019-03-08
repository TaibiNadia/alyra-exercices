pragma solidity ^0.5.3;
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "github.com/OpenZeppelin/openzeppelin-solidity/ERC721/ERC721.sol";

contract  bazar {
ERC721 public nftAddress;    
address public addressObjetsMagiques;
uint256 public dureeEnchere;

struct enchere {
     address meilleurAcheteur;
     uint256 meilleureOffre;
     uint256 finEnchere;
     uint256 objet;
     address vendeur;
     int typeEnchere;
   }
   
enchere[] listeEncheres;
mapping(address=>uint) remboursement;

constructor(address _nftAddress, address _addressObjetsMagiques, uint256 _dureeEnchere) public {
    require(_nftAddress != address(0) && _nftAddress != address(this));
    require(_addressObjetsMagiques != address(0) && _addressObjetsMagiques != address(this));
    nftAddress = ERC721(_nftAddress);
    addressObjetsMagiques = _addressObjetsMagiques;
    dureeEnchere = _dureeEnchere;
}

function proposerALaVente(uint _objet, uint _typeEnchere, uint256 _prixInitial) public{
    require(_typeEnchere == 1 || _typeEnchere == 2,"Choix ne peut etre que egal a 1 ou 2");
   address vendeur = nftAddress.ownerOf(objet);
   if(_typeEnchere == 1){
   listeEncheres.push((0,0,block.number,_objet,vendeur));
   }else {
       listeEncheres.push((0,prixInitial,block.number,objet,vendeur));
   }
   
}

function offre(uint indice) public {
  require(block.number.sub(listeEncheres[indice].finEnchere) <= dureeEnchere ,"Encheres finies");
  
  if(listeEncheres[indice].typeEnchere == 2){
      deduction = listeEncheres[indice].meilleureOffre.div(1000);
      nbBlock = block.number.sub(listeEncheres[indice].finEnchere);
      nouveauPrix = listeEncheres[indice].meilleureOffre.sub(deduction.mul(nbBlock));
      require(msg.value == nouveauPrix,"Montant n est pas adequat"); 
      recupererObjet(indice);
  }else{
  
  require(msg.value > listeEncheres[indice].meilleureOffre,"Montant n est pas adequat");
  remboursement[listeEncheres[indice].meilleurAcheteur] = listeEncheres[indice].meilleureOffre;
  listeEncheres[indice].meilleurAcheteur = msg.sender;
  listeEncheres[indice].meilleureOffre = msg.value;
  }
}

function remboursement() public payable{
    require(remboursement[msg.sender],"Aucun remboursement a faire");
    receive(remboursement[msg.sender]);   //le remboursement ??????
}

function recupererObjet(uint indice) public {
    require(block.number.sub(listeEncheres[indice].finEnchere) > dureeEnchere,"Encheres pas encore finies"); 
    nftAddress.transferFrom(listeEncheres[indice].vendeur,msg.sender,listeEncheres[indice].objet);
    if(listeEncheres[indice].meilleurAcheteur == msg.sender || listeEncheres[indice].vendeur == msg.sender){
    delete listeEncheres[indice]; 
    for (uint i = indice; i<listeEncheres.length-1; i++){
            listeEncheres[i] = listeEncheres[i+1];
        }
        delete listeEncheres[listeEncheres.length-1];
    }
    
}

}
 
    