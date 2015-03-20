require("libs.DrawManager3D")

local key = string.byte("M")

local myId = nil local play = false local activated = true

local rec1 = drawMgr3D:CreateRect(Vector(-2272,1792,0), Vector(0,0,0), Vector2D(0,0), Vector2D(30,30), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/fav_heart")) rec1.visible = false
local rec2 = drawMgr3D:CreateRect(Vector(3000,-2450,0), Vector(0,0,0), Vector2D(0,0), Vector2D(30,30), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/fav_heart")) rec2.visible = false

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero() if not me then return end
	
	if activated then	
		if not rec1.visible then
			rec1.visible = true
			rec2.visible = true
		end

		local runes = entityList:GetEntities(function (ent) return ent.classId==CDOTA_Item_Rune and GetDistance2D(ent,me) < 200 end)[1]		
		if runes then 
			entityList:GetMyPlayer():Select(me)
			entityList:GetMyPlayer():TakeRune(runes)
		end		
	end
end

function Key(msg,code)
	if msg ~= KEY_UP and code == key and not client.chat then
		activated = not activated
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else
			play = true
			script:RegisterEvent(EVENT_KEY,Key)
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end
end

function Close()
	collectgarbage("collect")
	if play then
		rec1.visible = false
		rec2.visible = false
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
