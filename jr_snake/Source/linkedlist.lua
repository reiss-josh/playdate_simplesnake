---define linkedlist structure
LList = {}
function LList:new()
    self.first = nil
    self.last = nil
    self.count = 0

    function self:push(value)
        local node = {}
        node.value = value
        if self.first == nil then
            self.first = node
            self.last = node
            self.count = 1
        else
            self.last.next = node
            self.last = node
            self.count = self.count + 1
        end
    end

    function self:pop()
        if self.count == 0 then
        elseif self.count == 1 then
            self.first = nil
            self.last = nil
            self.count = 0
        elseif self.first ~= nil then
            val = self.first.value
            self.first = self.first.next
            self.count = self.count - 1
            return val
        end
    end

    --recursively print node values
    function self:printOutHelper(node, count)
        if(node == nil) then
        else
            if(count == nil) then count = 1 end
            --handle table values in node
            if(type(node.value) == 'table') then
                for index, value in ipairs(node.value) do
                    print(count, value)
                end
            else
                print(node.value)
            end
            self:printOutHelper(node.next, count+1)
        end
    end

    function self:printOut()
        self.printOutHelper(self, self.first, 1)
    end

    return self
end