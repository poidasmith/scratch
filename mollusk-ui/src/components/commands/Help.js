import React, { Component } from 'react';

/**
 * Help on the application
 * - provide an overview
 * - render table of commands (source from command registry)
 */
export default class Help extends Component {
    render() {
        return (
            <div className="CommandHelp">
                <h3>Welcome to Mollusk</h3>
                Mollusk is a web-based terminal, which displays command/process output as interactive widgets
                <p>
                </p>
                <p>
                    Frequently used commands
                </p>
                <table>
                    <tbody>
                        <tr>
                            <th>Command</th>
                            <th>Description</th>
                        </tr>
                        <tr>
                            <td>help</td>
                            <td>Show this message</td>
                        </tr>
                        <tr>
                            <td>clear</td>
                            <td>Clear the terminal</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        );

    }
}
