jumpWindow = nil
jumpButton = nil
isMoving = nil
jumpScreenButton = nil
initialX = nil
initialY = nil

--- Showing the button in the top right corner of the screen so that it can be clicked on
function online()
    jumpButton:show()
end

--- Hiding the button when the game is closed
function offline()
    jumpWindow:hide()
    jumpButton:setOn(false)
end

--- This function is called when the module is loaded
--- Portions of this script were taken from the spelllist.lua file, as it contained the logic for having a button appear in the top bar, and that was the only way which I could find to easily display the box for the module
function init()
    -- Setting up the initialization functions and for when the game ends
    connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    -- This sets up the Window which is going to be opened upon clicking the button in the top bar and automatically hides it to start
    jumpWindow = g_ui.displayUI('jump')
    jumpWindow:hide()

    -- This grabs the button inside of the screen on the UI, and adds the handler to begin moving the button upon holding down the Left key
    -- I tried out a number of different ways to attempt to get the "Jump!" button to automatically move across the screen, but none of them were consistent or correct enough to work
    -- The primary one I thought may work is adding a "@onGeometryChange: moveLeft(self)" handler to the jump.otui file for the Button, and while this acomplished the goal of having the button move left across the screen, it did so at incredibly fast speeds that were not realistic
    -- I also attempted to hook into events like "@onVisibilityChange" and have the button begin moving when the window was opened, but this also did not work, and having the function in a callback caused a stack overflow
    -- Because of all these reasons, having the button move based on having the button held down was the only consistent way I was able to find which could have the button move at a stable speed, and could still be interacted with
    jumpScreenButton = jumpWindow:getChildById('jumpButtonScreen')
    g_keyboard.bindKeyPress('Left', function()
        moveLeft(jumpScreenButton)
    end, jumpWindow)

    -- This forumla gives the ideal starting position for the "Jump" button based on the size of the window, and it will automatically scale to the correct size of the window
    -- If values were hardcoded for this, the button could appear at strange locations, or even not appear at all
    initialX = jumpWindow:getX() + 318
    initialY = jumpWindow:getY() + 350

    -- This is taken from the spelllist.lua file and makes it so the button appears in the top right corner so the module box can be opened
    jumpButton = modules.client_topmenu.addRightGameToggleButton('jumpButton', tr('Jump'),
        '/images/topbuttons/spelllist', toggle)
    jumpButton:setOn(false)
end

--- This is the partner function to "Init"
function terminate()
    disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })
end

--- This bulk of this function was brought over from the spelllist.lua (the logic for setting the field/window open and focused)
--- My addition is an initialization/reset of the positions of the button so that the button will start in the same place each time the menu is opened  
function toggle()
    if jumpButton:isOn() then
        jumpButton:setOn(false)
        jumpWindow:hide()
    else
        jumpButton:setOn(true)
        jumpWindow:show()
        jumpScreenButton:setX(initialX)
        jumpScreenButton:setY(initialY)
        jumpWindow:raise()
        jumpWindow:focus()
    end
end

--- This function will make the Jump Button move to the left, and when the button gets too far to the left, it will call the function which will reset the position of the button so it can continually loop
function moveLeft(widget)
    if widget:getX() < (jumpWindow:getX() + 50) then
        positionReset(widget)
    end
    widget:setX(widget:getX() - 5)
end

--- This is a function which gets called when the user clicks on the Jump button on the screen, and will force its Y value to be a random value in the box
--- It will also reset the X position back to the initial value so that it can start fresh
--- The values for this reset are based on the intial values so that it can still function with differently sized windows
function positionReset(widget)
    widget:move(initialX, math.random(jumpWindow:getY() + 40, initialY))
end
