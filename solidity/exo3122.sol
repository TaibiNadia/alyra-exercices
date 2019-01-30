//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.25;
contract Assemblee { 
  address [] membres;
  string [] descriptionDecision;
  uint [] votesPour;
  uint [] votesContre;
  
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
    descriptionDecision.push(description);
    votesPour.push(0);
    votesContre.push(0);
    }

  function voter(uint indiceProposition,uint vote) public{
    require(estMembre(msg.sender),"Doit être membre"); 
    if(vote == 1){votesPour[indiceProposition]+=1;}  
    else if (vote == 0) votesContre[indiceProposition]+=1;
  }  
  
}
