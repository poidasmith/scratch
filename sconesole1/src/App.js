import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import './App.css';

import Editor from './Editor';
import Footer from './Footer';

export default class App extends Component {

  render() {
    return (
      <div className="App">
        <div className="AppHeader">
          <h2>Config</h2>
          <p>Config management is a thing? Yes, it is.</p>
        </div>
        <div className="AppBody">
          <Link to="/config/blah">Blah</Link>
        </div>
        <div className="AppFooter">
          <Footer />
        </div>
      </div>
    );
  }
}

