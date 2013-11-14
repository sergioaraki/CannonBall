var io = require('socket.io').listen(8082);
var cannon_socket_id;
var flag_socket_id;
var distancia;

io.sockets.on('connection', function (socket) {
  
  socket.emit('ready', 'Server ready');
  
  //Listen for cannon to connect
  socket.on('cannon', function (data) {
    cannon_socket_id = socket.id;
    console.log('cannon app connected');
  });

  //Listen for flag to connect
  socket.on('flag', function (data) {
    flag_socket_id = socket.id;
    distancia = Math.floor((Math.random()*1000)+10);
    console.log('flag app connected');
    io.sockets.socket(flag_socket_id).emit('dist', distancia);	
  });
  
  socket.on('fire', function (data) {
    if(flag_socket_id != null){
		  var acerto = false;
		  if (data >= distancia-5 && data <= distancia+5) {
		  		acerto = true;
		  }
		  io.sockets.socket(flag_socket_id).emit('fire', acerto);
		  io.sockets.socket(cannon_socket_id).emit('result', acerto);	
		  console.log('flag app is connected');
    }else{
		  console.error('flag app is not connected yet');
    }
  });
});