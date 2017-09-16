import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';

import App from './App';
import Config from './Config';
import NotFound from './NotFound';

export default class Routes extends Component {
    render() {
        return (
            <Router>
                <Switch>
                    <Route exact path="/" component={App} />
                    <Route exact path="/config/:file" component={Config} />
                    <Redirect from="/old-path" to="new-path" />
                    <Route component={NotFound} />
                </Switch>
            </Router>
        );
    }
}
