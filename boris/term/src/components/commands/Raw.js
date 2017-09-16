import React, { Component } from 'react';

/**
 * Show raw output of a command
 */
export default class Raw extends Component {
    render() {
        return (
            <div>
                Raw command data: <code>{JSON.stringify(this.props.command)}</code>
            </div>
        );

    }
}
