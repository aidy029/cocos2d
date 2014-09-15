local scheduler = require("framework.scheduler")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local boxNum = 4
local boxWidth = display.width/boxNum
-- local boxHeightT = {80,120,180,230}
local labelHeight = 30
local boxHeight = 120
local containerHeight = display.height - labelHeight
local i = 0

function newNode(val)
	i = i + 1
	val._i = i
	return {next = nil,val = val,i = i}
end

queue = {}
function queue:init()
	self.first = nil
	self.last = nil
	self.n = 0
	return self
end

function queue:enqueue(val)
	if self.first == nil then
		self.first = newNode(val)
		self.last = self.first
	else
		local n = newNode(val)
		self.last.next = n
		self.last = n
	end
	self.n = self.n + 1
end

function queue:pop()
	if self.first == nil then
		return
	else
		local n = self.first.next
		self.first = n
		return n.val
	end
end

function queue:search(val)
	local n = self.first
	while n do
		if n.val == val then
			return n
		end
		n = self.first.next
	end
end

function queue:remove(pos)
	local n = self.first
	if not n then return end
	if self.n== 1 and n.i == pos then
		self.first = nil
		self.last = nil
		self.n = self.n - 1
		return
	end
	if n.i == pos then
		self.first = n.next
		self.n = self.n - 1
		return
	end
	local p = n.next
	while p and p.i ~= pos do
		n = p
		p = n.next
	end
	if p and p.i == pos then
		if p.next == nil then
			self.last = n
		else
			n.next = p.next
		end
	end
	self.n = self.n - 1
	-- dump(self)
end

local boxT = queue:init()
local score_per = 100
local spd = 3
local interval = 60

local function changeAdd()
	score_per = score_per + 100
	spd = spd + 2
	interval = math.max(interval - 30,20)
end

function MainScene:ctor()
    display.newColorLayer(ccc4(0x00,0x00,0x00, 255)):addTo(self)
	self.label = cc.ui.UILabel.new({
		text = "my score:0",
		color = ccc3(255,255,255),
		size = 20}):align(display.CENTER, display.cx, display.bottom + 15)
	self.score = 0
	self.layer = display.newRect(display.width,containerHeight,{x = display.left,y=display.top,color=ccc4f(1.0, 1, 1, 1.0),fill =true,align=display.LEFT_TOP}):addTo(self)
	
	local t = display.newRect(display.width,labelHeight,{x = display.left,y=display.bottom,color=ccc4f(0.0, 0, 0, 1.0),fill = true,align=display.LEFT_BOTTOM}):addTo(self)
	t:addChild(self.label)
   scheduler.scheduleUpdateGlobal(update)
   g = self
   self:genBox()
   scheduler.scheduleGlobal(changeAdd, interval)
end

function update()
	local n = boxT.first
	while n and n.val do
		-- dump(n.val)
		local x,y = n.val:getPosition()
		n.val:setPosition(x, y + spd)
		n = n.next
	end
	local last = boxT.last
	if last and last.val then
		local x,y = last.val:getPosition()
		if y >= 0 then
			g:genBox()
		end
	else
		g:genBox()
	end
	local first = boxT.first
	if first then
		local x,y = first.val:getPosition()
		if y > display.top then
			boxT:remove(first.val._i)
			g.layer:removeChild(first.val)
		end
	end
end

function MainScene:genBox()
	local last = boxT.last
	local x,y
	if last and last.val then
		x,y = last.val:getPosition()
	end
	local rect = display.newRect(boxWidth,boxHeight,{color=ccc4f(0, 0, 0, 1.0),fill = true,align=display.LEFT_BOTTOM})
	rect:ignoreAnchorPointForPosition(true)
	rect:setPosition(math.random(0,3)*boxWidth,  -boxHeight)
	self.layer:addChild(rect)
	boxT:enqueue(rect)
	rect:setTouchEnabled(true)
    rect:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y,rect)
    end)
end

function MainScene:onTouch(event, x, y,rect)
    if event == "began" then
        print(event,x,y,rect)
		print(rect._i)
		boxT:remove(rect._i)
		g.layer:removeChild(rect)
		self.score = self.score + score_per
		self.label:setString(string.format("my score:%d",self.score))
		--transition.moveTo(rect, {time = 0.7, y = display.top - rect:getContentSize().height / 2 - 40, easing = "BOUNCEOUT"})
		--print(g.rect)
    end
end

function MainScene:onEnter()
    -- layer:setTouchSwallowEnabled(true)
end
return MainScene
