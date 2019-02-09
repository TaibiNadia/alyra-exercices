pragma solidity ^0.5.3;
pragma experimental ABIEncoderV2;
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract PlaceMarche {
    using SafeMath for uint;
    mapping(address => uint) reputation;
    address[] bannies;
    address[] administateurs;
    address[] clients;
    address[] illustrateurs;
    
    
    enum Etat {OUVERTE, ENCOURS, FERMEE}
    uint256 delaiCommentaire = 1 days * 7;
    
    struct Demande {
        uint256 remuneration;
        uint256 dateAcceptation;
        uint256 delai;
        string tache;
        Etat etatDemande;
        uint256 dateCloture;
        uint reputationMin;
        bytes32 hashUrl;
        address[] candidats;
    }
    
    Demande[] demandes;
    mapping(address => string) clientDemande;
    mapping(address => string) commentaires;
    mapping(address => string) illustrateurDemande;
    
    function estAdmin (address _participant) public view returns (bool){
        for(uint i=0; i<administateurs.length; i++){
        if (administateurs[i] == _participant){return true;}
        }
        return false;    
        }
    
    function aBannir(address participant) public{
        require(estAdmin(msg.sender),"Doit être administrateur");
        require(estBanni(msg.sender) == false,"Deja banni");
        reputation[participant] = 0;
        bannies.push(participant);
    }
    
    function estBanni(address participant) public  view returns (bool){
        for(uint i=0; i<bannies.length; i++){
        if (bannies[i] == participant){return true;}
        }
        return false;    
    }
    
    function inscription() public {
        require( estBanni(msg.sender) == false," Address Bannie");
        illustrateurs.push(msg.sender);
        reputation[msg.sender] = 1;
        
    }    
    function ajouterDemande(uint _reputationMin, string memory _tache, uint _delai) payable public {
        require(estBanni(msg.sender) == false,"Deja banni");
        Demande memory demande; 
        uint montant = msg.value.mul(2);
        montant = montant.div(100);
        montant = msg.value.sub(montant);
        demande.remuneration = montant;
        demande.delai = _delai;
        demande.dateAcceptation = 0;
        demande.etatDemande = Etat.OUVERTE;
        demande.reputationMin = _reputationMin;
        demandes.push(demande);
        clientDemande[msg.sender] = _tache;
    }
    
    function reputationDemande(string memory _tache) public view returns (uint){
        for(uint i=0; i< demandes.length; i++){
           if (produireHash(demandes[i].tache) == produireHash(_tache)){return demandes[i].reputationMin;} 
        } 
        return 0;
    }
    
    function postuler(string memory _tache) public {
        require(reputationDemande(_tache) <= reputation[msg.sender]);
        for(uint i=0; i<demandes.length; i++){
          if(produireHash(demandes[i].tache) == produireHash(_tache)) {  
              demandes[i].candidats.push(msg.sender);
           }
       }
    }
    
    function produireHash(string memory _tache) pure public returns(bytes32) {
        keccak256(abi.encodePacked(_tache));
   }
    
   function accepterOffre(string memory _tache, address _illustrateur) public {
       //require()  est le client de la demande
       for(uint i=0; i<demandes.length; i++){
          if(produireHash(demandes[i].tache) == produireHash(_tache)) {  
              demandes[i].etatDemande = Etat.ENCOURS;
              demandes[i].dateAcceptation = now;
              illustrateurDemande[_illustrateur] = _tache;
           }
       }
    }
   
   function livraison(string memory _tache, bytes32 _hashUrl) public payable{
       require( produireHash(illustrateurDemande[msg.sender]) == produireHash(_tache), "Est le bon  illustrateur");
       for(uint i=0; i< demandes.length; i++){
           if (produireHash(demandes[i].tache) == produireHash(_tache)){
               demandes[i].hashUrl = _hashUrl;
               demandes[i].etatDemande = Etat.FERMEE;
               demandes[i].dateCloture = now;
               msg.sender.transfer(demandes[i].remuneration);
           } 
        }
        reputation[msg.sender] = reputation[msg.sender].add(1);
    }
   
   function sanction(string memory _tache, address _illustrateur, uint nbPoint) public {
       require( produireHash(clientDemande[msg.sender]) == produireHash(_tache),"Est le bon client" ); 
       require( produireHash(illustrateurDemande[_illustrateur]) == produireHash(_tache), "Est le bon  illustrateur");
       
       for(uint i=0; i<demandes.length; i++){
          if(produireHash(demandes[i].tache) == produireHash(_tache)) {  
            require(now.sub(demandes[i].dateAcceptation) > demandes[i].delai, "Delai de realisation depasse");  
            reputation[_illustrateur] = reputation[_illustrateur].sub(nbPoint);  
           }
       }
   }
   
   
   function ajoutCommentaire(address _entite, string memory _commentaire,string memory _niveauSatisfaction, string memory _tache) public {
    require((produireHash(clientDemande[msg.sender]) == produireHash(_tache)) || (produireHash(illustrateurDemande[msg.sender]) == produireHash(_tache)),"Client ou Illustrateur");
     for(uint i=0; i< demandes.length; i++){
         if(produireHash(demandes[i].tache) == produireHash(_tache)){
            require(now < demandes[i].dateCloture.add(delaiCommentaire),"Delai depassee");
            commentaires[_entite] = _commentaire;
            if (produireHash(_niveauSatisfaction) == produireHash("mauvais")){reputation[_entite] = reputation[_entite].sub(2);}
            if (produireHash(_niveauSatisfaction) == produireHash("bon")){reputation[_entite] = reputation[_entite].add(2);}
            if (produireHash(_niveauSatisfaction) == produireHash("très bon")){reputation[_entite] = reputation[_entite].add(4);}
         }
         
     }    
     
   }
}