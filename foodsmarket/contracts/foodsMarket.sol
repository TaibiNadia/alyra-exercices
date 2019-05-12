pragma solidity ^0.5.3;
contract foodsMarket {
    
    uint public bigStoresCount;
    uint public associationsCount;
    uint public goodsCount;
    uint public conventionsCount;
     
    uint constant private  DELAI = 10 days;
    address public _owner;
    
    event SelectedGoodEvent(Categorie categorie,uint quantite, string titre, string siege);
    
    struct Association {
        address adrAssoc;
        string titre;
        string siege;
        Statuts statuts;
        
    }
    
    struct BigStore {
        address adrBigStore;
        string nom;
        string siege;
        uint surface;
    }
    
    struct Good{
       uint id;
       Categorie categorie;        
       uint quantite;
       address bigStoreAddress;
       uint dateDepot;
       address assocAddress;
    }
   struct Convention{
       address bigStore;
       address assoc;
   }
   
   enum Categorie{
        PRODUITFRAIS,
        FRUITLEGUME,
        VIANDE,
        VIENNOISERIE,
        SURGELE
    }
   enum Statuts{
       NONDECLAREE,
       DECLAREE,
       UTILITEPUBLIQUE
   }
   
   
   address[] blackList;
   Convention[] public conventions; 
   
   mapping(address=>uint) addressToAssoc;
   mapping(address => uint) addressToBigStore;
   
   mapping(uint=> Good) public goods;
   mapping(uint => BigStore) public bigStores;
   mapping(uint => Association) public associations;
   
   constructor() public{
      _owner = msg.sender; 
   }
   
   modifier isAssoc() {
        require(addressToAssoc[msg.sender] != 0,"Not Association"); 
        _;
   }
   
   modifier isBigStore() {
        require(addressToBigStore[msg.sender] != 0,"Not Big Store");
        _;
   }
   function blackListed(address _address) public isBigStore{
       blackList.push(_address);
   }
   
   function isBlackListed(address _address) public view returns(bool){
       for(uint i = 0; i<blackList.length; i++ ){
           if(blackList[i]==_address){
              return true; 
           }
       }
       return false;
   }
   
   modifier notBlackListed() {
       require(isBlackListed(msg.sender) == false,"Is BlackListed");
       _;
   }
   modifier isOwner() {
       require(msg.sender == _owner);
       _;
   }
   function enumCat(uint _cat) public pure returns(Categorie){
    if(_cat == 0){return Categorie.PRODUITFRAIS;}
        else if(_cat == 1){return Categorie.FRUITLEGUME;}
        else if(_cat == 2){return Categorie.VIANDE;}
        else if(_cat == 3){return Categorie.VIENNOISERIE;}
        else if(_cat == 4){return Categorie.SURGELE;}   
   }
   function enumStat (uint _stat) public pure returns(Statuts){
    if(_stat == 0){return Statuts.NONDECLAREE;}
        else if(_stat == 1){return Statuts.DECLAREE;}
        else if(_stat == 2){return Statuts.UTILITEPUBLIQUE;}
           
   }
   
   function withConventionBigStoreAssoc(address _bigStoreAdr, address _assocAdr) public view returns (bool){
       for(uint i = 0; i< conventions.length; i++){
           if(conventions[i].bigStore == _bigStoreAdr && conventions[i].assoc == _assocAdr){
               return true;
           }
       }
       return false;
    } 
   
   function addAssociation(string memory _titre, string memory _siege, uint _statuts) public {
        Association memory _association;
        _association.adrAssoc = msg.sender;
        _association.titre = _titre;
        _association.siege = _siege;
        _association.statuts = enumStat(_statuts);
        associationsCount++;
        associations[associationsCount] = _association;
        addressToAssoc[msg.sender] = associationsCount;
   }
   
   function addBigStore(string memory _nom, string memory _siege, uint _surface) public {
        BigStore memory _bigStore;
        _bigStore.adrBigStore = msg.sender;
        _bigStore.nom = _nom;
        _bigStore.siege = _siege;
        _bigStore.surface = _surface;
        bigStoresCount++;
        bigStores[bigStoresCount] = _bigStore;
        addressToBigStore[msg.sender] = bigStoresCount;
   }
   function addConvention(address _assoc ) public isBigStore{
       Convention memory _convention;
       _convention.bigStore = msg.sender;
       _convention.assoc = _assoc;
       conventions.push(_convention);
       conventionsCount++;
       }
   
   function proposedGood(uint _categorie, uint _quantite) public isBigStore{
        Good memory _good;
        goodsCount++;
        _good.id =goodsCount;
        _good.categorie = enumCat(_categorie);
        _good.quantite = _quantite;
        _good.dateDepot = now;
        _good.bigStoreAddress = msg.sender;
        goods[goodsCount] = _good;
    }
   
   
   function selectedGood(uint _index) public isAssoc notBlackListed{
       require(withConventionBigStoreAssoc(goods[_index].bigStoreAddress,msg.sender),"No convention between");
       require(now - goods[_index].dateDepot <= DELAI - 2 days);
       goods[_index].assocAddress = msg.sender;
       uint _indexAssoc = addressToAssoc[msg.sender];
       Association memory _association = associations[_indexAssoc];
       emit SelectedGoodEvent(goods[_index].categorie,goods[_index].quantite,_association.titre,_association.siege);
   }
   
   function sentGood(uint _index) public {
       Good memory _good = goods[_index];
       require(msg.sender ==_good.bigStoreAddress, "Is not right store");
       require(now - _good.dateDepot <= DELAI,"delay expired ");  
       // suppression de la marchandise livree
       delete goods[_index];
    }
   

}