local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local config = mwse.loadConfig("Arkays Crusader", {
    debug = false,
})

local logger = require("logging.logger")
local log = logger.new{
    name = "Arkays Logger",
    logLevel = "WARN",
    logToConsole = true,
}

if config.debug then; log:setLogLevel("DEBUG"); end
require("BeefStranger.Arkays Crusader.holyDamageEffect")

local function initialized()
    print("[MWSE:Arkay's Crusader Initialized]")
end

local spellIds = {
    bsArkaysLight = "bsArkaysLight",
    bsAbility = "bsAbility"
}

local spell = tes3.objectType.spell


local function registerSpells()
    -- framework.spells.createBasicSpell({ --Works perfectly but trying something else
    --     id = spellIds.bsArkaysLight,
    --     name = "Arkay's Light",
    --     effect = tes3.effect.bsHolyDamage,
    --     range = tes3.effectRange.target,
    --     min = 1,
    --     max = 4,
    --     duration = 10,
    -- })

    local bsArkaysLightT = tes3.createObject({ --The built in way to create a spell, lets me use castType, Snippet = createSpell
        objectType = spell,
        id = "bsArkaysLightT",
        name = "createObject Arkay",
        effects = {{
            id = tes3.effect.bsHolyDamage,
            min = 5,
            max = 5,
            duration = 10,
            rangeType = tes3.effectRange.target
        }}
    })

    local bsAbility = tes3.createObject({ --[[@as tes3spell]]
        objectType = tes3.objectType.spell,
        castType = tes3.spellType.ability,
        id = "bsAbility",
        name = "Test Ability",
        --[[@tes3effect]]
        effects = {{ 
            id = tes3.effect.chameleon,
            min = 10,
            max = 10,
            rangeType = tes3.effectRange.self
        }}
    }) 




    -- framework.spells.createBasicSpell({ --Cant get it to add castType
    --     id = spellIds.bsAbility,
    --     name = "Test Ability",
    --     castType = tes3.spellType.ability,
    --     effect = tes3.effect.chameleon,
    --     range = tes3.effectRange.self,
        
    --     min = 25,
    --     max = 25,
    -- })
end

event.register("loaded", registerSpells)

local function addSpells()
    if config.debug then
        tes3.addSpell({ reference = tes3.mobilePlayer, spell = "bsArkaysLight" })
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
    page:createDropdown{
        label = "Logging Level",
        description = "Set the log level.",
        options = {
            { label = "TRACE", value = "TRACE"},
            { label = "DEBUG", value = "DEBUG"},
            { label = "INFO", value = "INFO"},
            { label = "WARN", value = "WARN"},
            { label = "ERROR", value = "ERROR"},
            { label = "NONE", value = "NONE"},
        },
        variable = mwse.mcm.createTableVariable{ id = "logLevel", table = config },
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
        tes3.addSpell({ reference = tes3.mobilePlayer, spell = "bsArkaysLightT" })
    end
end

event.register("keyDown", onKeyDownI, { filter = tes3.scanCode["i"] })
event.register("keyDown", onKeyDownP, { filter = tes3.scanCode["p"] })
event.register("modConfigReady", registerModConfig)
----=======================Debug========================================


event.register(tes3.event.loaded, addSpells)
-- event.register("MagickaExpanded:Register", registerSpells)
event.register(tes3.event.initialized, initialized)
