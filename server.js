// setup server for front developer purposes ONLY

// setup basic server on express
var express = require('express');
var path = require('path');
var app = express();

// app.get('/', function (req, res) {
//   res.send('Hello World!');
// });

// deliver files directly to the browser/serve public
app.use(express.static('public'));

// app.use('/static', express.static('public'));


app.get("/", function (req, res) {
  res.sendFile(path.join(public, "/index.html"));
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
