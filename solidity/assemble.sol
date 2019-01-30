//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.25;
contract Assemblee {
address [] participants;

struct Vote {
  string descriVote;
  uint votePour;
  uint voteContre;
  uint dateLimite;
  bool ferme;
  mapping (address => bool) aVote;
  }
Vote [] votes;
mapping (address => uint) public participantVote;
//string [] descriVotes;
//uint [] votesPour;
//uint [] votesContre;
string nomAssemble;
//modifier
address administrateur;

    modifier onlyAdministrateur {
        require(msg.sender == administrateur,"Il faut être Administrateur");
        _;
    }
constructor(string memory newNom) public{
    nomAssemble = newNom;
  }
function getNom() public constant returns(string){
  return nomAssemble;
}
function setNom(string newNom) public{
  nomAssemble = newNom;
}  
function rejoindre() public {
  participants.push(msg.sender);
}

function estParticipant (address par) public constant returns (bool) {
  for (uint i=0; i < participants.length; i++){
    if (participants[i] == par){
      return true;
    }
  }
  return false;
}
function proposerUnVote(string description) public {
  require(estParticipant(msg.sender),"Il faut être participant ");
    Vote memory vote;
    vote.descriVote = description;
    vote.voteContre = 0;
    vote.votePour = 0;
    votes.push(vote);

    //descriVotes.push(vote);
    //votesPour.push(0);
    //votesContre.push(0);
}

function estFerme(uint indiceVote) internal view returns(bool){
  return (votes[indiceVote].ferme || votes[indiceVote].dateLimite > now*2);
}

function aVote(uint indiceVote) internal view returns(bool){
  return (votes[indiceVote].aVote[msg.sender]);
}

function voter(uint indiceVote, uint vote) public {
  require(estParticipant(msg.sender),"Doit être participant");
  require(estFerme(indiceVote) == false,"Doit être ouvert");
  require(aVote(indiceVote) == false,"Ne doit pas avoir déjà participé");
  if (vote == 1){
     votes[indiceVote].votePour+=1;
  } else{
        if (vote == 0) votes[indiceVote].voteContre+=1;
        }
}

function compteVotesPour(uint indiceVote) public view returns (uint pour){
   return votes[indiceVote].votePour;
  }
function compteVotesContre(uint indiceVote) public view returns (uint contre){
   return votes[indiceVote].voteContre;
  }
 function differenceVote(uint indiceVote) public view returns (int diff) {
   diff = int(compteVotesPour(indiceVote) - compteVotesContre(indiceVote));
   return(diff);
 }
 
 function supprimerVote(uint indiceVote) public onlyAdministrateur{
   delete votes[indiceVote];  //il faut remanier la liste???
 }
}
