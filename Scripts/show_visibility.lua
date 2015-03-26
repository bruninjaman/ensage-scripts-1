require("libs.ScriptConfig")
require("libs.Utils")

config = ScriptConfig.new()
config:SetParameter("Self", true)
config:SetParameter("Allies", true)
config:SetParameter("Neutral", true)
config:SetParameter("Courier", true)
config:SetParameter("Mines", true)
config:SetParameter("Ward", true)
config:Load()

Visible_Self = config.Self
Visible_Allies = config.Allies
Visible_Neutral = config.Neutral
Visible_Courier = config.Courier
Visible_Mines = config.Mines
Visible_Ward = config.Ward

local play = false local visibilityEffect = {}

function Tick(tick)
    if not PlayingGame() and not play then return end
    local me = entityList:GetMyHero()
    
    if Visible_Self then
        drawEffect(me, "aura_shivas")
    end
    if Visible_Allies then
        local hero = entityList:GetEntities({type = LuaEntity.TYPE_HERO, team = me.team})
        for _,v in ipairs(hero) do 
            drawEffect(v, "aura_shivas")
        end
    end
    if Visible_Neutral then
        local neutral = entityList:FindEntities({classId = CDOTA_BaseNPC_Creep_Neutral})    
        for _,v in ipairs(neutral) do 
            if v.spawned then
                drawEffect(v, "aura_shivas")
            end
        end
    end
    if Visible_Courier then
        local courier = entityList:FindEntities({classId = CDOTA_Unit_Courier, team = me.team})    
        for _,v in ipairs(courier) do 
            drawEffect(v, "aura_shivas")
        end
    end
    if Visible_Ward then
        local observerWard = entityList:GetEntities({classId = CDOTA_NPC_Observer_Ward, team = me.team})
        for _,v in ipairs(observerWard) do 
            drawEffect(v, "aura_shivas")
        end
        
        local sentryWard = entityList:GetEntities({classId = CDOTA_NPC_Observer_Ward_TrueSight, team = me.team})
        for _,v in ipairs(sentryWard) do 
            drawEffect(v, "aura_shivas")
        end
    end
    if Visible_Mines then
        local mines = entityList:GetEntities({classId = CDOTA_NPC_TechiesMines, team = me.team})
        for _,v in ipairs(mines) do 
            drawEffect(v, "aura_shivas")
        end
    end
end

function drawEffect(object, effectName)
    if object ~= nil then
        local onScreen = client:ScreenPosition(object.position)
        if onScreen and object.alive and object.visibleToEnemy then
            if not visibilityEffect[object.handle] then
                visibilityEffect[object.handle] = Effect(object, effectName)
                visibilityEffect[object.handle]:SetVector(1, Vector(0,0,0))
            end
        else
            if visibilityEffect[object.handle] then
                visibilityEffect[object.handle] = nil
            end
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
    visibilityEffect = {}
	collectgarbage("collect")
    if play then
        script:UnregisterEvent(Tick)
        script:RegisterEvent(EVENT_TICK,Load)
        play = false
    end
end


script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
