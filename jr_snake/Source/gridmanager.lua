local gfx = playdate.graphics
gfx.setColor(gfx.kColorBlack)

GridManager = {}
function GridManager:new(w,h,scl)
    self.w = w
    self.h = h
    self.scl = scl
    self.gridArr = {}
    for x = 0, w do
        for y = 0, h do
            self.gridArr[x + w*y] = 0
        end
    end

    function self:initGridArr()
        for x = 0, w do
            for y = 0, h do
                self.gridArr[x + w*y] = 0
            end
        end
    end

    function self:setPoint(x,y, value)
        value = value or 1
        self.gridArr[x + y*self.w] = value
        if(value == 0) then --empty
            gfx.setColor(gfx.kColorWhite)
            gfx.fillRect(x*scl, y*scl, scl, scl, 2)
        elseif(value == 1) then --snake
            gfx.fillRect(x*scl, y*scl, scl, scl, 2)
        elseif(value == 2) then --fruit
            gfx.fillRoundRect(x*scl, y*scl, scl, scl, 10)
        end
        if(gfx.Color ~= gfx.kColorBlack) then gfx.setColor(gfx.kColorBlack) end
    end

    function self:getPoint(x,y)
        if((x < 0) or (y < 0) or (x > self.w-1) or (y > self.h-1))  then return -1
        else return self.gridArr[x + y*self.w]
        end
    end

    function self:generateFruit()
        local succ = false
        while succ == false do
            fx = math.random(0,self.w-1)
            fy = math.random(0,self.h-1)
            if(self.getPoint(self,fx,fy) == 0) then succ = true end
        end
        self.setPoint(self,fx,fy,2)
    end

    return self
end