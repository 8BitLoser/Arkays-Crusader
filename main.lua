local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local config = mwse.loadConfig("Arkays Crusader", {
    debug = false,
})

local logger = require("logging.logger")
local log = logger.new {
    name = "Arkays Logger",
    logLevel = "WARN",
    logToConsole = true,
}

if config.debug then log:setLogLevel("DEBUG") end
require("BeefStranger.Arkays Crusader.holyDamageEffect")
require("BeefStranger.Arkays Crusader.restorationEffectTemplate")
require("BeefStranger.Arkays Crusader.testeffect")

local function initialized()
    print("[MWSE:Arkay's Crusader Initialized]")
end

local spellIds = {
    bsArkaysLight = "bsArkaysLight",
    bsAbility = "bsAbility",
    bsTest = "bsTest"
}

local spellMaker = require("BeefStranger.Arkays Crusader.spellMaker")

local spell = tes3.objectType.spell


local function registerSpells()




--     -- framework.spells.createBasicSpell({ --Works perfectly but trying something else
--     --     id = spellIds.bsArkaysLight,
--     --     name = "Arkay's Light",
--     --     effect = tes3.effect.bsHolyDamage,
--     --     range = tes3.effectRange.target,
--     --     min = 1,
--     --     max = 4,
--     --     duration = 10,
--     -- })

--     local bsArkaysLightT = tes3.createObject({ --The built in way to create a spell, lets me use castType, Snippet = createSpell
--         objectType = spell,
--         id = "bsArkaysLightT",
--         name = "createObject Arkay",
--         effects = {{
--             id = tes3.effect.bsHolyDamage,
--             min = 5,
--             max = 5,
--             duration = 10,
--             rangeType = tes3.effectRange.target
--         }}
--     })

    -- framework.spells.createBasicSpell({ --Cant get it to add castType
    --     id = spellIds.bsAbility,
    --     name = "Test Ability",
    --     castType = tes3.spellType.ability,
    --     effect = tes3.effect.chameleon,
    --     range = tes3.effectRange.self,

    --     min = 25,
    --     max = 25,
    -- })

    local functionTest = spellMaker.createBasic({
        id = "FunctionTest",
        name = "Function Test",
        castType = tes3.spellType.spell,
        alwaysSucceeds = true,
        effect = tes3.effect.testEffect,
        min = 20,
        duration = 30,
        range = tes3.effectRange.target,
        cost = 50,

    })

    -- local advanceTest = spellMaker.createAdvanced({
    --     id = "advancedTest",
    --     name = "advancedTest",
    --     effects = {
    --         {
    --             effect = tes3.effect["frostDamage"],
    --             min = 20,
    --         },
    --         {
    --             effect = tes3.effect["fireDamage"],
    --             min = 15,
    --         }
    --     }

    -- })

    local advanceTest = spellMaker.create({
        id = "advancedTest",
        name = "advancedTest",
        effect = tes3.effect["frostDamage"],
        min = 15,
        duration = 50,

        effect2 = tes3.effect["fireDamage"],
        duration2 = 20,

        effect3 = tes3.effect["light"],
        min3 = 10,
        duration3 = 5,
        
    })
end



event.register("loaded", registerSpells)

local function addSpells()
    if config.debug then
        tes3.addSpell({ reference = tes3.mobilePlayer, spell = "FunctionTest" })
        log:debug("Adding Spell to player")
    end
end

----=======================Debug========================================
local function registerModConfig()
    local template = mwse.mcm.createTemplate("Arkays Crusader")
    template:saveOnClose("Arkays Crusader", config)
    template:register()
    local page = template:createSideBarPage({ label = "Arkays Crusader Settings" })

    local debug = page:createCategory("Debug")
    debug:createYesNoButton({
        label = "Debug Mode",
        variable = mwse.mcm.createTableVariable({ id = "debug", table = config })
    })
    page:createDropdown {
        label = "Logging Level",
        description = "Set the log level.",
        options = {
            { label = "TRACE", value = "TRACE" },
            { label = "DEBUG", value = "DEBUG" },
            { label = "INFO",  value = "INFO" },
            { label = "WARN",  value = "WARN" },
            { label = "ERROR", value = "ERROR" },
            { label = "NONE",  value = "NONE" },
        },
        variable = mwse.mcm.createTableVariable { id = "logLevel", table = config },
        callback = function(self)
            log:setLogLevel(self.variable.value)
        end
    }
end

local function onKeyDownP()
    if not tes3.menuMode() then
        if config.debug then
            -- tes3.messageBox("P Pressed")
            tes3.createReference({ --Spawn a skeleton on the player
                object = "skeleton",
                position = tes3.player.position,
                orientation = tes3vector3.new(0, 0, 0.67),
                cell = tes3.player.cell
            })
            log:debug("P Pressed")
        end
    end
end

local function onKeyDownI()
    if not tes3.menuMode() and config.debug then
        log:debug("I Pressed")

        local effect = tes3.getMagicEffect(tes3.effect.testEffect)
        -- tes3.addSpell({ reference = tes3.mobilePlayer, spell = "bsArkaysLightT" })
        -- local duration = tes3.getObject("bsArkaysLightT").effects[1].duration --good way to get duration/min/max/etc
        -- log:debug("duration = %s", duration)
        if effect then
            log:debug("school = %s", effect.school)
        end

    end
end

event.register("keyDown", onKeyDownI, { filter = tes3.scanCode["i"] })
event.register("keyDown", onKeyDownP, { filter = tes3.scanCode["p"] })
event.register("modConfigReady", registerModConfig)
----=======================Debug========================================


event.register(tes3.event.loaded, addSpells)
-- event.register("MagickaExpanded:Register", registerSpells)
event.register(tes3.event.initialized, initialized)
