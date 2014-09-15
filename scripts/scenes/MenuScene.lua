
local BubbleButton = import("..views.BubbleButton")

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()
	audio.preloadSound("TapButtonSound.mp3")
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    -- display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)

    self.bg = display.newColorLayer(ccc4(0xff,0xff,0xff, 255)):addTo(self)

    self.startButton = BubbleButton.new({
        image = "bubble.png",
        x = display.cx,
        y = display.cy,
        sound = "TapButtonSound.mp3",
        prepare = function()
            self.menu:setEnabled(false)
        end,
        listener = function()
            game:enterMainScene()
        end,
    })

    self.menu = ui.newMenu({self.startButton})
    self:addChild(self.menu)
end

function MenuScene:onEnter()
end

return MenuScene
