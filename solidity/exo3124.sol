//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.25;
contract Assemblee { 
  address [] membres;
  //string [] descriptionDecision;
  //uint [] votesPour;
  //uint [] votesContre;

  struct Decision{
    //uint constant dateLimite = 604800 ; je ne sais pas pourquoi j ai ereur pour ca
    string description;
    uint votesPour;
    uint votesContre;
    mapping (address => bool) aVote;
    
  }
  Decision[] decisions;

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
    decision.description=description;
    decision.votesPour=0;
    decision.votesContre=0;
    decisions.push(decision);
    }

  function aVote(uint indice) public view returns (bool){
    return(decisions[indice].aVote[msg.sender]);
  }

  function voter(uint indice,uint vote) public{
    require(estMembre(msg.sender),"Doit être membre"); 
    require(aVote(indice) == false,"Doit voter une seule fois");
    if(vote == 1){decisions[indice].votesPour+=1;}  
    else if (vote == 0) decisions[indice].votesContre+=1;
  }  
  
  function comptabiliser(uint indice) public view returns (int){
    return int(decisions[indice].votesPour - decisions[indice].votesContre);
  }
}
