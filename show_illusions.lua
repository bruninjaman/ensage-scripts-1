local Play = false
local sleepTick = 0
local heroTable = {}
local illusionTable = {}   

function Tick(tick)
	if not PlayingGame() or not SleepCheck() then return end
	local me = entityList:GetMyHero() if not me then return end
	local illusions = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=true,team = (5-me.team)})	--
	local clear = false
	for _, heroEntity in ipairs(illusions) do
		if not (heroEntity.type == 9 and heroEntity.meepoIllusion == false) then
			if heroEntity.visible and heroEntity.alive and heroEntity:GetProperty("CDOTA_BaseNPC","m_nUnitState") ~= -1031241196  then	
				if not illusionTable[heroEntity.handle] then
					illusionTable[heroEntity.handle] = {}
					illusionTable[heroEntity.handle].effect1 = Effect(heroEntity,"shadow_amulet_active_ground_proj")			
					illusionTable[heroEntity.handle].effect2 = Effect(heroEntity,"smoke_of_deceit_buff")
					illusionTable[heroEntity.handle].effect3 = Effect(heroEntity,"smoke_of_deceit_buff")			
					illusionTable[heroEntity.handle].effect4 = Effect(heroEntity,"smoke_of_deceit_buff")
				end
			else
				if illusionTable[heroEntity.handle] then
					illusionTable[heroEntity.handle] = nil
					clear = true
				end
			end
		end
	end
	Sleep(250)
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

function GameClose()
	collectgarbage("collect")
	if play then
		heroTable = {}
		llusionTable = {}
		Play = false 	
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
	end
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)