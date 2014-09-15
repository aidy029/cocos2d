
require("config")
require("framework.init")

-- define global module
game = {}

function game.startup()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")

    game.enterMenuScene()
end

function game.exit()
    CCDirector:sharedDirector():endToLua()
end

function game.enterMainScene()
    display.replaceScene(require("scenes.MainScene").new(), "fade", 0.6, display.COLOR_WHITE)
end

function game.enterMenuScene()
    display.replaceScene(require("scenes.MenuScene").new(), "fade", 0.6, display.COLOR_WHITE)
end