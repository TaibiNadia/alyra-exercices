import React from 'react'

class Form extends React.Component {
   
  render() {

    return (
      <form ref={input => this.addForm = input} className="form-inline" onSubmit={(e) => {
        e.preventDefault()
        this.props.castProposedGood(this.newCat.value,this.newQuantite.value)}}>
        
        <div className='form-group'>
          <h5 >Nouveau  Don</h5>

          <select ref={input=>this.newCat = input} type="number"   className="form-control" id="newCatInput">
            <option value="1">PRODUIT FRAIS</option>
            <option value="2">FRUIT&LEGUME</option>
            <option value="3">VIANDE</option>
            <option value="4">VIENNOISERIE</option>
            <option value="5">SURGELE</option>
          </select> 
        </div>

        <div className ="form-group mx-sm-2">
          <label className ="sr-only">Quantité</label>
          <input ref={input=>this.newQuantite = input} type="number"  className="form-control" id="newQuantiteInput" placeholder="Quantité"/>
        </div>

        <button type="submit" className ="btn btn-primary">Proposer</button>
        <hr />
      </form>

    )
  }
}

export default Form
