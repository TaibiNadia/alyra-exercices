import React from 'react'

class Table extends React.Component {

  
  render() {
    return (
      <table className='table'>
        <thead>
          <tr>
            <th>#</th>
            <th>Categorie</th>
            <th>Quantité</th>
          </tr>
        </thead>
        <tbody >
          {this.props.goods.map((good) => {
            return(
              <tr key={good.id}>
                <th>{good.id}</th>
                <td>{good.categorie}</td>
                <td>{good.quantite}</td>

                <td><button onClick={(event) => {
        event.preventDefault()
        this.props.castSelectGood(this.goodId)
      }} type="button" className='btn btn-primary'>Choisir</button></td>

                <td><button onClick = {(event) => {
        event.preventDefault()
        this.props.castSentGood(this.good.id)
      }} type="button" className='btn btn-success'>Livrer</button></td>
              </tr>
            )
          })}
        </tbody>
      </table>
    )
  }
}

export default Table
