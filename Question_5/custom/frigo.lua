--- A portion of the functionality for this file is brought over from the Apocolaypse.lua file as a way to emulate the effects of a combat spell which had its effects run multiple times
--- This function here is used to have the tornado effects of the spell happen multiple times after the initial cast
function spellCallback(cid, position, count)
    if Creature(cid) then
        -- The function brings this over so that it does not duplicate intial damage and effects and will wait until the intial cast is done to do damage
        if count > 0 then
            position:sendMagicEffect(CONST_ME_ICETORNADO)
            doAreaCombat(cid, COMBAT_ICEDAMAGE, position, 0, -2, -2, CONST_ME_ICETORNADO)
        end

        -- This causes the spell to only run a certain number of times, and 'addEvent' allows there to be a delay between callbacks so that the effects are not happening continously
        -- I was unable to find a way to have the spell be rotated (in terms of the sprites, as the example video has the blue tornadoes at the left/right sides, whereas the default CONST_ME_ICETORNADO has the gray tornadoes on left/right), or how to get certain parts of the spell's effects to dissappear/reappear while keeping other stationary
        -- This may be possible by finding the individual sprites and creating being able to manually (or even randomly) decide what portions of a spell's effects get called and when they dissappear
        if count < 4 then
            count = count + 1
            addEvent(spellCallback, 800, cid, position, count)
        end
    end
end

--- This is the function which begins calling the callback to have the spell run multiple times
function onTargetTile(creature, position)
    spellCallback(creature:getId(), position, 0)
end

-- These are the settings which get set up for spell to actually do damage (the first time), as well as the effect which will show for it
-- I selected the "AREA_CIRCLE3X3" for the area of the spell because that is what seemed to most closely match the video example 
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

--- This is the function which gets the potential values for damage of the spell
function onGetFormulaValues(player, level, magicLevel)
    local min = (level / 5) + (magicLevel * 5.5) + 25
    local max = (level / 5) + (magicLevel * 11) + 50
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

--- This is the function which gets the spell to begin casting 
function onCastSpell(creature, variant)
    return combat:execute(creature, variant)
end
