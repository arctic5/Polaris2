echo "Building..."
echo $(coffee -c constants.coffee)
echo $(coffee -c game.coffee)
echo $(coffee -c engine.coffee)
echo $(coffee -c main.coffee)