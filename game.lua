Field = {}
Field.__index = Field

function Field:new()
    local obj = {}
    setmetatable(obj, Field)
    obj.size = 10
    obj.colors = {"A", "B", "C", "D", "E", "F"}
    obj.grid = {}
    obj:init()

    return obj
end

function Field:init()
    for i = 1, self.size do
        self.grid[i] = {}
        for j = 1, self.size do
            self.grid[i][j] = self.colors[math.random(#self.colors)]
        end
    end
end

function Field:dump()
    io.write("  ")

    for i = 1, self.size do
        io.write(i - 1, " ")
    end

    print()

    for i = 1, self.size do
        io.write(i - 1, "| ")
        
        for j = 1, self.size do
            io.write(self.grid[i][j], " ")
        end

        print()
    end
end

function Field:move(from_x, from_y, to_x, to_y)
    local temp = self.grid[from_x][from_y]
    self.grid[from_x][from_y] = self.grid[to_x][to_y]
    self.grid[to_x][to_y] = temp
end

function Field:remove_matches()
    local matches = {}
    
    for i = 1, self.size do
        for j = 1, self.size - 2 do
            if self.grid[i][j] == self.grid[i][j + 1] and self.grid[i][j + 1] == self.grid[i][j + 2] then
                table.insert(matches, {i, j})
                table.insert(matches, {i, j + 1})
                table.insert(matches, {i, j + 2})
            end
        end
    end

    for i = 1, self.size - 2 do
        for j = 1, self.size do
            if self.grid[i][j] == self.grid[i + 1][j] and self.grid[i + 1][j] == self.grid[i + 2][j] then
                table.insert(matches, {i, j})
                table.insert(matches, {i + 1, j})
                table.insert(matches, {i + 2, j})
            end
        end
    end

    for _, match in ipairs(matches) do
        self.grid[match[1]][match[2]] = nil
    end
end

function Field:fall()
    for j = 1, self.size do
        local empty_slots = {}
        for i = self.size, 1, -1 do
            if self.grid[i][j] == nil then
                table.insert(empty_slots, i)
            elseif #empty_slots > 0 then
                local empty_slot = table.remove(empty_slots)
                self.grid[empty_slot][j] = self.grid[i][j]
                self.grid[i][j] = nil
                table.insert(empty_slots, i)
            end
        end
    end
end

function Field:fill()
    for i = 1, self.size do
        for j = 1, self.size do
            if self.grid[i][j] == nil then
                self.grid[i][j] = self.colors[math.random(#self.colors)]
            end
        end
    end
end

function main()
    local field = Field:new()
    field:dump()

    while true do
        io.write("> ")
        local input = io.read()
        
        if input == "q" then
            break
        end

        local _, from_x, from_y, direction = string.match(input, "(%w) (%d) (%d) (%a)")
        from_x, from_y = tonumber(from_x) + 1, tonumber(from_y) + 1

        if direction == "r" and from_y < field.size then
            field:move(from_x, from_y, from_x, from_y + 1)
        elseif direction == "l" and from_y > 1 then
            field:move(from_x, from_y, from_x, from_y - 1)
        elseif direction == "u" and from_x > 1 then
            field:move(from_x, from_y, from_x - 1, from_y)
        elseif direction == "d" and from_x < field.size then
            field:move(from_x, from_y, from_x + 1, from_y)
        end

        field:remove_matches()
        field:fall()
        field:fill()
        field:dump()
    end
end

main()
