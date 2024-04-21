local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local logger = require("logging.logger")
local log = logger.getLogger("Arkays Logger")

if not log then
    return
end

tes3.claimSpellEffectId("bsHolyDamage", 23335)
local bsHolyDamage

---@param e tes3magicEffectTickEventData --Tells the function what is viable for different functions
local function onHolyTick(e)
    local config = mwse.loadConfig("Arkays Crusader")
    if e.effectInstance.target then
        local target = e.effectInstance.target
        local targetHealth = target.mobile.health.current

        local effect = framework.functions.getEffectFromEffectOnEffectEvent(e, tes3.effect.bsHolyDamage)
        local magnitude = framework.functions.getCalculatedMagnitudeFromEffect(effect)
        local duration = effect and math.max(1, effect.duration) or 1

        local type = target.object.type
        local undead = tes3.creatureType.undead
        local timerDuration = 1 / magnitude

        -- log:debug("type: %s \ntarget: %s", type, target.id)
        -- log:debug("config.debug =%s", config.debug)

        if config.debug then
            -- log:debug("Duration: %s \nName: %s \ntimerDuration: %s", duration, target.object.name, timerDuration)
            -- log:debug("Name: %s", target.object.name)
            -- log:debug("timerDuration = %s", timerDuration)
            -- log:debug("iterations = %s", duration * magnitude)
        end

        if (type == undead) then
            timer.start({
                duration = timerDuration,
                callback = function()
                    tes3.modStatistic({ --Start Damage Timer
                        reference = target,
                        name = "health",
                        current = -1,
                        limitToBase = true,
                    })
                    if config.debug then
                        log:debug("\nDuration: %s \nName: %s \ntimerDuration: %s", duration, target.object.name, timerDuration)
                    end
                end,
                iterations = (duration * magnitude)
            })
      
        else
            timer.start({
                duration = timerDuration,
                callback = function()
                    tes3.modStatistic({
                        reference = target,
                        name = "health",
                        current = 1,
                        limitToBase = true,
                    })
                    if config.debug then
                        log:debug("\nDuration: %s \nName: %s \ntimerDuration: %s", duration, target.object.name, timerDuration)
                    end
                end,
                iterations = (duration * magnitude)
            })
        end
    end
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
