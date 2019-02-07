async function createMetaMaskDapp() {
 try {
   // Demande à MetaMask l'autorisation de se connecter
   const addresses = await ethereum.enable();
   const address = addresses[0];
   const credibiliteAddress = "0x451875bdd0e524882550ec1ce52bcc4d0ff90eae";  //adr de la dapp credibilite du prof
   const credibiliteEventAddress ="0x451875bdd0e524882550ec1ce52bcc4d0ff90eae";  //ajout event dans Dapp
   const abiEvent = [												
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
				"name": "url",
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
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "dev",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "emetteur",
				"type": "address"
			}
		],
		"name": "Depot",
		"type": "event"
	}
];   // abi de ma dapp


   // Connection au noeud fourni par l'objet web3
   const provider = new ethers.providers.Web3Provider(ethereum);
   dapp = { address, provider };


const contratCredibilite = new ethers.Contract(credibiliteEventAddress, abiEvent, dapp.provider);
const maCredibilite = await contratCredibilite.cred("0x9715dfA70779713c1AF45E8EA66A045a3d32C320");  // adr dans metamask par laquelle j'ai envoye mon devoir
document.getElementById('credibilite').innerHTML = maCredibilite;

let urlDevoir = document.getElementById("urlDevoir").value;
const hashUrl = await contratCredibilite.produireHash(urlDevoir);

//remise de devoir et gestion event
const contractCredibiliteSigner = new ethers.Contract( ballotAddress , abi , provider.getSigner() ); //pour function en ecriture
const nbDevoirs = await contratCredibiliteSigner.remettre(hashUrl);

document.getElementById('nbDevoirs').innerHTML = NbDevoirs;

contratCredibilite.on('Depot', (dev,emetteur) => {
document.getElementById('credibilite').innerHTML = dev;
});
	
 } catch(err) {
   // Gestion des erreurs
   console.error(err);
 }

}

