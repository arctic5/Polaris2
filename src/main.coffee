engine = require("./engine.js")
game = require("./game.js")

# i got lazy :D
# run at 30 "frames" per second because gg2 networking still runs on 30 fps
requestAnimationFrame = (() ->
    return (callback) ->
        setTimeout(callback, 1000 / 30)
)()

main = () ->
    requestAnimationFrame(main)
    now = new Date().getTime()
    delta_time = now - (time || now)
    for i in engine.__entities
        i.step(delta_time)
    time = now
console.log("Polaris: A Distant Star")
new game.Player()
main()