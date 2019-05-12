import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import Web3 from 'web3'
import TruffleContract from 'truffle-contract'
import foodsMarket from '../../build/contracts/foodsMarket.json'
import Content from './Content'
import 'bootstrap/dist/css/bootstrap.css'

class App extends React.Component {
  
  constructor(props) {
    super(props)
    this.state = {
      account: '0x0',
      goods: [],
      good:{id:0,
        categorie:0,
        quantite:0,},
      cat:["","PRODUIT FRAIS", "FRUIT&LEGUME", "VIANDE", "VIENNOISERIE", "SURGELE"],
      isSelected: false,
      loading: false,
      selecting: false,
      isSent:false,
      newGoodsCount:0,
      message:'',
      associations: [],
      bigStores: [],
      conventions: [],
      isBlackListed: false,
    }

    if (typeof web3 != 'undefined') {
      this.web3Provider = web3.currentProvider
    } else {
      this.web3Provider = new Web3.providers.HttpProvider('http://localhost:9545')
    }

    this.web3 = new Web3(this.web3Provider)

    this.foodsMarket = TruffleContract(foodsMarket)
    this.foodsMarket.setProvider(this.web3Provider)

    this.castSelectGood = this.castSelectGood.bind(this)
    this.watchEvents = this.watchEvents.bind(this)
    this.castSentGood = this.castSentGood.bind(this)
    this.castProposedGood = this.castProposedGood.bind(this)
    }

  componentDidMount() {
    console.log("Je suis dans componentDidMount.....")
    // TODO: Refactor with promise chain
    this.web3.eth.getCoinbase((err, account) => {
      this.setState({ account })
 
      this.foodsMarket.deployed().then((foodsMarketInstance) => {
      this.foodsMarketInstance = foodsMarketInstance
      //this.watchEvents()
      // Associations
        this.foodsMarketInstance.associationsCount().then((associationsCount) => {
          console.log('associationsCount......')
          console.log(associationsCount)
          for (var i = 1; i <= associationsCount; i++) {
            this.foodsMarketInstance.associations(i).then((association) => {
              console.log('assoc...........')
              console.log(association)
              const associations = [...this.state.associations] 
              associations.push({
                adrAssoc: association[0],
                titre: association[1],
                siege: association[2],
                statuts: association[3],
              });
              this.setState({ associations: associations })

            });
          }
        }
        )
        
        // bigStores
        this.foodsMarketInstance.bigStoresCount().then((bigStoresCount) => {
          for (var i = 1; i <= bigStoresCount; i++) {
            this.foodsMarketInstance.bigStores(i).then((bigStore) => {
              const bigStores = [...this.state.bigStores] 
              bigStores.push({
                adrBigStore: bigStore[0],
                nom: bigStore[1],
                siege: bigStore[2],
                surface: bigStore[3],
              });
              this.setState({ bigStores: bigStores })

            });
          }
        }
        )
        //goods
        this.foodsMarketInstance.goodsCount().then((goodsCount) => {
          console.log("goodsCount......")
          console.log(goodsCount)
          this.setState({ newGoodsCount:goodsCount.toNumber() })
          for (var i = 1; i <= goodsCount.toNumber(); i++) {
            this.foodsMarketInstance.goods(i).then((good) => {
              //verifier avant si element supprime du mapping
              console.log('good......')
              console.log(good)
            if(good[0].toNumber() != 0){  
              const goods = [...this.state.goods]
              const libCat = this.state.cat[good[1].toNumber()]

              //recuperer le nom du store
              const bigStores = [...this.state.bigStores]
              const adr = good[3].toString()

              var name = ''
              console.log('adrStore.....')
              console.log(adr)
              name = this.bigStoreName(adr)
              goods.push({
                id: good[0].toNumber(),
                categorie: libCat,
                quantite: good[2].toNumber(),
                bigStoreAddress: good[3].toString(),
                bigStoreName: name,
                dateDepot: good[4].toNumber(),
                assocAddress : good[5].toString()
                });

              this.setState({ goods: goods })
            }///////////  
            });
          }
       })
        //
        //conventions assoc ou store
        console.log('Je suis là.hahah.....')
        this.foodsMarketInstance.conventionsCount().then((conventionsCount) => {
          for (var i = 0; i < conventionsCount.toNumber(); i++) {
            this.foodsMarketInstance.conventions(i).then((convention) => {
              console.log('convention.....')
              console.log(convention)
              if(this.isBigStore(this.state.account) && convention[0] == this.state.account
                || this.isAssociation(this.state.account) && convention[1] == this.state.account){
                const conventions = [...this.state.conventions]
                conventions.push({
                  bigStore: convention[0], 
                  assoc: convention[1]
                });
                
                this.setState({ conventions: conventions })
                console.log('conventions....')
                console.log(this.state.conventions)
              }

            });  
            }
          })
        //
        // si blackliste 
    this.foodsMarketInstance.isBlackListed(this.state.account).then(blackListed => {
      if (blackListed){
        console.log('If black.....')
        this.setState({ isBlackListed: true })
      }
    })
    //
    this.setState({ loading: false })
      })
    })
  }
watchEvents() {
    // TODO: trigger event when good is selected is counted, not when component renders
    this.foodsMarketInstance.selectedGoodEvent({}, {
      fromBlock: 0,
      toBlock: 'latest'
    }).watch((error, event) => {
      this.setState({ selecting: false })
    })
  }

