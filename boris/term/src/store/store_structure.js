

// Example layout of the app

var layout = {

    // model of location; parsed from the url, cookies, html5 history
    location: {
        path: '/blah/qwer',
        hash: '/tere/asdf',
        route: 'id of route?',
        authToken: {
            something: 'here?'
        },
    },

    // user, permissions, preferences
    // view layout (retrieved)
    session: {
        // 
        user: {
            id: 'blah',
            name: 'Mr Blah',
            title: 'Senior Blah'
        },
        permissions: [

        ],
        preferences: {

        },
        layout: {

        }
    },

    // web-socket state
    // async queries etc
    // subscriptions?
    // logging?
    // statistics
    communication: {
        socket: {
            uri: 'ws://data.boris.org:5001/session/sid',
            status: 'open' // close etc
        },
        subscriptions: {

        },
        queries: {
            
        },
        logging: {
            // level
            // ?
        },
        metrics: {
            // capture here? or just cache before sending to server?
        }
    },

    // focus, form entry
    // widget (transient settings)
    control: {
        // widget/viewer collection
        widgets: [
            {

            }
        ],
    },

    // the application data
    data: {

        // sessions contain a collection runs
        sessions: [
            {
                id: '',
                type: 'session',
                layout: '', // should this be in control?
                runs: [ 'run.1', 'run.5' ]
            }
        ],


        // runs are a record of an execution of a command
        runs: [
            {
                id: 'run.1',
                type: 'run',
                command: 'dir',
                current: {
                    type: 'run.item',
                    args: ['/where'],
                    output: 'point.id' // refers to an output
                },
                history: [ 'run.10', 'run.11' ], // points to previous/other runs
            },
        ],

        // outputs store the result/output of a command
        outputs: [
            {
                id: 'output.1',
                type: 'output'
            }
        ]
    },

};