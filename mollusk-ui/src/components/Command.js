import React, { Component } from 'react';
import './Command.css';

import Raw from './commands/Raw';
import Help from './commands/Help';
import Unknown from './commands/Unknown';
import Echo from './commands/Echo';
import TestTable from './commands/TestTable';

const Registry = {
    Help,
    Echo,
    Raw,
    TestTable
}

class CommandCtrl extends Component {
    render() {
        return (
            <div/>
        );
    }
}

export default class Command extends Component {
    constructor(props) {
        super(props);
        this.state = {
        }
    }

    render() {
        const Item = Registry[this.props.command.type] || Unknown;
        return (
            <div className="Command">
                <div className="CommandTitle">
                    <i className={'fa fa-' + this.props.command.icon}/>
                    <span className="CommandTitleHeader">
                        {this.props.command.args[0]}
                    </span>
                    <CommandCtrl/>
                </div>
                <div className="CommandContainer">
                    <Item command={this.props.command} />
                </div>
            </div>
        );
    }
}

