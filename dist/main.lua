--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
robot = require("robot")
comp = require("computer")
Miner = __TS__Class()
Miner.name = "Miner"
function Miner.prototype.____constructor(self, karer, lvl, isBur)
    self.karer = 0
    self.lvl = 0
    self.isBur = false
    self.depth = 0
    self.xPos = 0
    self.zPos = 0
    self.xDir = 0
    self.zDir = 1
    self.done = false
    self.alternate = 0
    self.karer = karer
    self.lvl = lvl
    self.isBur = isBur
end
__TS__SetDescriptor(
    Miner.prototype,
    "ISize",
    {
        get = function(self)
            return robot:inventorySize()
        end
    }
)
__TS__SetDescriptor(
    Miner.prototype,
    "power",
    {
        get = function(self)
            return comp:energy()
        end
    }
)
__TS__SetDescriptor(
    Miner.prototype,
    "maxPower",
    {
        get = function(self)
            return 20200
        end
    }
)
__TS__SetDescriptor(
    Miner.prototype,
    "isFull",
    {
        get = function(self)
            local invFull = true
            do
                local i = 3
                while i < self.ISize do
                    if robot:count(i) == 0 then
                        invFull = false
                    end
                    i = i + 1
                end
            end
            if invFull then
                print("Пустых слотов не осталось")
            end
            return invFull
        end
    }
)
function Miner.prototype.busy(self, time)
    os.sleep(time)
end
function Miner.prototype.unload(self)
    local tryLoad = 1
    local maxTryLoad = 30
    robot:select(1)
    while not robot:compare() do
        print("Разные сундуки перед роботом и в слоте 1. Ждем 30 секунд и пробую ещё раз...")
        if tryLoad <= maxTryLoad then
            (((tryLoad == maxTryLoad) and (function() return print("Пробую последний раз!") end)) or (function() return print(
                (("Попытка " .. tostring(tryLoad)) .. " из ") .. tostring(maxTryLoad)
            ) end))()
            self:busy(30)
            tryLoad = tryLoad + 1
        else
            print(
                ("Я пробовал " .. tostring(maxTryLoad)) .. " раз, но сундука так и не встретил!"
            )
            robot:turnAround()
            return false
        end
    end
    print("Сундук найден. Выгружаюсь...")
    do
        local i = 3
        while i < self.ISize do
            robot:select(i)
            while robot:count(i) > 0 do
                robot:drop()
            end
            i = i + 1
        end
    end
    print("Выгрузился! Поехал дальше...")
    return true
end
function Miner.prototype.TurnLeft(self)
    robot:turnLeft()
    self.xDir = -self.zDir
    self.zDir = self.xDir
end
function Miner.prototype.TurnRight(self)
    robot:turnRight()
    self.xDir = self.zDir
    self.zDir = -self.xDir
end
function Miner.prototype.GoTo(self, x, y, z, xd, zd)
    while self.depth > y do
        if robot:up() then
            self.depth = self.depth - 1
        else
            if robot:swingUp() then
                ((self.isFull and (function() return self:busy(5) end)) or (function() return print("Эмм... что-то не то...") end))()
            end
        end
    end
    if self.xPos > x then
        while self.xDir ~= -1 do
            self:TurnLeft()
        end
        while self.xPos > x do
            if robot:forward() then
                self.xPos = self.xPos - 1
            else
                if robot:swing() then
                    ((self.isFull and (function() return self:busy(5) end)) or (function() return print("Эмм... что-то не то...") end))()
                end
            end
        end
    elseif self.xPos < x then
        while self.xDir ~= 1 do
            self:TurnLeft()
        end
        while self.xPos < x do
            if robot:forward() then
                self.xPos = self.xPos + 1
            else
                if robot:swing() then
                    ((self.isFull and (function() return self:busy(5) end)) or (function() return print("Эмм... что-то не то...") end))()
                end
            end
        end
    end
    if self.zPos > z then
        while self.zDir ~= -1 do
            self:TurnLeft()
        end
        while self.zPos > z do
            if robot:forward() then
                self.zPos = self.zPos - 1
            else
                if robot:swing() then
                    ((self.isFull and (function() return self:busy(5) end)) or (function() return print("Эмм... что-то не то...") end))()
                end
            end
        end
    elseif self.zPos < z then
        while self.zDir ~= 1 do
            self:TurnLeft()
        end
        while self.zPos < z do
            if robot:forward() then
                self.zPos = self.zPos + 1
            else
                if robot:swing() then
                    ((self.isFull and (function() return self:busy(5) end)) or (function() return print("Эмм... что-то не то...") end))()
                end
            end
        end
    end
    while self.depth < y do
        if robot:down() then
            self.depth = self.depth + 1
        else
            if robot:swingDown() then
                ((self.isFull and (function() return self:busy(5) end)) or (function() return print("Эмм... что-то не то...") end))()
            end
        end
    end
    while (self.zDir ~= zd) or (self.xDir ~= xd) do
        self:TurnLeft()
    end
