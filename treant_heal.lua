require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Active", "T", config.TYPE_HOTKEY)
config:SetParameter("SoulRing", true)
config:SetParameter("Team", 0.8)
config:SetParameter("Tower", 0.3)
config:Load()

toggleKey = config.Active
UseSoulRing = config.SoulRing
HealthTeam = config.Team
HealthTower = config.Tower

local Play = false
local myFont = drawMgr:CreateFont("manabarsFont","Calibri",14,500)
local main = drawMgr:CreateText(20,50,0x6CF58CFF,"Auto Heal On",myFont) main.visible = false
local text = drawMgr:CreateText(20,65,0x6CF58CFF,"No target",myFont) text.visible = false

function Tick( tick )
	if not PlayingGame() or not SleepCheck() then return end
		 
	local me = entityList:GetMyHero() if not me then return end
		
	if Play then
	
		main.text = "Auto Heal On"
		text.visible = true
		main.visible = true		
		
		local heal = me:GetAbility(3)
	
		if me.alive and not me:IsStunned() and heal and heal:CanBeCasted() then
		
			if me.health/me.maxHealth < HealthTeam then
				text.text = ""..me.name
				SoulRingf()
				me:CastAbility(heal,me)
				Sleep(1000)
				return
			end		
			
			local allyhero = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me.team,alive=true,visible=true,illusion=false})
			table.sort( allyhero, function (a,b) return a.health < b.health end )
			for i,v in ipairs(allyhero) do
				if v.health/v.maxHealth < HealthTeam then
					text.text = ""..v.name:gsub("npc_dota_hero_","")
					SoulRingf()
					me:CastAbility(heal,v)
					Sleep(1000)
					return
				end
			end
			
			local tower = entityList:GetEntities({classId=CDOTA_BaseNPC_Tower,team = me.team,alive=true,visible=true})
			table.sort( tower, function (a,b) return a.health < b.health end )
			for i,v in ipairs(tower) do
				if v.health/v.maxHealth < HealthTower then
					text.text = ""..v.name
					SoulRingf()
					me:CastAbility(heal,v)
					Sleep(1000)
					return
				end
			end
		end
	else
		main.text = "Auto Heal Off"
		text.visible = false
	end
end

function SoulRingf()
	local me = entityList:GetMyHero()
	local ring = me:FindItem("item_soul_ring")
	if UseSoulRing and ring and ring:CanBeCasted() then
		me:CastAbility(ring)
		return
	end
end

function Key()
    if IsKeyDown(toggleKey) and not client.chat then   
       Play = (not Play)
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Treant then 
			script:Disable() 
		else
			Play = true
			victim = nil
			script:RegisterEvent(EVENT_KEY,Key)
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end	
end

function GameClose()
	collectgarbage("collect")
	if play then
		Play = false
		text.visible = false
		main.visible = false
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
	end
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)