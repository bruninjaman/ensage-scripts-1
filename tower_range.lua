local eff = {}
local play = false

function Tick(tick)
    if not PlayingGame() or not Play then return end
    local me = entityList:GetMyHero() if not me then return end
	local towers = entityList:FindEntities({classId=CDOTA_BaseNPC_Tower,alive=true})
	local clear = false
	for i,v in ipairs(towers) do
		if GetDistance2D(me,v) < 1400 then
			if not eff[v.handle] then
				eff[v.handle] = Effect(v,"range_display")
				eff[v.handle]:SetVector( 1, Vector(850,0,0) )
			end
		elseif eff[v.handle] then
			eff[v.handle] = nil
			clear = true
		end
	end	
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else
			Play = true
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end
end

function Close()
	collectgarbage("collect")
	if play then
		eff = {}
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)