#class that all objects inherit from

exports.__entities = []
class exports.Entity
    constructor: (x = 0, y = 0) ->
        exports.__entities.push(this)
        @x = x
        @y = y
        @vspeed = 0
        @hspeed = 0
    step: (delta)->
        @delta = delta
    destroy: () ->
         exports.__entities.splice(exports.__entities.indexOf(this), 1)