  castSelectGood(goodId) {
    // verifier si association   1
    console.log('je suis dans castSelectGood.....')
    var isAssoc= this.isAssociation(this.state.account);
    console.log('isAssoc...')
    console.log(isAssoc)

    //recuprer l adrStore et dateDepot pour la convention et delai 2
    const goods = [...this.state.goods]
    for(var i = 0; i <= this.state.newGoodsCount; i++){
        var good = goods[i]
        if(good.id === goodId){
            var bigStore = good.bigStoreAddress;
            var dateDepot = good.dateDepot;
            console.log(bigStore)
            console.log('datedepot.....')
            console.log(dateDepot)
            break;
          }
     }
    // verifier les délais  ??? 3
    var startTimeMill = (new Date()).getTime()
    var startTime = startTimeMill / 1000
    var delai = startTime - dateDepot;    //nbre de jours ecoules
    var delaiSelection = 691200  // 8 jours en secondes
    var delaiCorrect = false
    if (delai  <= delaiSelection){
      delaiCorrect = true; 
    }else{
      delaiCorrect = false;
    }
    console.log('delaiCorrect.....')
    console.log(delaiCorrect)

    // blacklistee 4
    console.log('this.state.isBlackListed')
    console.log(this.state.isBlackListed)
    const bL = this.state.isBlackListed
    console.log('bl....')
    console.log(bL)
    // a convention 5
    var wC = false
    const conventions = [...this.state.conventions]
    console.log('conventions...')
    console.log(conventions)

    for(var i = 0; i < conventions.length; i++ ){
      if(conventions[i].bigStore == bigStore){
        wC = true 
      }
    }
    
    console.log('wc et bl....')
    console.log(wC)
    console.log(bL)
    //this.setState({ selecting: true })  // me fait une pose !!!! à voir
  if (isAssoc && !bL  && wC && delaiCorrect ){  
     console.log('if..executeeeeeeeeeeeee....')
      this.foodsMarketInstance.selectedGood(goodId, { from: this.state.account }).then((result) =>
      this.setState({ isSelected: true })
    )
    }else {
      console.log('else.execut.....')
      console.log('Assoc bl wc delai')
      console.log(isAssoc)
      console.log(bL)
      console.log(wC)
      console.log(delaiCorrect)

      if(!isAssoc){
        this.setState({ message:'N est pas une Association'})
    }
      if(bL && isAssoc){
        this.setState({ message:'Cette Assoc est blacklistée'})
    }
    if(!wC && isAssoc && !bL){
      this.setState({ message:'Pas de convention entre votre association et le store'})
    }
      if(!delaiCorrect && isAssoc && !bL){
        this.setState({ message:'Les délais sont dépassés donrée avariée.....'})
    }
    }


    
  }

