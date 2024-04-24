// This function adds an item (itemId) to a specific player (Recipient)
void Game::addItemToPlayer(const std::string &recipient, uint16_t itemId)
{
    // Using the 'getPlayerByName' function to retrieve a reference to the specific player based on their name which is passed in
    Player *player = g_game.getPlayerByName(recipient);

    // If there is no player which is found in the current game for that name (this means that 'getPlayersByName' returned a null pointer)
    if (!player)
    {
        // Assigning the player to a new player Object set with a null pointer
        player = new Player(nullptr);

        // If there is no player found by checking against offline players(?) ((this is anotehr null pointer check)), then break out of the function without further checks
        if (!IOLoginData::loadPlayerByName(player, recipient))
        {
            return;
        }
    }

    // Creating an Item Object based on the passed in Item ID
    Item *item = Item::CreateItem(itemId);

    // If the Item is a null pointer, then break out of the function because it cannot be added
    if (!item)
    {
        return;
    }

    // Adding the Item to the player's inbox whether they are online or offline
    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    // If the user was offline, save their user, otherwise it should be happening while the user is still in the game (?)
    if (player->isOffline())
    {
        IOLoginData::savePlayer(player);
    }

    // The player needs to be deleted, because inside of the initial If statement, it is set with "new"
    delete player;

    // The Item also should be deleted, as at this point in the function it is not a Null Pointer, and as such it does not need to continue taking up space. This is assuming that the "CreateItem" function calls "new" somewhere inside of it
    delete item;
}