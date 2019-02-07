async function createMetaMaskDapp() {
 try {
   // Demande à MetaMask l'autorisation de se connecter
   const addresses = await ethereum.enable();
   const address = addresses[0]
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