//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.25;
contract Assemblee { 
  address [] membres;
  mapping(address=>bool)blame;
  address [] administrateurs;
  struct Decision{
    uint dateLancement;
    string description;
    uint votesPour;
    uint votesContre;
    mapping (address => bool) aVote;
   }
  Decision[] decisions;
  uint constant delaiVote=604800;
  string public nomAssemble;
  constructor(string nom) public{
    nomAssemble = nom;
  }
  address administrateur;

    modifier seulAdministrateur {
        require(msg.sender == administrateur,"Il faut être Administrateur");
        _;
    }

    function estblame(address adr) public seulAdministrateur {
      if(blame[adr]){
        //supprimer tous ses vote et le supprimer
        for(uint i=0; i<membres.length; i++){
          if(membres[i] == adr){
            delete membres[i];
            for(uint j=i; j<membres.length; j++ ){
              membres[j] = membres[j+1];
            }
            for(i=0;i<decisions.length; i++ ){
              if(decisions[i].aVote[adr]){
                delete decisions[i].aVote[adr];
              }
            }  

          }
        }

      }
    }
    function estAdmin(address adr) public view returns (bool) {
    for(uint i; i<administrateurs.length; i++){
      if(administrateurs[i] == adr){return true;}
    }
    return false;
  }

  function nommerAdmin(address adr) public seulAdministrateur {
    administrateurs.push(adr);
  }  

  function demissionAdmin(address adr) public seulAdministrateur{
    require(estAdmin(adr),"Seul admin peut demissionne");
    for(uint i; i<administrateurs.length; i++){
      if (administrateurs[i]==adr){
        delete administrateurs[i];
        for(uint j=i;j<administrateurs.length; j++){
          administrateurs[j]=administrateurs[j+1];
        }
      }
    }
  }

  function estMembre (address par) public constant returns (bool) {
    for (uint i=0; i < membres.length; i++){
      if (membres[i] == par){
        return true;
      }
    }
    return false;
  }

  function rejoindre() public {
    membres.push(msg.sender);
  } 

  function proposerDecision(string description) public {
    require(estMembre(msg.sender),"Doit être membre");
    Decision memory decision;
    decision.dateLancement = now;
    decision.description=description;
    decision.votesPour=0;
    decision.votesContre=0;
    decisions.push(decision);
    }

  function fermerDecision(uint indice) public seulAdministrateur{
    delete decisions[indice];
    for(uint j=indice;j<decisions.length; j++){
          decisions[j]=decisions[j+1];
    }
  }

  function aVote(uint indice) public view returns (bool){
    return(decisions[indice].aVote[msg.sender]);
  }

  function delaiExpire(uint indice) public view returns(bool){
    if(now - decisions[indice].dateLancement < delaiVote){
      return true;
    }else return false;
  }

  function voter(uint indice,uint vote) public{
    require(estMembre(msg.sender),"Doit être membre"); 
    require(aVote(indice) == false,"Doit voter une seule fois");
    require(!delaiExpire(indice),"Delai du vote à expire");
    if(vote == 1){decisions[indice].votesPour+=1;}  
    else if (vote == 0) decisions[indice].votesContre+=1;
  }  
  
  function comptabiliser(uint indice) public view returns (int){
    return int(decisions[indice].votesPour - decisions[indice].votesContre);
  }
}
