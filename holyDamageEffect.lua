local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local logger = require("logging.logger")
local log = logger.getLogger("Arkays Logger") or "Logger Not Found"

tes3.claimSpellEffectId("bsHolyDamage", 23335)
local bsHolyDamage

---@type mwseTimer|nil
local undeadTimer
local healTimer



---@param e tes3magicEffectTickEventData --Tells the function what is viable for different functions
local function onHolyTick(e)
    local config = mwse.loadConfig("Arkays Crusader")
    if config.debug then log:setLogLevel("DEBUG") else log:setLogLevel("WARN") end
    if e.effectInstance.target then
        local target = e.effectInstance.target
        local targetHealth = target.mobile.health.current

        local effect = framework.functions.getEffectFromEffectOnEffectEvent(e, tes3.effect.bsHolyDamage)
        local magnitude = framework.functions.getCalculatedMagnitudeFromEffect(effect)
        local duration = effect and math.max(1, effect.duration) or 1

        local type = target.object.type
        local undead = tes3.creatureType.undead

        --Timer variables
        local timerDuration = 1 / magnitude
        local iteration = duration * magnitude
        local durationLeft = duration
        local spellDur = duration




        local function doHeal(heal)
            local targetHealth = target.mobile.health.current
            local value = heal and 1 or -1 --lua conditional assignement, if heal == true then value = 1, if heal is false then it is -1--Dont get it yet but its a thing 
            
            -- iteration = iteration - 1
            -- if targetHealth <= 0 then
            --     log:debug("Health >= 0")
            --     iteration = 1
            --     e.effectInstance.state = tes3.spellState.retired
            -- end

            
            tes3.modStatistic({
                reference = target,
                name = "health",
                current = value,
                limitToBase = true
            })

            -- log:debug("Iteration: %s, Target Health: %s, Undead Timer: %s", iteration, targetHealth, undeadTimer)

            if (iteration <= 0) or (targetHealth <= 0) then
                log:debug("Iteration or targetHealth <= 0 expire timer")
                if undeadTimer then
                    undeadTimer:cancel()
                end



                -- --Works just fine but i want to use the compressed one :(
                -- if undeadTimer then
                --     undeadTimer:cancel()
                -- end
                --  ---Wont work, wont stop trying to call nil value anyway
                --  (undeadTimer ~= nil and undeadTimer:cancel()) --Condensed nil check, only runs if undeadTimer is not nil

                -- e.effectInstance.state = tes3.spellState.retired
            end

           

        end

        if config.debug then
            log:debug("\ndurationLeft: %s /spellDur: %s \nName: %s \nHealth: %s \nIterations: %s", durationLeft, spellDur, target.object.name, targetHealth, iteration - 1) 
        end
        
    --    if config.debug then timer.start({duration = 1,callback = function()  durationLeft = durationLeft - 1 log:debug("spellDurTimer")  end, iterations=spellDur}) end --doHeal(spellDur) --spellDur = doHeal(spellDur)

    local count = iteration --Needs to be out of callback function, else its going to reset to the original value every iteration.

        if (type ~= undead) then
            healTimer = timer.start({
                duration = timerDuration,
                callback = function()
                    doHeal(true)
                    count = count - 1
                    log:debug("iteration = %s",count)
                end,
                iterations = iteration
            })
        else
           undeadTimer = timer.start({
                duration = timerDuration,
                callback = function()
                    doHeal(false)
                    count = count - 1
                    log:debug("iteration = %s",count)
                end,
                iterations = iteration
            })
        end
    end
    e.effectInstance.state = tes3.spellState.retired
end



----------------------------------------------------------
----Works but trying something new
        -- if (type == undead) then
        --     timer.start({
        --         duration = timerDuration,
        --         callback = function()
        --             tes3.modStatistic({ --Start Damage Timer
        --                 reference = target,
        --                 name = "health",
        --                 current = -1,
        --                 limitToBase = true,
        --             })
        --             if config.debug then
        --                 log:debug("\nDuration: %s \nName: %s \ntimerDuration: %s", duration, target.object.name, timerDuration - 1)
        --             end
        --         end,
        --         iterations = (duration * magnitude)
        --     })
        -- else
        --     timer.start({
        --         duration = timerDuration,
        --         callback = function()
        --             tes3.modStatistic({
        --                 reference = target,
        --                 name = "health",
        --                 current = 1,
        --                 limitToBase = true,
        --             })
        --             -- log:warn("Target Living")

        --             log:debug("\nDuration: %s \nName: %s \ntimerDuration: %s \nIterations: %s", duration, target.object.name, timerDuration, countdown - 1)
        --             countdown = countdown - 1
        --             -- log:warn("WARN")
        --         end,
        --         iterations = (iteration)
        --     })
        -- end


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
