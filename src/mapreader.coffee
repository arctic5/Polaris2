zlib = require('zlib');
fs = require('fs');

unpack: (str) ->
    b = new ArrayBuffer(str.length*8);
    ba = new Float64Array(b);
    len = str.length;
    for i in len
        ba[i] = str.charCodeAt(i);
    return b;


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
        @len = unpack(@mapstr.substring(@pos - 8, @pos - 4))[1] - @KEYWORD.length;
        @leveldata = @mapstr.substring(@pos + @KEYWORD.length + 2, @len);


