import CommandParser from './CommandParser';

var registry = {
    help: {
        type: 'Help',
        icon: 'question-circle',
        aliases: [ '?' ]
    },
    echo: {
        type: 'Echo',
        icon: 'exchange'
    },
    table: {
        type: 'TestTable',
        icon: 'columns'
    }
};

var counter = 0;
var parser = new CommandParser();
var history = [];

function run(command) {
    var item = parser.parse(command);
    var type = registry[item.args[0]] || {};
    item.type = type.type || 'Unknown';
    item.icon = type.icon;
    item.id = counter++;
    return item;
}

function raw(text) {
    history.push(run({type: 'Raw', text}));
}

// Create some initial commands for testing
raw('help');
raw('table');

class CommandStore {
    constructor(props) {
        this.props = props;
        this.history = history;
        this.commands = history.slice(0);
        this.registry = registry;
    }

    execute(command) {
        const item = run(command);
        this.history.push(item);
        this.commands.push(item);
    }

}

export default CommandStore;