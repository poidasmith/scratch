
/**
 * Parses command text into a structure
 */
class CommandParser {
    constructor(props) {
        this.props = props;
        this.parse = this.parse.bind(this);
    }

    parse(command) {
        command.args = command.text.match(/\w+|"[^"]+"/g);
        return command;
    }
}

export default CommandParser;