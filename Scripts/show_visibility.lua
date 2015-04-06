require("libs.Utils")

local play = false local eff = {}

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
    local entities = entityList:GetEntities(function (v) return (v.type==LuaEntity.TYPE_HERO or v.classId==CDOTA_BaseNPC_Creep_Neutral or v.classId==CDOTA_Unit_Courier or v.classId==CDOTA_NPC_Observer_Ward or v.classId==CDOTA_NPC_Observer_Ward_TrueSight or v.classId==CDOTA_NPC_TechiesMines or me) and v.team==me.team and v.alive end)
    for _,v in ipairs(entities) do
        if v.visibleToEnemy then
            if not eff[v.handle] then                            
                eff[v.handle] = Effect(v,"aura_shivas_ring")
                eff[v.handle]:SetVector(1,Vector(0,0,0))
            end
        elseif eff[v.handle] then
            eff[v.handle] = nil
            collectgarbage("collect")
        end
    end
end

function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
    end
end

function Close()
    eff = {}
	collectgarbage("collect")
    if play then
        script:UnregisterEvent(Tick)
        script:RegisterEvent(EVENT_TICK,Load)
        play = false
    end
end


script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
