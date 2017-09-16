import React, { Component } from 'react';
import './Header.css';

/**
 * Main app bar header, showing
 * - context, saved session 
 * - session switcher/tabs
 * - create new session
 */
export default class Header extends Component {

    constructor(props) {
        super(props);

        this.defaultProps = {
            title: 'Mollusk - terminal'
        }
    }

    render() {
        return (
            <div>                
                <i className="fa fa-bars"/>
                <span className="AppHeaderTitle">
                    Untitled*                
                </span>
            </div>
        );
    }
}

