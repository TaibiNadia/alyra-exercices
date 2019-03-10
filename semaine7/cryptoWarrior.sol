pragma solidity ^0.5.3;
pragma experimental ABIEncoderV2;
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "github.com/OpenZeppelin/openzeppelin-solidity/ERC721/ERC721.sol";

interface ERC721 /* is ERC165 */ {
            /// @dev This emits when ownership of any NFT changes by any mechanism.
            ///  This event emits when NFTs are created (`from` == 0) and destroyed
            ///  (`to` == 0). Exception: during contract creation, any number of NFTs
            ///  may be created and assigned without emitting Transfer. At the time of
            ///  any transfer, the approved address for that NFT (if any) is reset to none.
            event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

            /// @dev This emits when the approved address for an NFT is changed or
            ///  reaffirmed. The zero address indicates there is no approved address.
            ///  When a Transfer event emits, this also indicates that the approved
            ///  address for that NFT (if any) is reset to none.
            event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

            /// @dev This emits when an operator is enabled or disabled for an owner.
            ///  The operator can manage all NFTs of the owner.
            event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

            /// @notice Count all NFTs assigned to an owner
            /// @dev NFTs assigned to the zero address are considered invalid, and this
            ///  function throws for queries about the zero address.
            /// @param _owner An address for whom to query the balance
            /// @return The number of NFTs owned by `_owner`, possibly zero
            function balanceOf(address _owner) external view returns (uint256);

            /// @notice Find the owner of an NFT
            /// @dev NFTs assigned to zero address are considered invalid, and queries
            ///  about them do throw.
            /// @param _tokenId The identifier for an NFT
            /// @return The address of the owner of the NFT
            function ownerOf(uint256 _tokenId) external view returns (address);

            /// @notice Transfers the ownership of an NFT from one address to another address
            /// @dev Throws unless `msg.sender` is the current owner, an authorized
            ///  operator, or the approved address for this NFT. Throws if `_from` is
            ///  not the current owner. Throws if `_to` is the zero address. Throws if
            ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
            ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
            ///  `onERC721Received` on `_to` and throws if the return value is not
            ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
            /// @param _from The current owner of the NFT
            /// @param _to The new owner
            /// @param _tokenId The NFT to transfer
            /// @param data Additional data with no specified format, sent in call to `_to`
            function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;

            /// @notice Transfers the ownership of an NFT from one address to another address
            /// @dev This works identically to the other function with an extra data parameter,
            ///  except this function just sets data to ""
            /// @param _from The current owner of the NFT
            /// @param _to The new owner
            /// @param _tokenId The NFT to transfer
            function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

            /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
            ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
            ///  THEY MAY BE PERMANENTLY LOST
            /// @dev Throws unless `msg.sender` is the current owner, an authorized
            ///  operator, or the approved address for this NFT. Throws if `_from` is
            ///  not the current owner. Throws if `_to` is the zero address. Throws if
            ///  `_tokenId` is not a valid NFT.
            /// @param _from The current owner of the NFT
            /// @param _to The new owner
            /// @param _tokenId The NFT to transfer
            function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

            /// @notice Set or reaffirm the approved address for an NFT
            /// @dev The zero address indicates there is no approved address.
            /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
            ///  operator of the current owner.
            /// @param _approved The new approved NFT controller
            /// @param _tokenId The NFT to approve
            function approve(address _approved, uint256 _tokenId) external payable;

            /// @notice Enable or disable approval for a third party ("operator") to manage
            ///  all of `msg.sender`'s assets.
            /// @dev Emits the ApprovalForAll event. The contract MUST allow
            ///  multiple operators per owner.
            /// @param _operator Address to add to the set of authorized operators.
            /// @param _approved True if the operator is approved, false to revoke approval
            function setApprovalForAll(address _operator, bool _approved) external;

            /// @notice Get the approved address for a single NFT
            /// @dev Throws if `_tokenId` is not a valid NFT
            /// @param _tokenId The NFT to find the approved address for
            /// @return The approved address for this NFT, or the zero address if there is none
            function getApproved(uint256 _tokenId) external view returns (address);

            /// @notice Query if an address is an authorized operator for another address
            /// @param _owner The address that owns the NFTs
            /// @param _operator The address that acts on behalf of the owner
            /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
            function isApprovedForAll(address _owner, address _operator) external view returns (bool);
        }
