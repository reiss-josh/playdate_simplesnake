import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import 'linkedlist'
import 'soundmanager'
import 'gridmanager'

-- setup variables
local scl,w,h = 16,25,15 --scale/width/heightt
local pPos,pDir,pSize,pSpeed = {},{},3,2 --player XY/facing/length/speed
gfxMngr = GridManager:new(w,h,scl)

-- helpful inline function
local function bool_to_number(value) return value and 1 or 0 end

-- reset after death/on startup
local function resetGame()
    print('resetting')
    --initialize vars
    pSize = 3 --starting size
    pDir = {1,0} -- starting facing
    pPos = {12,7} -- starting position
    pSpeed = 2 --starting speed
    gfxMngr:initGridArr()
    --setup LList and populate with some nodes
    pLocs = LList:new()
    for i=1,pSize,1 do --
        pLocs:push(pPos)
    end
    --reset graphics
    playdate.graphics.clear()
    gfxMngr:generateFruit()
end

local function getInput()
    LR = bool_to_number(playdate.buttonIsPressed(playdate.kButtonRight)) - bool_to_number(playdate.buttonIsPressed(playdate.kButtonLeft))
    UD = bool_to_number(playdate.buttonIsPressed(playdate.kButtonUp)) - bool_to_number(playdate.buttonIsPressed(playdate.kButtonDown))
    if(LR ~= 0 and pDir[1] == 0
        and not (LR == 1  and pPos[1] == w-1)
        and not (LR == -1 and pPos[1] == 0)
    ) then pDir = {LR,0}
    elseif(UD ~= 0 and pDir[2] == 0
        and not (UD == -1  and pPos[2] == h-1)
        and not (UD == 1 and pPos[2] == 0)
    ) then pDir= {0,UD}
    end
end

local function movePlayer()
    abtToHit = gfxMngr:getPoint(pPos[1]+pDir[1], pPos[2]-pDir[2])
    if(abtToHit == 1) then --check for gameover
        print('zomg!!')
        playdate.wait(500)
        resetGame()
        do return end
    elseif (abtToHit == 2) then --check for fruit
        pSize = pSize+1
        SoundManager:playSound('powerUp')
        gfxMngr:generateFruit()
    elseif (abtToHit == -1) then --check for edge...
        print('hitting')
        if(pDir[1] ~= 0) then --if about to hit x-axis edge, stop moving on x-axis
            pDir[1] = 0 
            if(pPos[2] > h/2) then pDir[2] = 1 --if below halfscreen, go up...
            else pDir[2] = -1 --else go down.
            end
        elseif(pDir[2] ~= 0) then --same thing on y-axis
            pDir[2] = 0
            if(pPos[1] < w/2) then pDir[1] = 1
            else pDir[1] = -1
            end
        end
    end

    pPos = {pPos[1]+pDir[1], pPos[2]-pDir[2]} --update position
    pLocs:push(pPos) --push new player position
    while(pLocs.count > pSize) do --pop nodes until at player size
        oldPos = pLocs:pop()
        --setPoint(oldPos[1],oldPos[2], 0)
        gfxMngr:setPoint(oldPos[1],oldPos[2], 0)
    end
    --setPoint(pPos[1],pPos[2]) --set position at new head
    gfxMngr:setPoint(pPos[1],pPos[2]) --set position at new head
end

resetGame()

function playdate.update()
    getInput()
    movePlayer()
    --playdate.drawFPS(0,0)
    --playdate.timer.updateTimers()
end