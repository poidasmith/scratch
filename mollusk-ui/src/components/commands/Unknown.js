import React, { Component } from 'react';

/**
 * If we don't understand a command we'll show this widget
 * TODO
 * - link to help
 * - neural net/ml to suggest issues
 */
export default class Unknown extends Component {
    render() {
        return (
            <div>
                Unknown command: <code>{this.props.command.args[0]}</code>
            </div>
        );

    }
}
