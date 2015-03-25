require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:SetParameter("Stack", "L", config.TYPE_HOTKEY)
config:Load()

activated_button = config.Hotkey
no_stack_creep_button = config.stack

local eff = {}
local activated = false
local play = false
local creepHandle = nil
local SaveCreep = nil
local param = 1
local font = drawMgr:CreateFont("No Stack","Tahoma",14,500)
local statusText = drawMgr:CreateText(50,30,0x6CF58CFF,"",font)
local mode=3 -- MODE 1/2/3
local effecttocreep = true -- Effect for Creep.

function Tick( tick )
	if not PlayingGame() or sleepTick and sleepTick > tick or not play then return end
	local me = entityList:GetMyHero() if not me then return end
	local target = nil
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

	if creepHandle ~= nil and effecttocreep then
		if not SaveCreep.alive then
			if eff[creepHandle] ~= nil then
				eff[creepHandle] = nil
				creepHandle = nil
				SaveCreep = nil
				statusText.visible = false
				collectgarbage("collect")
			end
		end
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
									if distance < 250 and not (CheckStun or CheckSetka) then
										v:SafeCastAbility(v:GetAbility(1),nil)
									end
								elseif v.name == "npc_dota_neutral_satyr_hellcaller" then
									if distance < 980 then
										v:SafeCastAbility(v:GetAbility(1),target.position)
									end						
								elseif v.name == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
									if distance < 300 then
										v:SafeCastAbility(v:GetAbility(1),nil)
									end							
								elseif v.name == "npc_dota_neutral_dark_troll_warlord" then
									if distance < 550 and not (CheckStun or CheckSetka) then
										v:SafeCastAbility(v:GetAbility(1),target)
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
							if distance < 600 then
								v:SafeCastAbility(v:GetAbility(1),target)
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
						if v:GetAbility(4):CanBeCasted() and distance <= 400 then
							v:CastAbility(v:GetAbility(4),target)
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
							v:CastAbility(v:GetAbility(1),target)
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

function Key(msg,code)
	if client.chat then return end

    if code == activated_button then
        activated = (msg == KEY_DOWN)
	end
		
	if code == no_stack_creep_button and msg == KEY_UP then
		local player = entityList:GetMyPlayer()
		if not player or player.team == LuaEntity.TEAM_NONE then
			return
		end
		
		local effectDeleted = false
		
		if param == 2 then
			if eff[creepHandle] ~= nil and effecttocreep then
				eff[creepHandle] = nil
				effectDeleted = true
			end
			SaveCreep = nil
			creepHandle = nil
			statusText.visible = false
			param = 1
		end
		
		if effectDeleted then
			collectgarbage("collect")
		end

		local selection = player.selection
		if #selection ~= 1 or (selection[1].type ~= LuaEntity.TYPE_CREEP and selection[1].type ~= LuaEntity.TYPE_NPC) or selection[1].classId ~= CDOTA_BaseNPC_Creep_Neutral or not selection[1].alive or not selection[1].controllable then
			return
		end

		if param == 1 then
			creepHandle = selection[1].handle
			SaveCreep = selection[1]
			if eff[creepHandle] == nil and effecttocreep then
				eff[creepHandle] = Effect(selection[1],"aura_assault")
				eff[creepHandle]:SetVector(1,Vector(0,0,0))
			end
			if client.language == "russian" then
				statusText.text = "Stack Creep: "..client:Localize(names[selection[1].name].Name)
			else	
				statusText.text = "Stack Creep: "..client:Localize(selection[1].name)
			end
			local name = client:Localize(selection[1].name)
			statusText.visible = true
			param = 2
		end
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
	eff = {}
	activated = false
	creepHandle = nil
	SaveCreep = nil
	param = 1
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
