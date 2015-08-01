engine = require("./engine.js")
net = require('net')
buffer = require('buffer')
constants = require("./constants.js")

class exports.GameServer extends engine.Entity
    constructor: () ->
        super()
        @players = []
        @sockets = []
        @server = net.createServer((socket) -> 
            console.log('client connected')
            console.log(socket.remoteAddress)
            console.log(socket.remotePort)
            @joiningPlayer = new joiningPlayer()
            @joiningPlayer.socket = socket

            socket.on('data', (data) -> 
                console.log('got %d bytes of data', data.length)
                message = data.toString()
            )
        )
        @server.listen({
            host: 'localhost',
            port: 8190
        })
        @server.maxConnections = 48
        @server.on('error', () -> 
                console.log('some sort of server error occured ^_^')
        )

class exports.Player extends engine.Entity
    constructor: () ->
        super()
        @object = -1
        @team = constants.TEAM_SPECTATOR
        @class = constants.CLASS_SCOUT
        @socket = -1
        @name = ""
        @kicked = false

        # stat tracking array
        @stats[constants.KILLS] = 0
        @stats[constants.DEATHS] = 0
        @stats[constants.CAPS] = 0
        @stats[constants.ASSISTS] = 0
        @stats[constants.DESTRUCTION] = 0
        @stats[constants.STABS] = 0
        @stats[constants.HEALING] = 0
        @stats[constants.DEFENSES] = 0
        @stats[constants.INVULNS] = 0
        @stats[constants.BONUS] = 0
        @stats[constants.DOMINATIONS] = 0
        @stats[constants.REVENGE] = 0
        @stats[constants.POINTS] = 0

        # round stats
        @roundStats[constants.KILLS] = 0
        @roundStats[constants.DEATHS] = 0
        @roundStats[constants.CAPS] = 0
        @roundStats[constants.ASSISTS] = 0
        @roundStats[constants.DESTRUCTION] = 0
        @roundStats[constants.STABS] = 0
        @roundStats[constants.HEALING] = 0
        @roundStats[constants.DEFENSES] = 0
        @roundStats[constants.INVULNS] = 0
        @roundStats[constants.BONUS] = 0
        @roundStats[constants.DOMINATIONS] = 0
        @roundStats[constants.REVENGE] = 0
        @roundStats[constants.POINTS] = 0

        @timesChangedCapLimit = 0
        @lastKnownx = 0
        @lastKnowny = 0
        @humiliated = false
        @sentry = -1

        @rewards = {}
        @badges = []

class exports.JoiningPlayer extends engine.Entity
    constructor: () ->
        super()
        @socket = -1
        @mapDownloadBuffer = -1

        @STATE_EXPECT_HELLO = 1 # Hello message: 17 bytes (HELLO+UUID)
        @STATE_EXPECT_MESSAGELEN = 2 # 1 byte Message length header 
        @STATE_EXPECT_NAME = 3
        @STATE_EXPECT_PASSWORD = 4
        @STATE_CLIENT_AUTHENTICATED = 5
        @STATE_EXPECT_COMMAND = 6
        @STATE_CLIENT_DOWNLOADING = 7

        @state = @STATE_EXPECT_HELLO
        @expectedBytes = 17
        @lastContact = new Date().getTime() # To allow implementing a timeout
        @cumulativeMapBytes = 0
    serviceJoiningPlayer: () ->
        @socket.on('error', () => 
            console.log('some sort of error occured ^_^')
            @socket.destroy()
            @destroy()
        )
        # map downloads later
        # if (@state == @STATE_CLIENT_DOWNLOADING)
        #     @lastContact = new Date().getTime()

        if (!@socket.read(expectedBytes))
            return 0;
        @lastContact = new Date().getTime()
        @newState = -1

        switch (@state)
            when @STATE_EXPECT_HELLO
                @sameProtocol = socket.readUInt8(0) == @HELLO
