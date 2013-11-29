var io = require('socket.io').listen(8082);
var cannon_socket_id;
var flag_socket_id;

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
    console.log('flag app connected');
    if(cannon_socket_id != null){
    		io.sockets.socket(cannon_socket_id).emit('dist', data);	
     }else{
		  console.error('cannon app is not connected yet');
    }
  });
  
  socket.on('fire', function (data) {
    if(flag_socket_id != null){
		  io.sockets.socket(flag_socket_id).emit('fire', data);
    }else{
		  console.error('flag app is not connected yet');
    }
  });
});