   const addressContrat = "0x9715dfa70779713c1af45e8ea66a045a3d32c320";  

   const abiContrat = [
	{
		"constant": true,
		"inputs": [
			{
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "detailDemande",
		"outputs": [
			{
				"components": [
					{
						"name": "remuneration",
						"type": "uint256"
					},
					{
						"name": "dateAcceptation",
						"type": "uint256"
					},
					{
						"name": "delai",
						"type": "uint256"
					},
					{
						"name": "tache",
						"type": "string"
					},
					{
						"name": "etatDemande",
						"type": "uint8"
					},
					{
						"name": "dateCloture",
						"type": "uint256"
					},
					{
						"name": "reputationMin",
						"type": "uint256"
					},
					{
						"name": "hashUrl",
						"type": "bytes32"
					},
					{
						"name": "candidats",
						"type": "address[]"
					},
					{
						"name": "illustrateurChoisi",
						"type": "address"
					}
				],
				"name": "",
				"type": "tuple"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_reputationMin",
				"type": "uint256"
			},
			{
				"name": "_tache",
				"type": "string"
			},
			{
				"name": "_delai",
				"type": "uint256"
			}
		],
		"name": "ajouterDemande",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_participant",
				"type": "address"
			}
		],
		"name": "estAdmin",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_entite",
				"type": "address"
			},
			{
				"name": "_commentaire",
				"type": "string"
			},
			{
				"name": "_niveauSatisfaction",
				"type": "string"
			},
			{
				"name": "_tache",
				"type": "string"
			}
		],
		"name": "ajouterCommentaire",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_tache",
				"type": "string"
			}
		],
		"name": "postuler",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_tache",
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
		"constant": true,
		"inputs": [
			{
				"name": "participant",
				"type": "address"
			}
		],
		"name": "estBanni",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_tache",
				"type": "string"
			}
		],
		"name": "validerLivraison",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_tache",
				"type": "string"
			},
			{
				"name": "_illustrateur",
				"type": "address"
			},
			{
				"name": "nbPoint",
				"type": "uint256"
			}
		],
		"name": "sanction",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_tache",
				"type": "string"
			}
		],
		"name": "indexDemande",
		"outputs": [
			{
				"name": "index",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_offre",
				"type": "string"
			}
		],
		"name": "ajouterOffreService",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_tache",
				"type": "string"
			},
			{
				"name": "_illustrateur",
				"type": "address"
			}
		],
		"name": "accepterOffre",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "participant",
				"type": "address"
			}
		],
		"name": "aBannir",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_tache",
				"type": "string"
			},
			{
				"name": "_hashUrl",
				"type": "bytes32"
			}
		],
		"name": "livraison",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "a",
				"type": "string"
			},
			{
				"name": "b",
				"type": "string"
			}
		],
		"name": "compareStrings",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_tache",
				"type": "string"
			}
		],
		"name": "reputationDemande",
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
		"constant": false,
		"inputs": [],
		"name": "inscription",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
]; 
let dapp = null;  

function dapp_is_on()
{
	return dapp !== null;
}

async function establish_dapp_connection()
{
	if (false == dapp_is_on())
	{
		try
		{
			let [address] = await ethereum.enable();
			const provider = new ethers.providers.Web3Provider(ethereum);
			const contract = new ethers.Contract(addressContrat, abiContrat, provider.getSigner());
			address = address.toLowerCase();
			dapp = { address, provider, contract };
			console.log("Dapp is connected.");
			
		}
		catch(err)
		{
			dapp = {};
			console.error(err);
		}
	}
}


async function listeDemandes(){

	await establish_dapp_connection();

	document.getElementById('listeDemandes').innerHTML = "";
	let i = 0;
	let list = "<ul>";

	while (true)
	{
		try
		{
			const demande = await dapp.contract.demandes(i);
			console.log(demande);
			list = '<li>  ${demande.tache} ${demande.reputationMin} ${demande.etatDemande} </li>'
			document.getElementById('listeDemandes').innerHTML += list;
			++i;
		}
		catch(err)
		{
			break;
		}
	}
	document.getElementById('listeDemandes').innerHTML +="</ul>";

}

