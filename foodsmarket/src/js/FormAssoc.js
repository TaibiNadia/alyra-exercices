import React from 'react'

class FormAssoc extends React.Component {
  
  constructor(props){
  	super(props);
  	this.state ={
  	assocs:[],
  	message: ''
  }

  }

  addAssoc(e){
  	e.preventDefault();
  	const {assocs} = this.state;
  	const newAssoc = this.newAssoc.value;
  	const isOnList = assocs.includes(newAssoc);  //verifie si la nouvelle assoc est deja ds assocs renvoe true ou false
  	
  	if(isOnList){

  		this.setState({
  			message: 'Cet item est deja dans la liste'
  		})

  	} else {
  		newAssoc !== && this.setState({
  		assocs: [...this.state.assocs, newAssoc]
  		message: ''
  	})
  	}
  	

  	this.addForm.reset();
  }

  removeAssoc(assoc){
  	const newAssocs = this.state.assocs.filter(_assoc =>{
  		return _assoc !== assoc;
  	});
  	
  	this.setState({
  		assocs: [...newAssocs]
  	})
  }

  render() {
  	const {assocs, message} = this.state;
    return (
    	<div>
    	<header>
    	<h1>Associations</h1>

		<form ref={input => this.addForm = input} className="form-assoc" onSubmit={(e) => {this.addAssoc(e)}}>
		<div className="form-group">
			<label className="sr-only" htmlFor="newAssocInput" Add new Assoc</label>
			<input ref={input => this.newAssoc = input}  type="text" placeholder="Bread" className="form-control" id="newAssocInput" />
        </div>
        <button type="submit" className="btn btn-primary">Add</button>
		</form>
		</header>
		<div className = "content">
		{
			message != '' && <p className="massage text-danger">message</p>
		}
		<table className="table">
		<caption>Associations</caption>
		<thead>
		<tr>
			<th>Titre</th>
			<th>Siege</th>
			<th>Statuts</th>
		</tr>
		</thead>
		<tbody>
			{
				assocs.map(assoc => {
					return (
						<tr key={assoc}>
						 <th scope="row"></th>
						 <td>{assoc}</td>
						 <td className="text-right">
						 <button onClick={(e) => this.removeAssoc(assoc)} type="button" className="btn btn-default btn-sm">
						 </td>
						)
				})
			}


		</tbody>
		</table>

		)}