<script type="text/javascript">

  //metamask
  const addressContrat = "0xb02d380e1d9155ff1f03756daf7a52fcc1312a9d"; 
  abiContrat = [
  {
    "constant": true,
    "inputs": [],
    "name": "nbCartes",
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
    "inputs": [
      {
        "name": "s",
        "type": "string"
      }
    ],
    "name": "ajouterCarte",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "ind",
        "type": "uint256"
      }
    ],
    "name": "recuperer",
    "outputs": [
      {
        "name": "",
        "type": "bytes32"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  }
]

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

//IPFS 
const ipfs = window.IpfsHttpClient('localhost','5001')
//const ipfs = new Ipfs({repo:'ipfs-'+ Math.random() })
let derniereImage
console.log("***Ipfs****",ipfs)
  
function charger(){
  if(dapp_is_on == false){establish_dapp_connection()};
  let image = document.getElementById('fichierImage').files[0]
  const reader = new FileReader();
  reader.readAsArrayBuffer(image);
  reader.onloadend = function(){
    ipfs.add(new ipfs.types.Buffer.from(reader.result)).then(r=>{
      derniereImage = r[0].hash
      console.log("Envoi image à la dapp....");
      const tx  = await provider.getSigner().ajouterCarte(derniereImage)
          display_message("Transaction creee")

          try
          {
            tx.wait().then(() =>
              {
                display_message("Image ajoutee à la Dapp: " + hash)
              }
            )
          }
          catch(err)
          {
            display_error(err)
          }

      document.getElementById('lien').href="http://127.0.0.1:8080/ipfs"+r[0].hash
      document.getElementById('lien').innerHTML = r[0].hash
    })
  	}
  }

function recupererDerniereImage (){
    ipfs.cat(derniereImage).then(res=>{
   document.getElementById('imgtxt').innerHTML = res.toString('base64');
   document.getElementById('imageRecupere').src = "data:image/jpg;base64,"+ res.toString('base64');
    })
}

function recupererImage (){
    if(dapp_is_on == false){establish_dapp_connection()};
    const nbCartes  = await provider.nbCartes();
    nb = Math.min(10,nbCartes);
    for (i= 0; i<nb;i++){
      const imageHash = await provider.recupererCarte(i); 
      ipfs.cat(imageHash).then(res=>{
      document.getElementById('imgtxt').innerHTML = res.toString('base64');
      document.getElementById('imageRecupere').src = "data:image/jpg;base64,"+ res.toString('base64');
      })
    }

}   
</script>  