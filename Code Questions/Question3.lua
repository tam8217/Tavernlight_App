function removeSpecificPartyMember(playerId, membername)
    -- Create a local variable for the player Object so that Player methods can be used
    -- Because this is assigning to a non locally scoped Player variable, this is likely something which was defined elsewhere
    -- If this was not defined elsewhere, there needs to be logic in place at the bottom of the script to ensure that the changes which are being made in this locally created player are reflected back to the actual player
    player = Player(playerId)
    -- Getting the current player's party 
    local party = player:getParty()

    -- Create a Player for the Member that is being looked for, so that one does not need to be created each time through the loop
    local partyMemberToRemove = Player(membername)

    -- Looping through the members of the current party to do 
    for k, v in pairs(party:getMembers()) do
        -- Checking if the current member of the party (based on the loop) is the party member for removal
        if v == partyMemberToRemove then
            party:removeMember(partyMemberToRemove)
            -- Breaking now that the specific part member has been removed, no need to do additional checks
            break
        end
    end
end
