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
        address illustrateurChoisi;
    }
    
    Demande[] demandes;
    mapping(address => string) clientDemande;
    mapping(address => string) commentaires;
    mapping(address => string) illustrateurService;
    
    uint256 VALEUR_MAX = 2**256 - 1;
    
    function produireHash(string memory _tache) pure public returns(bytes32) {
        keccak256(abi.encodePacked(_tache));
    }
    function compareStrings(string memory a,string  memory b) public pure returns (bool){
       if (produireHash(a) == produireHash(b)) {return true;}
       else {return false;}
    }
    
    function indexDemande(string memory _tache) public view returns(uint index){
        for(uint i=0; i<demandes.length; i++){
          if(compareStrings(demandes[i].tache, _tache)) {  
              return i;
           }
       }
       return VALEUR_MAX;
    }
    
    function detailDemande(uint index) public view returns (Demande memory){
        require(index != VALEUR_MAX);
        return demandes[index];
    }
    
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
        Demande memory demande = detailDemande(indexDemande(_tache));
        return demande.reputationMin;
        
    }
    
    function postuler(string memory _tache) public {
        require( estBanni(msg.sender) == false," Address Bannie");
        require(reputationDemande(_tache) <= reputation[msg.sender],"Reputation min requise");
        uint index = indexDemande(_tache);
        require(demandes[index].etatDemande == Etat.OUVERTE,"Etat doit etre Ouvert");
        demandes[index].candidats.push(msg.sender);
    }
    
    
   function accepterOffre(string memory _tache, address _illustrateur) public {
       require(compareStrings(clientDemande[msg.sender], _tache), "Est Client");
       uint index = indexDemande(_tache);
       demandes[index].etatDemande = Etat.ENCOURS;
       demandes[index].dateAcceptation = now;
       demandes[index].illustrateurChoisi = _illustrateur;
       
    }
   
   function livraison(string memory _tache, bytes32 _hashUrl) public {
       uint index = indexDemande(_tache);
       require(demandes[index].illustrateurChoisi == msg.sender);
       demandes[index].hashUrl = _hashUrl;
       demandes[index].etatDemande = Etat.FERMEE;
       demandes[index].dateCloture = now;
   }
    
    function validerLivraison(string memory _tache) public payable{
        require(compareStrings(clientDemande[msg.sender], _tache),"N est pas le bon client");
        uint index = indexDemande(_tache);
        require(demandes[index].dateCloture + now <= 7 days, "Delai de validation depassé");
        reputation[demandes[index].illustrateurChoisi] = reputation[demandes[index].illustrateurChoisi].add(1);
        msg.sender.transfer(demandes[index].remuneration);
    }
   
   function sanction(string memory _tache, address _illustrateur, uint nbPoint) public {
       require( compareStrings(clientDemande[msg.sender], _tache),"N est pas le bon client" ); 
       uint index = indexDemande(_tache);
       require(demandes[index].illustrateurChoisi == _illustrateur);
       require(now.sub(demandes[index].dateAcceptation) > demandes[index].delai, "Delai de realisation depasse"); 
       reputation[demandes[index].illustrateurChoisi] = reputation[demandes[index].illustrateurChoisi].sub(nbPoint);
       
   }
   
   function ajouterCommentaire(address _entite, string memory _commentaire,string memory _niveauSatisfaction, string memory _tache) public {
        Demande memory demande = detailDemande(indexDemande(_tache));
        require((compareStrings(clientDemande[msg.sender], _tache) && now < demande.dateCloture.add(delaiCommentaire)) || demande.illustrateurChoisi== _entite);
        commentaires[_entite] = _commentaire;
        if (compareStrings(_niveauSatisfaction,"mauvais")){reputation[_entite] = reputation[_entite].sub(2);}
        if (compareStrings(_niveauSatisfaction,"bon")){reputation[_entite] = reputation[_entite].add(2);}
        if (compareStrings(_niveauSatisfaction,"très bon")){reputation[_entite] = reputation[_entite].add(4);}
        
   }
   function ajouterOffreService(string memory _offre) public {
       require(estBanni(msg.sender) == false,"Illustrateur banni");
       illustrateurService[msg.sender] = _offre;
   }
}