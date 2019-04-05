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
      
    }

    if (typeof web3 != 'undefined') {
      this.web3Provider = web3.currentProvider
    } else {
      this.web3Provider = new Web3.providers.HttpProvider('http://localhost:9545')
    }

    this.web3 = new Web3(this.web3Provider)

    //this.election = TruffleContract(Election)
    //this.election.setProvider(this.web3Provider)

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
      console.log("foodsMarketInstance..............")
      console.log(this.foodsMarketInstance)
      //this.watchEvents()

        
        console.log("Je vais executer foodsMarketInstance.....")
        this.foodsMarketInstance.goodsCount().then((goodsCount) => {
          console.log("goodsCount......")
          console.log(goodsCount)
          this.setState({ newGoodsCount:goodsCount.toNumber() })
          for (var i = 1; i <= goodsCount.toNumber(); i++) {
            this.foodsMarketInstance.goods(i).then((good) => {
              const goods = [...this.state.goods]
              
              const libCat = this.state.cat[good[1].toNumber()]
              goods.push({
                id: good[0].toNumber(),
                categorie: libCat,
                quantite: good[2].toNumber()
                });
              this.setState({ goods: goods })
              
            });
          }



        })
        
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
    this.setState({ selecting: true })
    this.foodsMarketInstance.selectedGood(goodId, { from: this.state.account }).then((result) =>
      this.setState({ isSelected: true })
    )
  }
  castSentGood(goodId){
    //supprimer de ma dapp
    /*this.foodsMarketInstance.sentGood(goodId, { from: this.state.account }).then((result) =>
      this.setState({ isSent: true })
    )*/
    //supprimer ds state pour l affichage
    const newGoods = this.state.goods.filter(_good =>{
      return _good.id !== goodId;
    });
    this.setState({
      goods: [...this.state.newGoods]
    })

  }

  castProposedGood(newCat, newQuantite){
    alert("je suis dans castProposedGood.....")
    console.log('newCat')
    console.log(newCat)
    console.log('newQuantite')
    console.log(newQuantite)
    this.setState({newGoodsCount: ++this.state.newGoodsCount})
    const libCategorie = this.state.cat[newCat]
    const newGood = {id:this.state.newGoodsCount,
      categorie:libCategorie,
      quantite:Number(newQuantite),
    };

    console.log('newGood')
    console.log(newGood)

    const newGoods = [...this.state.goods];
    newGoods.push(newGood);
    this.setState({ goods: newGoods })

    //dans la dapp
    const quant = Number(newQuantite)
    this.foodsMarketInstance.proposedGood(newCat, quant, { from: this.state.account })

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
                goods={this.state.goods}
                good={this.state.good}
                isSelected={this.state.isSelected}
                castSelectGood={this.castSelectGood}
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
