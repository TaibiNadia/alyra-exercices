pragma solidity ^0.5.3;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract Credibilite {


   using SafeMath for uint256;


   mapping (address => uint256) public cred;

   bytes32[] private devoirs;
   
   function produireHash(string memory url) pure public returns(bytes32) {
        keccak256(abi.encodePacked(url));
   }
   
   function transfer (address destinataire, uint256 valeur) public {
      require(cred[msg.sender] > valeur);
      cred[msg.sender] -= valeur;
      cred[destinataire] += valeur;
      
   }
   function remettre(bytes32 dev) public returns (uint){
       require(cred[msg.sender]== 0);
       uint  nbDevoirs = devoirs.length;
       for(uint i = 0; i < devoirs.length; i++){
          require(devoirs[i] != dev);
       }
       if (nbDevoirs == 0){cred[msg.sender] = 30;}
       else if(nbDevoirs == 1){cred[msg.sender] = 20;}
       else {cred[msg.sender] = 10;}
        return nbDevoirs;
   }
   
}