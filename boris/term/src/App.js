import React, { Component } from 'react';
import './App.css';

import CommandStore from './services/CommandStore';

import Header from './components/Header';
import Commands from './components/Commands';
import Prompt from './components/Prompt';
import Footer from './components/Footer';


export default class App extends Component {

  constructor(props) {
    super(props);
    this.store = new CommandStore();
    this.state = {
      commands: this.store.commands
    };

    this.onCommand = this.onCommand.bind(this);
  }

  onCommand(command) {
    console.log('onCommand');
    console.log(command);
    this.store.execute(command);
    this.setState({
      commands: this.store.commands
    })
  }

  scrollToBottom() {
    var div = document.getElementById("AppBody");
    div.scrollTop = div.scrollHeight;
  }

  componentDidMount() {
    this.prompt.setFocus();
    this.scrollToBottom();
  }

  componentDidUpdate() {
    this.scrollToBottom();
  }

  render() {
    return (
      <div className="App">
        <div className="AppHeader">
          <Header />
        </div>
        <div id="AppBody" className="AppBody">
          <Commands commands={this.state.commands} />
        </div>
        <Prompt ref={input => this.prompt = input} onCommand={this.onCommand} />
        <div className="AppFooter">
          <Footer />
        </div>
      </div>
    );
  }
}
