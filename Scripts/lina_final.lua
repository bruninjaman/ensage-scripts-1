require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.Utils")
require("libs.Skillshot")
require("libs.Animations")

local config = ScriptConfig.new()
config:SetParameter("HotKey", "32", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local move = 0 local delay = 0

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end
	local victim = targetFind:GetClosestToMouse(me,2000)
	if IsKeyDown(config.HotKey) and not client.chat then
		if victim then
			if tick > move and SleepCheck("xx") then
				if GetDistance2D(victim,me) <= 600 then
					me:Attack(victim)
				else
					me:Follow(victim)
				end
				move = tick + 450
			end
			local Q = me:GetAbility(1)
			local W = me:GetAbility(2)
			local euls = me:FindItem("item_cyclone")
			if euls and tick > delay then
				if euls and euls:CanBeCasted() then
					if GetDistance2D(victim,me) <= euls.castRange then
						me:CastAbility(euls,victim)
						Sleep(me:GetTurnTime(victim)*1000, "xx")
						delay = tick + 1700
					end
				end
				if W and W:CanBeCasted() then
					if euls and euls.cd > 1 then
						xyz2(victim,me,W)
						Sleep(W:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "xx")
					end
				end
				if Q and Q:CanBeCasted() then
					if W and W.cd > 1 then
						xyz1(victim,me,Q)
						Sleep(Q:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "xx")
					end
				end
			end
			if not euls then
				if W and W:CanBeCasted() then
					xyz2(victim,me,W)
					Sleep(me:GetTurnTime(victim)*1000, "xx")
				end
				if Q and Q:CanBeCasted() then
					if W and W.cd > 1 then
						xyz1(victim,me,Q)
						Sleep(Q:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "xx")
					end
				end
			end
		end
	end
end

function xyz1(victim,me,Q)
	local CP = Q:FindCastPoint()
	local delay = ((800-Animations.getDuration(Q)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
	local speed = 2500
	local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
	if xyz and GetDistance2D(victim,me) <= Q.castRange then 
		me:CastAbility(Q,xyz)
	end
end

function xyz2(victim,me,W)
	local CP = W:FindCastPoint()
	local delay = ((625-Animations.getDuration(W)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
	local speed = 1900
	local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
	if xyz and GetDistance2D(victim,me) <= W.castRange then 
		me:CastAbility(W,xyz)
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Lina then 
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
