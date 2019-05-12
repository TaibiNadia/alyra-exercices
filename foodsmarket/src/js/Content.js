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
        

        <Table goods={this.props.goods} 
           message={this.props.message}
           castSelectGood={this.props.castSelectGood}
           castSentGood={this.props.castSentGood}/>
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
