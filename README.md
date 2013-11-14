CannonBall
==========

Remix del clásico Cannon Ball para interactuar entre 2 dispositivos.

La intención de esta demo es mostrar como interactuar entre 2 dispositivos via socket mediante un servidor
y utilizar sensores del teléfono como control.

Para poder ejecutar este proyecto se requiere un servidor con node.js (http://nodejs.org/).
Donde se instale nodejs, se debe crear un directorio en el cual se debe ubicar el archivo que se encuentra
en este respositorio en la carpeta "Server" de nombre "server.js".
En ese directorio ejecutar desde la consola de comandos: npm install socket.io
Y finalmente para iniciar el servidor: node server.js

En el proyecto Cascades que se encuentra en la carpeta "CannonBall" de este repositorio se debe actualizar
la dirección ip que figura en los archivos html ubicados en la carpeta "webview", "flag.html" y "cannon.html".
En ambos archivos se encuentra 2 veces una ip, hay que reemplazarla por la ip donde se esta ejecutando 
el servidor nodejs.

Correr la aplicación en 2 dispositivos, el primero selecciona "Bandera" y "Jugar" asi el servidor le asigna
una distancia aleatoria a la bandera, el segundo "Cañón" y "Jugar". El "Cañón" deberá acertar a la bandera
asignando la velocidad de salida inicial de la bala con el slider superior y el ángulo de disparo inclinando 
el dispositivo.



