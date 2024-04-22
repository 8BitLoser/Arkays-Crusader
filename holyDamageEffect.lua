local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local logger = require("logging.logger")
local log = logger.getLogger("Arkays Logger") or "Logger Not Found"

tes3.claimSpellEffectId("bsHolyDamage", 23335)
local bsHolyDamage

---@param e tes3magicEffectTickEventData --Tells me what is viable for different functions
local function onHolyTick(e)
    log:debug("onHolyTick")
    local config = mwse.loadConfig("Arkays Crusader")
    local effect = framework.functions.getEffectFromEffectOnEffectEvent(e, tes3.effect.bsHolyDamage)

    local origin = e.effectInstance.target.position
    local radius = effect and effect.radius --e.effectInstance.effectInstance.radius

    local targets = framework.functions.getActorsNearTargetPosition(tes3.player.cell, origin, (radius))
    -- log:info("1 = %s, 2 = %s",targets[1].mobile.health.current,targets[2].mobile.health.current)

    if targets and #targets > 0 then --# "determines the number of elements in the table" if the targets table exists and has atleast 1 thing in it, do below
        local magnitude = framework.functions.getCalculatedMagnitudeFromEffect(effect)
        local duration = effect and math.max(1, effect.duration) or 1
        local undead = tes3.creatureType.undead
        --Timer variables
        local timerDuration = 1 / magnitude
        local iteration = duration * magnitude
        local durationLeft = duration
        local count = iteration -- Initialize count with the total number of iterations
        local undeadTimer

        tes3.playSound({ sound = "restoration hit" })

        local function doHeal(target, heal)
            local targetHealth = target.mobile.health.current
            local value = heal and 1 or -1
            tes3.modStatistic({
                reference = target,
                name = "health",
                current = value,
                limitToBase = true
            })
            -- log:info("[1] = %s,[2] = %s", target.mobile.health.current, target.mobile.health.current)
            count = count - 1
            if (count <= 0) or (targetHealth <= 0) then
                log:debug("count = %s | targetHealth = %s", count, targetHealth)
                if undeadTimer then
                    log:debug("Canceling undeadTimer")
                    undeadTimer:cancel()
                end
            end
            return count --returns count to be used out of the function, needed it for something, but not using it now, leaving it as reference
        end
        --debug empty string
        local healthString = ""
        for i, target in ipairs(targets) do --i is the number ie: [1], does not need to be i can be anything, target is what were storing the value in, and ipairs(targets) is "an iterator function that iterates over a sequence table, such as targets"
            local type = target.object.type
            -- healthString = healthString .. string.format("[%d] ", i) --what the debug string ends up being used for -- = %s, target.mobile.health.current

            --Adds the visual effect to all targets
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
                    end,
                    iterations = iteration
                })
            else
                undeadTimer = timer.start({
                    duration = timerDuration,
                    callback = function()
                        doHeal(target, false)
                        log:info("%s", healthString)
                    end,
                    iterations = iteration
                })
            end
        end
    end

    log:debug("tes3.spellState.retired")
    e.effectInstance.state = tes3.spellState.retired
end

local function addHolyDamage()
    bsHolyDamage = framework.effects.restoration.createBasicEffect({
        -- Base information.
        id = tes3.effect.bsHolyDamage,
        name = "Holy Damage",
        description = "Deals Holy Damage to the Undead",

        -- Basic dials.
        baseCost = 10, -- Adjust this value as needed.
        speed = 1.5,

        -- Flags
        allowSpellmaking = true,
        canCastTarget = true,
        canCastSelf = false,
        canCastTouch = true,

        -- Graphics / sounds.
        -- icon = "bs\\bs_Repair_Alteration.dds",
        -- particleTexture = "vfx_particle064.tga",
        lighting = { 206 / 255, 237 / 255, 255 / 255 },

        -- Callbacks
        onTick = onHolyTick
    })
end
event.register("magicEffectsResolved", addHolyDamage)