contract  cryptoWarrior is NFT, Ownable, ObjetMagique {
  
  enum Weapon {armature, armoredVehicle, fatalWeapon}
  enum Character {idiot, wise, malignant, clever}
  enum Power {flameSpitter, strong, fling, fast}
  enum Suit {mask, mantle, boots, gloves, hat}
  
  struct Warrior{
    uint265 warriorId;
    Weapon _weapon;
    Character _character;
    Power _power;
    Suit _suit;
    uint16 winCount;
    uint16 lossCount;
    uint32 level;
    //Durée du cooldown pour ce chat (index qui fait référence à un tableau avec différents temps)
    uint16 cooldownIndex;
    
    // Code génétique du chat/jeton. Comme pour objetsMagique, le code décrit le type de chaton (couleur de la peau, taille des yeux, type de bouche ... )
    uint256 genes;
    //Date de naissance
    uint64 birthTime;
    // Bloc à partir duquel les chatons peuvent se reproduire à nouveau
    uint64 cooldownEndBlock;
    // identifiant des parents
    uint32 matronId;
    uint32 sireId;
    // Identifiant du père quand le chat est en gestation. 0 si le chat n’est pas en gestation
    uint32 siringWithId;
    // Génération, parti de 0 au lancement
    uint16 generation;
  } 
  
  Warrior[] warriors;
  mapping(uint256 => uint256) warriorToIndex;      //warriorId vers index dans list
  mapping(uint256 => address) public  warriorToOwner;     //owner de warrior
  mapping(address => uint256) ownerWarriorCount;  //nb de warrior pour owner
  mapping (uint256 => address) warriorApprovals;  //
  uint attackVictoryProbability = 70;
  uint dnaDigits = 8;
  uint dnaModulus = 10 ** dnaDigits;
  
  
   // Adresse du contrat de vente aux enchères décentralisé
   SaleClockAuction public saleAuction;                                         //j'ai du mal?????
   
   uint32[14] public cooldowns = [
       uint32(1 minutes),
       uint32(2 minutes),
       uint32(5 minutes),
       uint32(10 minutes),
       uint32(30 minutes),
       uint32(1 hours),
       uint32(2 hours),
       uint32(4 hours),
       uint32(8 hours),
       uint32(16 hours),
       uint32(1 days),
       uint32(2 days),
       uint32(4 days),
       uint32(7 days)
    ];
    
    uint256 public secondsPerBlock = 15; 
    
    address OWNER;
    constructor (address _owner) public {
        OWNER = msg.sender;
    }
      
    
   function ownerOf(uint256 _warriorId) external view returns (address){
        return(warriorToOwner[_warriorId]);
    }
    
    modifier isOwnerOf(uint256 _warriorId){
       require(warriorToOwner[_warriorId] == msg.sender) ;
       _;
    }
    
    // nombre d objets d une address
    function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerWarriorCount[_owner];
  } 
   
  function safeTransferFrom (address _from, address _to, uint256 _warriorId) external payable{
      require(ownerOf(_warriorId) == _from && _to!= 0);
      ownerWarriorCount[msg.sender]-=1;
      ownerWarriorCount[_to]+=1;  
      warriorToOwner[_warriorId]= _to;
      OWNER.transfer(msg.value);
      emit Transfer(_from, _to, _warriorId);
  }
  
  function approve(address _approved, uint256 _warriorId) external payable {
      address owner = ownerOf(_warriorId);
      require(owner == msg.sender);
      warriorApprovals[_warriorId] == _approved;
      OWNER.transfer(msg.value);
      emit Approval(msg.sender, _approved, _tokenId);
  }

  function warriorExists(uint256 _warriorId) internal view returns(bool){
      return ownerWarriorCount[_owner] != address(0);
  }
  
  //function ranMod(uint _modulo) returns(uint){           //objetMagique function
  //     return  blockhash(block.number-1) % _modulo;
  //  }
  
  function getWarrior(uint256 _warriorId) internal returns (Warrior storage){
      return warriors[warriorToIndex[_warriorId]];
  }
  
  // 
  function _triggerCooldown(uint256 _warriorId, uint16 _cooldownTime ) internal {
    Warrior storage _Warrior = getWarrior(_warriorId);
    _warrior.cooldownIndex = uint32(now + _cooldownTime);
  }
    
  function isReadyTime(uint256 _warriorId) internal returns(bool){
      return (getWarrior(_warriorId).cooldownIndex < now);
  }
    
    function attack(uint256 _warriorId, uint256 _targetId) external isOwnerOf(_warriorId){
       require(isReadyTime,"Can't attack yet");
       Warrior storage myWarrior = getWarrior(_warriorId);
       Warrior storage enemyWarrior = getWarrior(_targetId);
       uint rand = ranMod(100);
         if (rand <= attackVictoryProbability) {
           myWarrior.winCount +=1;
           enemyWarrior.lossCount +=1;
           myWarrior.level +=1;
         }else {
           myWarrior.lossCount +=1;
           enemyWarrior.enemyWarrior +=1;
        }
        _triggerCooldown(_warriorId,cooldowns[10]);   //ne peut reattaquer pendant 1 jour
    }
    
    function generateRandomNumbre() public returns(uint){
        nbRandom = blockhash(block.number-1);
        return nbRandom % dnaModulus;   //n assure pas que le premier digit est 0,1 ou 2 ???
    }
    
    function createWarrior() external {     // à completer
        uint8 _warriorId = generateRandomNumbre();
        warriors.push(_warriorId);
        
    }
    
    function getWarriorsByOwner(address _owner) external view returns(uint[]){
        uint[] memory  result = new uint[](ownerWarriorCount[_owner]);
        uint counter = 0;
        for(uint i=0; i<warriors.length; j++  ){
            if(warriorToOwner[warriors[i].warriorId]==_owner){
                result[counter] = warriors[i].warriorId;
                counter++;
            }
        }
        return result;
    }
    
    //Vérifie que le chat est prêt à entrer dans une phase de reproduction

   function _isReadyToBreed(Kitty _kit) internal view returns (bool) {

       return (_kit.siringWithId == 0) && (_kit.cooldownEndBlock <= uint64(block.number));

   }

}