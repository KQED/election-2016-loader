var express = require('express'),
    app = express(),
    util  = require('util'),
    path = require('path'),
    helmet = require('helmet'),
    exec = require('child_process').exec,
    FILE_PATH = process.env.FILE_PATH || '',
    PORT = process.env.PORT || 8000;

app.use(helmet());

app.post('/initialize', function(req, res){
  res.send('working on it');

  exec('source ' + FILE_PATH + 'init.sh',
    function (error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log('exec error: ' + error);
      }
  });  
});


app.post('/getResults', function(req, res) {
  res.send('working on it');

  exec('source ' + FILE_PATH + 'results.sh',
    function (error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log('exec error: ' + error);
      }
  });
});

var server = app.listen(PORT, function(){

  console.log('Server listening on port ' + PORT);

});
