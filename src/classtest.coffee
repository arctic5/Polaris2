constants = require("./constants.js")
net = require('net');
buffer = require('buffer');
__entities = [];

# i got lazy :D
# run at 30 "frames" per second because gg2 networking still runs on 30 fps
requestAnimationFrame = (() ->
    return (callback) ->
        setTimeout(callback, 1000 / 30);
)();

class Entity
    constructor: (x = 0, y = 0) ->
        __entities.push(this);
        @x = x;
        @y = y;
        @vspeed = 0;
        @hspeed = 0;
    step: (delta)->
        @delta = delta;
    destroy: () ->
         __entities.splice(__entities.indexOf(this), 1);

class GameServer extends Entity
    constructor: () ->
        super();
        @tcpListener = net.createServer((joiningPlayer) -> 
            console.log('client connected');
            joiningPlayer.on('data', (data) -> 
                console.log('got %d bytes of data', data.length);
                message = data.toString();
            );
            joiningPlayer.on('error', () -> 
                console.log('some sort of error');
            );
        );

        tcpListener.listen({
            host: 'localhost',
            port: 8190
        });

class Player extends Entity
    constructor: () ->
        super();
        @object = -1;
        @team = constants.TEAM_SPECTATOR;
        @class = constants.CLASS_SCOUT;
        @socket = -1;
        @name = "";
        @kicked = false;
    step: () ->
        console.log(@class);


main = () ->
    requestAnimationFrame(main);
    now = new Date().getTime();
    delta_time = now - (time || now);
    for i in __entities
        i.step(delta_time);
    time = now;
console.log("Polaris: A Distant Star");
main();