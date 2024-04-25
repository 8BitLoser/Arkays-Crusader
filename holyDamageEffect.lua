local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local logger = require("logging.logger")
local log = logger.getLogger("Arkays Logger") or "Logger Not Found"

tes3.claimSpellEffectId("bsHolyDamage", 23335)
local bsHolyDamage

---@param e tes3magicEffectTickEventData --Tells me what is viable for different functions
local function onHolyTick(e)
	e:trigger()
	log:debug("onHolyTick")
	local config = mwse.loadConfig("Arkays Crusader")
	local effect = framework.functions.getEffectFromEffectOnEffectEvent(e, tes3.effect.bsHolyDamage)

	local origin = e.effectInstance.target.position
	local radius = effect and effect.radius -- e.effectInstance.effectInstance.radius

	local targets = framework.functions.getActorsNearTargetPosition(tes3.player.cell, origin, radius)
	-- log:info("1 = %s, 2 = %s",targets[1].mobile.health.current,targets[2].mobile.health.current)

	-- trying to make it effect the player----// Think i got it,
	-- Adds nil check before setting getEffects i think? not sure how to test it, its working, so ill leave it
	-- could have just used effect variable, but need to learn how its done without magickaExpanded
	local getEffects = #e.sourceInstance.sourceEffects > 0 and e.sourceInstance.sourceEffects[1] ---@type tes3effect how to access the effects properties, getEffects.duration etc

	log:debug("[1]rangeType = %s, radius = %s", getEffects.rangeType, getEffects.radius)

	if getEffects.rangeType == tes3.effectRange.self or getEffects.radius >= 5 then
		log:debug("[2]rangeType = %s, radius = %s", getEffects.rangeType, getEffects.radius)
		table.insert(targets, tes3.player)
	end
	-- local eff = e.effectIndex[1]
	-- if e.effectInstance.target == tes3.player then
	--     table.insert(targets, tes3.player)
	-- end
	----------

	if targets and #targets > 0 then -- # "determines the number of elements in the table" if the targets table exists and has atleast 1 thing in it, do below
		local magnitude = framework.functions.getCalculatedMagnitudeFromEffect(effect)
		local duration = effect and math.max(1, effect.duration) or 1 -- compressed nil check, if effect exists set duration to effect.duration, if it doesnt just say 1
		local undead = tes3.creatureType.undead
		-- Timer variables
		local timerDuration = 1 / magnitude -- Makes the delay for each iteration of timer faster(lower) the higher the magnitude
		local iteration = duration * magnitude -- not actually necessary, but i wanted the timer to +/- health by one instead of in chunks
		local durationLeft = duration -- used to log how much timer the timer had left
		local count = iteration -- Initialize count with the total number of iterations
		local undeadTimer -- timer for the undead effect

		tes3.playSound({
			sound = "restoration hit",
		})

		local function doHeal(target, heal) -- the heal/damage effect itself, target is set in the for loop, heal is boolean, and causes heal/damage
			local targetHealth = target.mobile.health.current
			local value = heal and 1 or -1 -- brain doesnt like this, but its value = if (heal == true) then value = 1 else value = -1.
			tes3.modStatistic({
				reference = target, -- target that is grabbed below in the ipairs
				name = "health", -- name of value to adjust,
				current = value, -- current is how much to change by, not targets current value, 1 if heal = true, -1 if false
				limitToBase = true, -- stops healing from buffing total health
			})
			-- log:info("[1] = %s,[2] = %s", target.mobile.health.current, target.mobile.health.current)
			-- count = count - 1                           --Lowers count(iteration) var by 1 every loop so i can cancel the timer|dont think i need this?
			if targetHealth <= 0 then -- if it runs out of iterations/ health to take, cancel the timer--[[(count <= 0) or ]]
				log:debug("count = %s | targetHealth = %s", count, targetHealth)
				if undeadTimer then -- nil check, no other version would work,
					log:debug("Canceling undeadTimer")
					undeadTimer:cancel()
				end
			end
			return count -- returns count to be used out of the function, needed it for something, but not using it now, leaving it as reference
		end

		-- debug empty string
		local healthString = "" -- used for debugging if area effect was applying
		for i, target in ipairs(targets) do -- i is the number ie: [1], does not need to be i can be anything, target is what were storing the value in, and ipairs(targets) is "an iterator function that iterates over a sequence table, such as targets"
			local type = target.object.type -- set type var to the type of the target, to compare if its undead later
			-- healthString = healthString .. string.format("[%d] ", i) --what the debug string ends up being used for -- = %s, target.mobile.health.current

			-- Adds the visual effect to all targets
			e.sourceInstance:playVisualEffect({
				reference = target,
				position = target.position,
				visual = bsHolyDamage.hitVisualEffect,
				effectIndex = e.sourceInstance.source:getFirstIndexOfEffect(tes3.effect.bsHolyDamage),
			})
			local id = i

			if type ~= undead then
				local healTimer = timer.start({
					duration = timerDuration,
					callback = function()
						doHeal(target, true)
						id = i
						log:info("[%d] = %s", id, target.mobile.health.current)
					end, -- Hate this but its what format document does and no setting will change
					iterations = iteration,
				})
			else
				undeadTimer = timer.start({
					duration = timerDuration,
					callback = function()
						doHeal(target, false)
						log:info("%s", healthString)
					end,
					iterations = iteration,
				})
			end
		end
	end

	log:debug("tes3.spellState.retired")
	e.effectInstance.state = tes3.spellState.retired
end

local function addHolyDamage()
	bsHolyDamage = framework.effects.restoration.createBasicEffect({ -- Base information.
		id = tes3.effect.bsHolyDamage,
		name = "Holy Damage",
		description = "Deals Holy Damage to the Undead",

		-- Basic dials.
		baseCost = 10, -- Adjust this value as needed.
		speed = 1.5, -- Flags
		allowSpellmaking = true,
		canCastTarget = true,
		canCastSelf = true,
		canCastTouch = true, -- Graphics / sounds.
		-- icon = "bs\\bs_Repair_Alteration.dds",
		-- particleTexture = "vfx_particle064.tga",
		lighting = { 206 / 255, 237 / 255, 255 / 255 }, -- Callbacks
		onTick = onHolyTick,
	})
end

event.register("magicEffectsResolved", addHolyDamage)
