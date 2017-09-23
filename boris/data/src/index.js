import express from 'express';
import Redis from 'redis-promise';

const app = express();

const client = new Redis();
client.connect();

client.on('error', err => console.log('Error ' + err));

const port = process.env.PORT || 5001;
app.listen(port);

// Describe our server?
app.get('/', (req, res) => {

    res.json({});
});

// Grab the config file
app.get('/config/:file', (req, res) => {

    const item = {
        file: req.params.file,
        text: 'this is a test',
    }

    res.json(item);
});

// Save the file
app.post('/config/:file', (req, res) => {

});

console.log('Databoris is alive');