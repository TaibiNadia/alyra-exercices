import React from 'react'

class Table extends React.Component {

  
  render() {
    return (
      <div className="content">
      {
        this.props.message !== '' && <p className="message text-danger">{this.props.message}</p>
      }
      <table className='table'>
        <thead>
          <tr>
            
            <th>Categorie</th>
            <th>Quantité</th>
            <th>Grande Surface</th>
          </tr>
        </thead>
        <tbody >
          {this.props.goods.map((good) => {
            return(
              <tr key={good.id}>
                <td>{good.categorie}</td>
                <td>{good.quantite}</td>
                <td>{good.bigStoreName}</td>

                {good.assocAddress !== "0x0000000000000000000000000000000000000000" 
                ? <td><button type="button" disabled className='btn btn-primary'>Choisir</button></td>
                : <td><button onClick={(event) => {
                event.preventDefault()
                this.props.castSelectGood(good.id)
                }} type="button" className='btn btn-primary'>Choisir</button></td>}

                <td><button onClick = {(event) => {
                event.preventDefault()
                this.props.castSentGood(good.id)
                }} type="button" className='btn btn-success'>Livrer</button></td>
              </tr>
            )
          })}
        </tbody>
      </table>
      </div>
    )
  }
}

export default Table
