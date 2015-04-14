require("libs.ScriptConfig")
require("libs.Utils")


config = ScriptConfig.new()
config:SetParameter("HotKey", "32", config.TYPE_HOTKEY)
config:Load()

toggleKey = config.HotKey

local play = false local myhero = nil local victim = nil

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end

	if IsKeyDown(toggleKey) and not client.chat then
	local victim = targetFind:GetClosestToMouse(me,2000)
		if victim and SleepCheck("combo") then
			local Q = me:GetAbility(1)
			local E = me:GetAbility(3)
			if E.name == "kunkka_x_marks_the_spot" and E:CanBeCasted() and me:CanCast() then
				me:CastAbility(E,victim)
				Sleep(350+client.latency, "combo")
			end
			if Q and Q:CanBeCasted() and me:CanCast() and E.level > 0 and E.abilityPhase then
				me:CastAbility(Q,victim.position)
				Sleep(350+client.latency, "combo")
			end
			if E.name == "kunkka_return" and me:CanCast() and math.floor(Q.cd*10) == 110 + math.floor((client.latency/100)) then
				me:CastAbility(E)
				Sleep(350+client.latency, "combo")
			end
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Kunkka then 
			script:Disable() 
		else
			play = true
			victim = nil		
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end
end

function Close()
	myhero = nil
	victim = nil
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
