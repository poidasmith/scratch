import React, { Component } from 'react';
import Command from './Command';
import './Commands.css';

class Commands extends Component {
    constructor(props) {
        super(props);
        this.state = {
        }
    }

    render() {

        const commands = this.props.commands.map(command =>
            <Command key={command.id} command={command} />
        );

        return (
            <div className="Commands">
                {commands}
            </div>
        );

    }
}

export default Commands;