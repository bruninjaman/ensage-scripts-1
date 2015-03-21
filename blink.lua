require("libs.ScriptConfig")
require("libs.Utils")

config = ScriptConfig.new()
config:SetParameter("hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("range", true)
config:Load()

toggleKey = config.hotkey
showmerange = config.range

local rangeEffect = {} local Play = false

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero() if me then Play = true end
    if not Play then return end

    if IsKeyDown(toggleKey) and not client.chat then
        local blink = me:FindItem("item_blink")
        local distance = math.sqrt(math.pow(client.mousePosition.x - me.position.x, 2) + math.pow(client.mousePosition.y - me.position.y, 2))
        local expectedY = ((client.mousePosition.y - me.position.y) / distance) * 1199 + me.position.y
        local expectedX = ((client.mousePosition.x - me.position.x) / distance) * 1199 + me.position.x
        local blinkPosition = Vector(expectedX, expectedY, 0)

        if blink and blink:CanBeCasted() then
            if distance > 0 and distance > 1200 then
                me:CastAbility(blink, blinkPosition)
            else
                me:CastAbility(blink, Vector(client.mousePosition.x, client.mousePosition.y, 0))
            end
        end
    end
    
    if not rangeEffect[me.handle] and showmerange then
        rangeEffect[me.handle] = Effect(me,"range_display")
        rangeEffect[me.handle]:SetVector(1, Vector(1200,0,0))
    	collectgarbage("collect")
    end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else
			script:RegisterEvent(EVENT_TICK,Tick)
			script:RegisterEvent(EVENT_CLOSE,GameClose)
			script:UnregisterEvent(Load)
		end
	end
end

function GameClose()
    rangeEffect = {}
    collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,GameClose)
