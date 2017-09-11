import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import Editor from './Editor';
import Footer from './Footer';

export default class Config extends Component {

    constructor(props) {
        super(props);
        this.file = this.props.match.params.file;
    }

    componentDidMount() {
        document.title = '[Boris] - ' + this.file
    }

    render() {
        return (
            <div className="App">
                <div className="AppHeader">
                    <Link to="/">Home</Link>
                </div>
                <div className="AppBody">
                    <Editor />
                </div>
                <div className="AppFooter">
                    <Footer />
                </div>
            </div>
        );
    }
}