pragma solidity ^0.5.3;
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "github.com/OpenZeppelin/openzeppelin-solidity/ERC721/ERC721.sol";

contract ObjetsMagiques is NFT,Ownable {
    
    event Sent(address indexed payee, uint256 amount, uint256 balance);
    event Received(address indexed payer, uint tokenId, uint256 amount, uint256 balance);
    
    ERC721 public nftAddress;
    uint256 public currentPrice;
    
    mapping(address=> uint) objetMagiqueNb;

    struct objetMagique {
        string nom;
        uint nbMagique;
    }
    
    uint jetonDigits = 4;    // le jeton sur 4 digits
    uint jetonModulo = 10**4;  // possibilite de jeton
    
    objetMagique[] objetsMagiques;
    
    constructor(address _nftAddress, uint256 _currentPrice) public { 
        require(_nftAddress != address(0) && _nftAddress != address(this));
        require(_currentPrice > 0);
        nftAddress = ERC721(_nftAddress);
        currentPrice = _currentPrice;
     }
    function owner(uint _jetonId, address _adr) returns(bool){
       return(objetMagiqueNb[_adr] == _jetonId);
    }
    function creuser() public payable {
        require(msg.sender != address(0) && msg.sender != address(this));
        require(msg.value >= currentPrice);
        objetMagique = creerJeton("Fetiche");
        _jetonId = objetMagique.nbMagique;
        require(nftAddress.exists(_jetonId));
        objetMagiqueNb[msg.sender] = _jetonId;
        emit Received(msg.sender, _jetonId, msg.value, address(this).balance);
    }
    
    function genererRandomJeton() public returns(uint){
        nbRandom = blockhash(block.number-1);
        return nbRandom % jetonModulo;   //n assure pas que le premier digit est 0,1 ou 2 ???
    }
    
    function creerJeton(string _nom) public returns(objetCourant){
     uint _nbMagique = genererRandomJeton();
     require(nftAddress.exists(_jetonId)== false);
     objetMagique objetCourant;
     objetCourant.nom = _nom;
     objetCourant.nbMagique = _nbMagique;
     objetsMagiques.push(_nom,_nbMagique);
     return objetCourant;
    }
    
    function utiliser(uint _nbMagique) public {
       require(owner(_nbMagique,msg.sender)) ;
       nbRandom = blockhash(block.number-1);
       nbre = nbRandom % 10;
       if (nbre == 0){
           objetMagiqueNb[msg.sender].isDeleted=true;   // supp du mapping
           for(uint i;objetsMagiques.length;i++){                    //supp dans la liste des objetsMagiques??
               if(objetsMagiques[i].nbMagique == _nbMagique){
                  uint j=i;
                  for(j;objetsMagiques.length;j++){
                    objetsMagiques[j] =  objetsMagiques[j+1] ;
                  }
                }
           
            }
    
        }
    
    }
    
}