  castSentGood(goodId){
    var sentGood = this.state.goods.filter(_good => { return _good.id === goodId});
    // le store valide l'envoi 1
    var rightSender = false
    if (sentGood[0].bigStoreAddress == this.state.account){
      rightSender = true
    }
    // verifier les délais  2
    var startTimeMill = (new Date()).getTime() //milli
    var startTime = startTimeMill / 1000
    var delai = startTime - sentGood[0].dateDepot;    //nbre de jours ecoules
    var delaiSelection = 864000  // 10 jours en secondes
    var delaiCorrect = false
    if (delai  <= delaiSelection){
      delaiCorrect = true; 
    }else{
      delaiCorrect = false;
    }
    
    if(rightSender && delaiCorrect){
      //this.setState({message:''})

      //probleme ici
      const goods = this.state.goods.filter(_good => _good.id !== goodId);
      console.log('goods Modifiees......')
      console.log(goods)
      this.setState({ goods: goods})  
      console.log('goods dans state....')
      console.log(this.state.goods)
      console.log('goodId  avant envoi........')
      console.log(goodId)
      //this.setState({newGoodsCount: --this.state.newGoodsCount})  //decrementer le nb de goods
      this.foodsMarketInstance.sentGood(goodId, { from: this.state.account })



    }else{
      if(!delaiCorrect){
        this.setState({ message:'Delai de livraison expiré'})
     }
     if(!rightSender && delaiCorrect){
        this.setState({ message:'N est pas le bon store'})
     }
    }
  }

  castProposedGood(newCat, newQuantite){
    alert("je suis dans castProposedGood.....")
    console.log('newCat')
    console.log(newCat)
    console.log('newQuantite')
    console.log(newQuantite)
    this.setState({newGoodsCount: ++this.state.newGoodsCount})
    const libCategorie = this.state.cat[newCat]
    const nomStore = this.bigStoreName(this.state.account)
    console.log('nom......')
    console.log(nomStore)
    const newGood = {id:this.state.newGoodsCount,
      categorie: libCategorie,
      quantite: Number(newQuantite),
      bigStoreAddress: this.state.account,
      bigStoreName: nomStore,
      assocAddress: "0x0000000000000000000000000000000000000000",
    };

    console.log('newGood')
    console.log(newGood)

    const newGoods = [...this.state.goods];
    newGoods.push(newGood);
    console.log('newGoods.....')
    console.log(newGoods)
    newQuantite !== '' && this.setState({ goods: newGoods })
    //this.addForm.reset();  ne marche pas
    //dans la dapp
    if (newQuantite !== ''){
      const quant = Number(newQuantite)
      this.foodsMarketInstance.proposedGood(newCat, quant, { from: this.state.account })
    }
  }

  isBigStore(targetAdr){
    const bigStores = [...this.state.bigStores]

    console.log('bigStores.....')
    console.log(bigStores)

    for (var i = 0; i < bigStores.length; i++) {

      console.log('je suis dans le for.....')
      var bigS = bigStores[i]
      var addressBigS = bigS.adrBigStore.toString()
      if(addressBigS.localeCompare(targetAdr) == 0){
          console.log('je suis dans if...')
          return true;
          } 
    }
    return false;
  }

  isAssociation(targetAdr){
    const associations = [...this.state.associations]

    console.log('associations.....')
    console.log(associations)

    for (var i = 0; i < associations.length; i++) {

      console.log('je suis dans le for.....')
      var asso = associations[i]
      var addressAssoc = asso.adrAssoc.toString()
      if(addressAssoc.localeCompare(targetAdr) == 0){
          console.log('je suis dans if...')
          return true;
          } 
    }
    return false;
  }

  bigStoreName(storeAdr){
    const bigStores = [...this.state.bigStores]
    for(var i = 0; i < bigStores.length; i++){
                var bigStore = bigStores[i]
                if(bigStore.adrBigStore === storeAdr){
                  name = bigStore.nom
                  return name
                }
              }
  }
  
  render() {
    return (
      <div className='row'>
        <div className='col-lg-12 text-center' >
          <h1>Liste Marchandises</h1>
          <br/>
          

            { this.state.loading || this.state.selecting
            ? <p className='text-center'>Loading...</p>
            : <Content
                account={this.state.account}
                message={this.state.message}
                goods={this.state.goods}
                good={this.state.good}
                isSelected={this.state.isSelected}
                castSelectGood={this.castSelectGood}
                castSentGood={this.castSentGood}
                castProposedGood={this.castProposedGood} />
               
          }

        </div>
      </div>
    )
  }
}

ReactDOM.render(
   <App />,
   document.querySelector('#root')
)
