zlib = require('zlib');
fs = require('fs');

class gg2MapReader
    constructor: () ->
        @KEYWORD = "Gang Garrison 2 Level Data";
        @ENTITIES = "{ENTITIES}";
        @ENDENTITIES = "{END ENTITIES}";
    __construct: (map) ->
        @map = map;
        @data = getLevelData();
    isGG2Map: () ->
        return (@data isnt '');
    getLevelData: () ->
        @mapstr = fs.readFileSync(@map);
        @pos = @mapstr.indexOf(@KEYWORD);
        if (@pos is false)
            return "";
        @len = 

