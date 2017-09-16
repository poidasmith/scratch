import React, { Component } from 'react';
import ReactDataGrid from 'react-data-grid';
import './TestTable.css';

/**
 * Testing react-grid table to show data
 */
class TestTable extends Component {

    constructor(props) {
        super(props);
        this.columns = [
            { key: 'id', name: 'ID' },
            { key: 'title', name: 'Title' },
            { key: 'timestamp', name: 'Timestamp' },
        ];
        this.rows = [
            {
                id: '1', title: 'Test table'
            },
            {
                id: '2', title: 'Row again'
            },
            {
                id: '3', title: 'More of this'
            },
            {
                id: '4', title: 'More of this'
            },
            {
                id: '5', title: 'More of this'
            },
            {
                id: '6', title: 'More of this'
            },
            {
                id: '7', title: 'More of this'
            }
        ];
        this.getRow = this.getRow.bind(this);
    }

    getRow(index) {
        return this.rows[index];
    }

    render() {
        return (
            <div className="CommandTable">
                <ReactDataGrid
                    columns={this.columns}
                    rowGetter={this.getRow}
                    rowsCount={this.rows.length}
                    minHeight={200} />
            </div>
        )
    }
}

export default TestTable;