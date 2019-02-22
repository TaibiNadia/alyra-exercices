async function ModifierEtat(tx){
  tx.colis.etat = newEtat;
  let assetRegistry = await getAssetRegistry('fr.poste.colis');
    await assetRegistry.update(tx.colis);
}
async function Deplacement(tx){
  tx.colis.destinataire = tx.newAddress;
	let assetRegistry = await getAssetRegistry('fr.laposte.Colis');
	await registre.update(tx.colis);
}
async function Distribution(tx){
  if (tx.colis.destinataire = tx.newAddress){
     await Deplacement(tx)}
  tx.colis.destinataire = tx.newAddress;
  let event = getFactory().newEvent('fr.laposte', 'DeplacementEvent');
    event.colis = tx.colis;
    //event.arrivee = tx.arrivee;
    emit(event);
}

async function Transport(tx){
  if(tx.colis.destinataire != tx.newAddress){
  await Deplacement(tx);}
}