end
function Miner.prototype.Refuel(self)
    local x = self.xPos
    local y = self.depth
    local z = self.zPos
    local xd = self.xDir
    local zd = self.zDir
    print("Возврат к точке старта...", x, y, z, xd, zd)
    self:GoTo(0, 0, 0, 0, -1)
    self:unload()
    while self.power < self.maxPower do
        print("Пробуем зарядиться...")
        self:busy(60)
    end
    print("Продолжаю добычу...")
    self:GoTo(x, y, z, xd, zd)
end
function Miner.prototype.ReturnStart(self)
    local x = self.xPos
    local y = self.depth
    local z = self.zPos
    local xd = self.xDir
    local zd = self.zDir
    print("Возврат к точке старта...", x, y, z, xd, zd)
    self:GoTo(0, 0, 0, 0, -1)
    self:unload()
    print("Продолжаю добычу...")
    self:GoTo(x, y, z, xd, zd)
end
function Miner.prototype.RobotForward(self)
    if self.isFull then
        self:ReturnStart()
    end
    local i = 0
    if self.power < 5000 then
        self:Refuel()
    end
    repeat
        do
            robot:swing()
            i = i + 1
            if i == 50 then
                return false
            end
        end
    until robot:detect()
    robot:forward()
    self.xPos = self.xPos + self.xDir
    self.zPos = self.zPos + self.zDir
    return true
end
function Miner.prototype.RobotBack(self)
    if self.isFull then
        self:ReturnStart()
    end
    local i = 0
    if self.power < 5000 then
        self:Refuel()
    end
    repeat
        do
            robot:turnAround()
            robot:swing()
            i = i + 1
            if i == 50 then
                return false
            end
        end
    until robot:detect()
    robot:forward()
    self.xPos = self.xPos - self.xDir
    self.zPos = self.zPos - self.zDir
    robot:turnAround()
    return true
end
function Miner.prototype.RobotDown(self)
    if self.isFull then
        self:ReturnStart()
    end
    local i = 1
    repeat
        do
            robot:swingDown()
            i = i + 1
            if i == 30 then
                return false
            end
        end
    until robot:detectDown()
    robot:down()
    self.depth = self.depth + 1
    if math.fmod(self.depth, 10) == 0 then
        print(
            ("Спустились на " .. tostring(self.depth)) .. " блоков."
        )
    end
    return true
end
function Miner.prototype.StartQuarry(self, karer)
    while not self.done do
        if self.power < 5000 then
            self:Refuel()
        end
        do
            local i = 1
            while i < karer do
                do
                    local j = 1
                    while j < (karer - 1) do
                        if not self:RobotForward() then
                            self.done = true
                            print("Done")
                            break
                        end
                        j = j + 1
                    end
                end
                if i < karer then
                    if math.fmod(i + self.alternate, 2) == 0 then
                        if self.isBur then
                            if not self:RobotBack() then
                                self.done = true
                                break
                            end
                            self:TurnLeft()
                            do
                                local i = 0
                                while i < 4 do
                                    if not self:RobotForward() then
                                        self.done = true
                                        break
                                    end
                                    i = i + 1
                                end
                            end
                            if not self:RobotBack() then
                                self.done = true
                                break
                            end
                            self:TurnLeft()
                            if not self:RobotForward() then
                                self.done = true
                                break
                            end
                        else
                            self:TurnLeft()
                            if not self:RobotForward() then
                                self.done = true
                                break
                            end
                            self:TurnLeft()
                        end
                    else
                        if self.isBur then
                            if not self:RobotBack() then
                                self.done = true
                                break
                            end
                            self:TurnRight()
                            do
                                local i = 0
                                while i < 4 do
                                    if not self:RobotForward() then
                                        self.done = true
                                        break
                                    end
                                    i = i + 1
                                end
                            end
                            if not self:RobotBack() then
                                self.done = true
                                break
                            end
                            self:TurnRight()
                            if not self:RobotForward() then
                                self.done = true
                                break
                            end
                        else
                            self:TurnRight()
                            if not self:RobotForward() then
                                self.done = true
                                break
                            end
                            self:TurnRight()
                        end
                    end
                end
                if self.done then
                    print("Done")
                    break
                end
                i = i + 1
            end
        end
        print(
            "Глубина " .. tostring(self.depth)
        )
        if self.done then
            print("Done")
        end
        if not self:RobotDown() then
            self.done = true
            print("Done")
            break
        end
    end
end
print("Каков будет размер карьера?")
karer = __TS__Number(
    {
        io:read()
    }
)
print("На сколько блоков опуститься перед началом ?")
levelStart = __TS__Number(
    {
        io:read()
    }
)
miner = __TS__New(Miner, karer, levelStart, true)
if levelStart ~= 0 then
    miner:GoTo(0, levelStart, 0, miner.xDir, miner.zDir)
end
if miner.power < 5000 then
    miner:Refuel()
end
print("Копаем...")
if not miner:RobotForward() then
    print("Done")
    if not miner:RobotDown() then
        print("Done")
    else
        robot:select(3)
        miner:StartQuarry(karer)
    end
end
miner:GoTo(0, 0, 0, 0, -1)
miner:unload()
miner:GoTo(0, 0, 0, 0, 1)
