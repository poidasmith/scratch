import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import FontAwesome from 'react-fontawesome';
import './Button.css';

export default class Button extends Component {

    render() {
        const icon = this.props.icon ? <FontAwesome name={this.props.icon} /> : <div />;

        return (
            <button className="Button" onClick={this.props.onClick}>
                {icon}
                <span className="SpacerLeft FontSmaller">
                    {this.props.text}
                </span>
            </button>
        );
    }
}