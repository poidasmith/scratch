import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import './Footer.css';
import Icon from './Icon';
import Button from './Button';

export default class Footer extends Component {

    constructor(props) {
        super(props);
    }

    componentDidMount() {
    }

    render() {
        return (
            <div className="Footer">
                <div className="FooterLeft">
                    <span className="SpacerLeft" />
                    <Button icon="code-fork" text="master*" />
                    <span className="SpacerLeft" />
                    <Button icon="refresh" />
                </div>
                <div className="FooterRight">
                    <Button text="Ln 26, Col 42" />
                    <span className="SpacerRight" />
                    <Button text="Spaces: 4" />
                    <span className="SpacerRight" />
                    <Button text="UTF-8" />
                    <span className="SpacerRight" />
                    <Button text="CRLF" />
                    <span className="SpacerRight" />
                    <Button text="Javascript" />
                    <span className="SpacerRight" />
                </div>
            </div>
        );
    }
}