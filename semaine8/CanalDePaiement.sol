pragma solidity ^0.5.3;
import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/ECDSA.sol";

contract CanalDePaiement {
    
   enum EtatCanal{
       VIDE, 
       ACTIF, 
       ENCOURSFERMETURE, 
       FERME
   }
   address partieA;
   address partieB;
   uint montant;
   EtatCanal etat;
   uint blocFermeture;
   uint dernierNonce;
   uint equilibreA;
   uint equilibreB;
   
   constructor(uint _montant, address _partieA, address _partieB) public {
       montant = _montant;
       partieA = _partieA;
       partieB = _partieB;
       etat = EtatCanal.VIDE;
       
   }
   
   function() payable external {
       require(msg.value >= montant);
       if(msg.sender == partieA){
          equilibreA =  msg.value;
       }   
       if(msg.sender == partieB){
          equilibreB =  msg.value; 
       }
       etat = EtatCanal.ACTIF;
   }
   
   function message(uint _dernierNonce, address _equilibreA, address _equilibreB) pure returns(bytes32){
       bytes32 message = keccak256(abi.encodePacked(_dernierNonce, _equilibreA, _equilibreB)); 
       return message;
    }
    
    function fermeture(uint _nonce, uint _equilibreA, uint _equilibreB) public {
     etat = EtatCanal.ENCOURSFERMETURE;
     bytes32 message = message(_nonce, _equilibreA, _equilibreB);
     bytes32 signature = toEthSignedMessageHash(message);
     address senderAddress = recover(message, signature);
     require(senderAddress == partieB); 
     blocFermeture = block.number;
     etat = EtatCanal.FERME;
    }
    
    function retraitFonds() public payable{
       require(blocFermeture + block.number <= 24 );
       require(etat == EtatCanal.FERME);
       partieA.transfer(_equilibreA);
       partieB.transfer(_equilibreB);
    }
   
}