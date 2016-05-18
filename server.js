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

app.get('/sosStateSenate', function(req, res){
  
  res.contentType('application/xml');
  //won't work unless file exists (must run results.sh to populate)
  res.sendFile(path.join(__dirname, './sos/X16DP510_1200v7.xml'));
  
});

app.get('/sosStateAssembly', function(req, res){
  
  res.contentType('application/xml');
  //won't work unless file exists (must run results.sh to populate)
  res.sendFile(path.join(__dirname, './sos/X16DP510_1300v7.xml'));
  
});

var server = app.listen(PORT, function(){

  console.log('Server listening on port ' + PORT);

});
