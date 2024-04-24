function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    -- Creates a query string to specifically get names from the Guilds table where the max membersof the guild is less than parameter 
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    -- Making the call to the database, using the string.format to pass in the max members to compare with
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    -- Confirm that a value was returned from the database, otherwise there may be an error trying to access values from it
    -- As I was not familiar with how the Result object worked from the db.storeQuery, I had to look online for it, and this seemed to be the standard way to check that it had a value (rather than doing a check of the length of the object returned)
    if resultId then
        -- If there was a result found, then the results need to be iterated through to properly list out all of the results rather than just one
        repeat
            -- Print out the current result's string - this will be the Guild Name (slightly more efficient, though less verbose, to just print the result without storing it in a variable)
            print(result.getString("name"))

            -- This is intended to run until there are no more results available to list out, and this is important so that there are not any blank results printed
        until result.next(resultId)
    end
end
