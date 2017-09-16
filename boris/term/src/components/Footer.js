import React, { Component } from 'react';
import './Footer.css';

/**
 * Footer
 * - status (connection, user)
 */
class Footer extends Component {
    render() {
        return (
            <div>
                <i className="fa fa-circle green"/>
                <span className="AppFooterTitle">
                    mollusk.boris.org
                </span>
            </div>
        );
    }
}

export default Footer;