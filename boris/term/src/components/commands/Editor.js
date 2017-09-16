import React, { Component } from 'react';

/**
 * A simple editor for remote "files"
 */
export default class Editor extends Component {
    render() {
        return (
            <div>
                <code>{this.props.command.text}</code>
            </div>
        )
    }
}
