local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")

local config = mwse.loadConfig("Arkays Crusader", {
    debug = false,
})

local logger = require("logging.logger")
local log = logger.new{
    name = "Arkays Logger",
    logLevel = "TRACE",
    logToConsole = true,
}

if config.debug then
    log:setLogLevel("DEBUG")
end

require("BeefStranger.Arkays Crusader.holyDamageEffect")




local function initialized()
    print("[MWSE:Arkay's Crusader Initialized]")
end


local spellIds = {
    bsArkaysLight = "bsArkaysLight"
}

local function registerSpells()
    framework.spells.createBasicSpell({
        id = spellIds.bsArkaysLight,
        name = "Arkay's Light",
        effect = tes3.effect.bsHolyDamage,
        range = tes3.effectRange.target,
        min = 1,
        max = 4,
        duration = 10,
    })
end

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
end

local function onKeyDownP()
    if not tes3.menuMode() then
        if config.debug then
            -- tes3.messageBox("P Pressed")
            log:debug("P Pressed")
        end
    end
end

event.register(tes3.event.keyDown, onKeyDownP, { filter = tes3.scanCode["p"] })
event.register("modConfigReady", registerModConfig)
----=======================Debug========================================


event.register(tes3.event.loaded, addSpells)
event.register("MagickaExpanded:Register", registerSpells)
event.register(tes3.event.initialized, initialized)
