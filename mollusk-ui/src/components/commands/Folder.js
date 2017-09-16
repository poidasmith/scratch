import React, { Component } from 'react';

/**
 * Display a folder as a tree
 * - filterable
 * - collapse nodes
 * - live updates
 */
export default class Folder extends Component {
    render() {
        return (
            <div>
                <code>{this.props.command.args.slice(1).join(" ")}</code>
            </div>
        )
    }
}
