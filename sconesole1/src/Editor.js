import React, { Component } from 'react';
import CodeMirror from 'react-codemirror';
import 'codemirror/lib/codemirror.css';
import 'codemirror/mode/javascript/javascript';
import 'codemirror/theme/lesser-dark.css'
import './Editor.css';

export default class Editor extends Component {

    constructor(props) {
        super(props);
        this.state = {
            code: "var t = 'test';",
            options: {
                mode: 'javascript',
                theme: 'lesser-dark',
                lineNumbers: true,
                autofocus: true
            }
        };

        this.onChange = this.onChange.bind(this);
    }

    onChange(newValue, e) {
        console.log('onChange', newValue, e);
        this.setState({
            code: newValue
        })
    }

    render() {
        return (
            <CodeMirror
                options={this.state.options}
                autoFocus={true}
                value={this.state.code}
                onChange={this.onChange} />
        );
    }
}