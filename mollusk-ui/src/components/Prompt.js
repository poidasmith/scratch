import React, { Component } from 'react';
import './Prompt.css';

function parseCommand(command) {
    return {
        type: 'Raw',
        text: command
    }
}

export default class Prompt extends Component {

    constructor(props) {
        super(props);
        this.state = {
            commandText: '',
            prompt: 'Enter commands here >',
            currentDirectory: ''
        };
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.setFocus = this.setFocus.bind(this);
    }

    handleChange(ev) {
        this.setState({ commandText: ev.target.value });
    }

    handleSubmit(ev) {
        ev.preventDefault();
        if (this.props.onCommand && this.state.commandText) {
            this.props.onCommand(parseCommand(this.state.commandText));
        }
        this.setState({ commandText: '' });
    }

    setFocus() {
        this.input.focus();
    }

    render() {
        if (this.props.hidden)
            return null;

        return (
            <div className="Prompt">
                {this.state.prompt}
                <form onSubmit={this.handleSubmit}>
                    <input
                        className="Input"
                        ref={input => this.input = input}
                        type="text"
                        value={this.state.commandText}
                        onChange={this.handleChange} />
                </form>
            </div>
        );
    }
}

