async function createMetaMaskDapp() {
 try {
   // Demande à MetaMask l'autorisation de se connecter
   const addresses = await ethereum.enable();
   const address = addresses[0];
   const credibiliteAddress = "0x451875bdd0e524882550ec1ce52bcc4d0ff90eae";
   const abi = [
  {
    "constant": false,
    "inputs": [
      {
        "name": "dev",
        "type": "bytes32"
      }
    ],
    "name": "remettre",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "name": "cred",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "dd",
        "type": "string"
      }
    ],
    "name": "produireHash",
    "outputs": [
      {
        "name": "",
        "type": "bytes32"
      }
    ],
    "payable": false,
    "stateMutability": "pure",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "destinataire",
        "type": "address"
      },
      {
        "name": "valeur",
        "type": "uint256"
      }
    ],
    "name": "transfer",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  }
];


   // Connection au noeud fourni par l'objet web3
   const provider = new ethers.providers.Web3Provider(ethereum);
   dapp = { address, provider };

   // console.log(dapp);
   

   const [ BlockNumber, Balance, GasPrice ]  = await Promise.all([
	provider.getBlockNumber(),
	provider.getBalance(address),
	provider.getGasPrice()
]);


document.getElementById('blockNb').innerHTML = BlockNumber;
document.getElementById('balance').innerHTML = Balance;
document.getElementById('gas').innerHTML = GasPrice.toString();
// console.log(BlockNumber, Balance.toString(), GasPrice.toString())

const contratCredibilite = new ethers.Contract(credibiliteAddress, abi, dapp.provider);
const maCredibilite = await contratCredibilite.cred("0x9715dfA70779713c1AF45E8EA66A045a3d32C320");
document.getElementById('credibilite').innerHTML = maCredibilite;
	
 } catch(err) {
   // Gestion des erreurs
   console.error(err);
 }

}

// Balance

async function balance(){
 dapp.provider.getBalance(dapp.address).then((balance) => {
   let etherString = ethers.utils.formatEther(balance);
   console.log("Balance: " + etherString);
 });

}