require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:Load()

activated_button = config.Hotkey

local eff = {}
local activated = false
local play = false
local creepHandle = nil
local mode=3 -- MODE 1/2/3

function Key(msg,code)
	if client.chat and not play then return end
    if code == activated_button then activated = (msg == KEY_DOWN) end
end

function Tick( tick )
	if not PlayingGame() or sleepTick and sleepTick > tick then return end
	local target = nil
	local me = entityList:GetMyHero()
	local nc = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Neutral,controllable=true,alive=true,visible=true})
	local fs = entityList:FindEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,controllable=true,alive=true,visible=true})
	local wg = entityList:FindEntities({classId=CDOTA_BaseNPC_Warlock_Golem,controllable=true,alive=true,visible=true})
	local ts = entityList:FindEntities({classId=CDOTA_BaseNPC_Tusk_Sigil,controllable=true,alive=true,visible=true})
	local cc = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep,controllable=true,alive=true,visible=true})
	local ii = entityList:FindEntities({classId=TYPE_HERO,controllable=true,alive=true,visible=true,illusion=true})
	local db = entityList:FindEntities({classId=CDOTA_Unit_SpiritBear,controllable=true,alive=true,visible=true})
	local pe = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalEarth,controllable=true,alive=true,team=me.team})
	local ps = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalStorm,controllable=true,alive=true,team=me.team})
	local pf = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalFire,controllable=true,alive=true,team=me.team})

	if eff[creepHandle] ~= nil then
		creepHandle = nil
		collectgarbage("collect")
	end
	
	if mode == 1 then
		target = targetFind:GetLastMouseOver(1300)
	elseif mode == 2 then
		target = entityList:GetMouseover()
	elseif mode == 3 then
		target = targetFind:GetClosestToMouse(1300)
	else
		print("please check mode 1/2/3. Thank.")
		return
	end
	if target and activated then
		if target.team == (5-me.team) then
			if #nc > 0 then
			CheckStun = target:DoesHaveModifier("modifier_centaur_hoof_stomp")
			CheckSetka = target:DoesHaveModifier("modifier_dark_troll_warlord_ensnare")
				for i,v in ipairs(nc) do
					if v.controllable and v.handle ~= creepHandle then
						if v.unitState ~= -1031241196 then
							local distance = GetDistance2D(v,target)
							if distance <= 1300 then
								if v.name == "npc_dota_neutral_centaur_khan" then
									if v:GetAbility(1):CanBeCasted() and distance < 250 and not (CheckStun or CheckSetka) then
										v:CastAbility(v:GetAbility(1),nil)
									end
								elseif v.name == "npc_dota_neutral_satyr_hellcaller" then
									if v:GetAbility(1):CanBeCasted() and distance < 980 then
										v:CastAbility(v:GetAbility(1),target.position)
									end						
								elseif v.name == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
									if v:GetAbility(1):CanBeCasted() and distance < 300 then
										v:CastAbility(v:GetAbility(1),nil)
									end							
								elseif v.name == "npc_dota_neutral_dark_troll_warlord" then
									if v:GetAbility(1):CanBeCasted() and distance < 550 and not (CheckStun or CheckSetka) then
										v:CastAbility(v:GetAbility(1),target)
									end							
								end
								if distance <= 1300 then
									v:Attack(target)
								end
							end
						end
					end
				end
			end
			
			if #fs > 0 then
				for i,v in ipairs(fs) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #wg > 0 then
				for i,v in ipairs(wg) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #ts > 0 then
				for i,v in ipairs(ts) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Follow(target)
						end
					end
				end
			end
			
			if #db > 0 then
				for i,v in ipairs(db) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #cc > 0 then
				for i,v in ipairs(cc) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if v.name == "npc_dota_necronomicon_archer_1" or v.name == "npc_dota_necronomicon_archer_2" or v.name == "npc_dota_necronomicon_archer_3" then
							if v:GetAbility(1):CanBeCasted() and distance <= 600 then
								v:CastAbility(v:GetAbility(1),target)
							end				
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #ii > 0 then
				for i,v in ipairs(ii) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #pe > 0 then
				for i,v in ipairs(pe) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if v:GetAbility(4):CanBeCasted() and distance <= 340 then
							v:CastAbility(v:GetAbility(4))
						end
						if v:GetAbility(1):CanBeCasted() and distance <= 800 then
							v:CastAbility(v:GetAbility(1),target)
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #ps > 0 then
				for i,v in ipairs(ps) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if v:GetAbility(1):CanBeCasted() and distance <= 500 then
							v:CastAbility(v:GetAbility(1),target.position)
						end
						if v:GetAbility(4):CanBeCasted() and distance <= 850 then
							v:CastAbility(v:GetAbility(4),target)
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #pf > 0 then
				for i,v in ipairs(pf) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
		end
	end
	sleepTick = tick + 333
	return
end

function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_KEY,Key)
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	eff = {}
	activated = false
	creepHandle = nil
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
