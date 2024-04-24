-- This function is intended to clean up the player's data and reset it to its default value of -1
local function releaseStorage(player)
    player:setStorageValue(1000, -1)
end

--- This function would be called when a player logs out of the game
function onLogout(player)
    -- This is checking if there is a specific value inside of this specific part of the player's data
    if player:getStorageValue(1000) == 1 then
        -- By having this inside of addEvent which adds in a delay for when the function is called, there could potentially be an issue where the player is logged out prior to the script executing
        -- The solution I would propose is to remove the time before the callback to ensure that that function properly runs before the player logs out and there is no chance it could be missed
        -- If logic needed to be added to remove something after a player logs out, then that functionality could be taken to a server script so that it is not reliant on whether the user still has their client open to run
        -- addEvent(releaseStorage, 1000, player)
        addEvent(releaseStorage, 0, player)

    end
    return true
end
