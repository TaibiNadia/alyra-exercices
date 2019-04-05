import React from 'react'

class Form extends React.Component {
   
  render() {

    return (
      <form ref={input => this.addForm = input} className="form-inline" onSubmit={(e) => {
        e.preventDefault()
        this.props.castProposedGood(this.newCat.value,this.newQuantite.value)}}>

        <div className='form-group'>
        <label className="sr-only" htmlFor="newGoodInput">Ajouter Marchandise</label>
        <label>Categorie: </label>
        <select ref={input=>this.newCat = input} type="number"   className="form-control1" id="newCatInput">
          <option value="1">PRODUIT FRAIS</option>
          <option value="2">FRUIT&LEGUME</option>
          <option value="3">VIANDE</option>
          <option value="4">VIENNOISERIE</option>
          <option value="5">SURGELE</option>
         </select>
         <label>Quantité: </label>
        <input ref={input=>this.newQuantite = input} type="number"  className="form-control2" id="newQuantiteInput"/>
        </div>

        <button type='submit' className='btn btn-primary'>Ajouter</button>
        <hr />
      </form>

    )
  }
}

export default Form
