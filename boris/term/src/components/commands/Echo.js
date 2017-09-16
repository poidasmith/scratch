import React, { Component } from 'react';

export default class Echo extends Component {
    render() {
        return (
            <div>
                <code>{this.props.command.args.slice(1).join(" ")}</code>
            </div>
        )
    }
}
