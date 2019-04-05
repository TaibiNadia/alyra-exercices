import React from 'react'
import Table from './Table'
import Form from './Form'

class Content extends React.Component {
  constructor(props) { 
    super(props);
    
  }
  
  render() {

    return (
      <div>
        

        <Table goods={this.props.goods} />
        <hr/>
        <Form 
          good={this.props.good}
          castProposedGood={this.props.castProposedGood} />
        <p>Your account: {this.props.account}</p>
      </div>
    )
  }
}

export default Content
