Text = {
    text,
    x,
    y,
    size,
    letterSpacing,
    red,
    green,
    blue,
    alpha,
    boxs
}

Temp = {}

function Text:new(_text,_x,_y)
    object = {}
    setmetatable(object, self)
    Text.__index = self
    object.text = _text
    object.x = _x
    object.y = _y
    object.size = 4
    object.letterSpacing = 24
    object.red = 255
    object.green = 255
    object.blue = 255
    object.alpha = 255
    object.boxs = {}
    return object
end

function Text:clean()
    for i=1,#Temp do
        if(Temp[i] == self.boxs) then 
            table.remove(Temp,i)
            break
        end
    end
    for i=1,#self.boxs do
        self.boxs[i]:Hide()
        self.boxs[i] = nil
    end
end

function Text:show()
    for i=1,#self.boxs do
        if(self.boxs[i]~=nil) then
            self.boxs[i]:Show()
        end
    end
end

function Text:hide()
    for i=1,#self.boxs do
        if(self.boxs[i]~=nil) then
            self.boxs[i]:Hide()
        end
    end
end

function Text:setText(_text)
    self.text = _text
    self:clean()
    self:print()
end

function Text:translate(_x,_y)
    self.x = self.x+_x
    self.y = self.x+_y

    if self.boxs ~= nil then
        for i = 1,#self.boxs do
            self.boxs[i]:Set({x = self.boxs[i]:Get().x + _x, y = self.boxs[i]:Get().y + _y})
        end
    end
end

function Text:setColor(_r,_g,_b,_a)
    self.red = _r
    self.green = _g
    self.blue = _b
    self.alpha = _a
    if self.boxs ~= nil then
        for i = 1,#self.boxs do
            self.boxs[i]:Set({r = self.red, g = self.green, b = self.blue, a = self.alpha})
        end
    end
end

function Text:setSize(_size,_letterSpacing)
    self.size = _size
    self.letterSpacing = _letterSpacing
    if self.boxs ~= nil then
        for i = 1,#self.boxs do
            self.boxs[i]:Set({x =i *self.letterSpacing + self.x + x1*self.size, y = self.y - y1*self.size, width = (x2 -x1)*self.size, height = (y2-y1)*-self.size})
        end
    end
end

function Text:print()
    if(#self.boxs == 0) then 
        self.text = string.lower(self.text)
        length = SubStringGetTotalIndex(self.text)
        for i=1,length do
            char = SubStringUTF8(self.text,i,i)
            if(Font[char] ~= nil) then
                for j=1,#Font[char] do
                    x1 = Font[char][j][1]
                    y1 = Font[char][j][2]
                    x2 = Font[char][j][3]
                    y2 = Font[char][j][4]
                    box = UI.Box.Create() 
                    box:Set({x =i *self.letterSpacing + self.x + x1*self.size, y = self.y - y1*self.size , width = (x2 -x1)*self.size, height = (y2-y1)*-self.size, r = self.red, g = self.green, b = self.blue, a = self.alpha})
                    table.insert(self.boxs,box)
                end 
                table.insert(Temp,self.boxs)
            end
        end
    end
end

function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end

function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

function SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end
Font = {}

Font["a"] = {
	{0,0,1,4},
	{2,0,3,4},
	{1,1,2,2},
    {1,4,2,5},
}
Font["b"] = {
	{0,0,1,5},
	{1,0,2,1},
	{1,2,2,3},
    {1,4,2,5},
    {2,1,3,2},
    {2,3,3,4},
};
Font["c"] = {
	{0,1,1,4},
	{1,0,3,1},
	{1,4,3,5},
};
Font["d"] = {
	{0,0,1,5},
	{1,0,2,1},
    {1,4,2,5},
    {2,1,3,4},
};
Font["e"] = {
	{0,1,1,4},
	{1,0,3,1},
    {1,2,3,3},
    {1,4,3,5},
};
Font["f"] = {
	{0,0,1,4},
	{1,2,3,3},
    {1,4,3,5},
};
Font["g"] = {
	{0,1,1,4},
	{1,0,2,1},
    {2,0,3,3},
    {1,4,3,5},
};
Font["h"] = {
	{0,0,1,5},
	{2,0,3,5},
    {1,2,2,3},
};
Font["i"] = {
    {1,0,2,5},
};
Font["j"] = {
    {0,1,1,3},
    {1,0,2,1},
    {2,1,3,5},
};
Font["k"] = {
    {0,0,1,5},
    {2,0,3,2},
    {2,3,3,5},
    {1,2,2,3},
};
Font["l"] = {
    {0,1,1,5},
    {1,0,3,1},
};
Font["m"] = {
    {0,0,1,5},
	{2,0,3,5},
    {1,3,2,4},
};
Font["n"] = {
    {0,0,1,5},
    {1,4,2,5},
    {2,0,3,4},
};
Font["o"] = {
    {0,1,1,4},
    {2,1,3,4},
    {1,0,2,1},
    {1,4,2,5},
}
Font["p"] = {
    {0,0,1,4},
    {1,1,2,2},
    {1,4,2,5},
    {2,2,3,4},
}
Font["q"] = {
    {0,2,1,4},
    {2,2,3,4},
    {1,0,2,2},
    {1,4,2,5},
}
Font["r"] = {
    {0,0,1,4},
    {1,1,2,2},
    {1,4,2,5},
    {2,2,3,4},
    {2,0,3,1},
}
Font["s"] = {
    {0,0,2,1},
    {2,1,3,2},
    {1,2,2,3},
    {0,3,1,4},
    {1,4,3,5},
}
Font["t"] = {
    {0,4,3,5},
    {1,0,2,4},
}
Font["u"] = {
    {0,0,1,5},
    {1,0,2,1},
    {2,1,3,5},
}
Font["v"] = {
    {0,1,1,5},
    {1,0,2,1},
    {2,1,3,5},
}
Font["w"] = {
    {0,0,1,5},
	{2,0,3,5},
    {1,1,2,2},
}
Font["x"] = {
    {0,0,1,2},
	{0,3,1,5},
    {2,0,3,2},
    {2,3,3,5},
    {1,2,2,3},
}
Font["y"] = {
    {0,3,1,5},
    {2,3,3,5},
    {1,0,2,3},
}
Font["z"] = {
    {0,0,3,1},
    {0,4,3,5},
    {0,1,1,2},
    {1,2,2,3},
    {2,3,3,4},
}
Font["0"] = {
    {0,0,1,5},
    {2,0,3,5},
    {1,0,2,1},
    {1,4,2,5},
}
Font["1"] = {
    {1,0,2,5},
    {0,3,1,4},
}
Font["2"] = {
    {0,0,1,3},
    {2,2,3,5},
    {1,0,3,1},
    {1,2,2,3},
    {0,4,2,5},
}
Font["3"] = {
    {2,0,3,5},
    {0,0,2,1},
    {0,2,2,3},
    {0,4,2,5},
}
Font["4"] = {
    {0,2,1,5},
	{2,0,3,5},
    {1,2,2,3},
}
Font["5"] = {
    {0,2,1,5},
	{0,0,3,1},
    {1,2,3,3},
    {1,4,3,5},
    {2,1,3,2},
}
Font["6"] = {
    {0,0,1,5},
	{1,0,3,1},
    {1,2,3,3},
    {1,4,3,5},
    {2,1,3,2},
}
Font["7"] = {
    {0,4,3,5},
    {2,0,3,4},
}
Font["8"] = {
    {0,0,1,5},
    {2,0,3,5},
    {1,0,2,1},
    {1,2,2,3},
    {1,4,2,5},
}
Font["9"] = {
    {0,0,3,1},
    {2,1,3,5},
    {0,2,1,5},
    {1,2,2,3},
    {1,4,2,5},
}
Font["."] = {
    {1,0,2,1},
}
Font[":"] = {
    {1,1,2,2},
    {1,3,2,4},
}
Font["?"] = {
    {1,0,2,1},
    {1,2,2,3},
    {2,2,3,5},
    {0,4,2,5},
}
Font["!"] = {
    {1,0,2,1},
    {1,2,2,5},
}
Font["+"] = {
    {1,1,2,4},
    {0,2,3,3},
}

Font["-"] = {
    {0,2,3,3},
}
Font["("] = {
    {0,1,1,4},
    {1,0,2,1},
    {1,4,2,5},
}
Font["("] = {
    {2,1,3,4},
    {1,0,2,1},
    {1,4,2,5},
}
Font[">"] = {
    {0,0,1,1},
    {1,1,2,2},
    {2,2,3,3},
    {0,4,1,5},
    {1,3,2,4},
}
Font["<"] = {
    {0,2,1,3},
    {1,1,2,2},
    {0,2,1,3},
    {1,3,2,4},
    {2,4,3,5},
}
Font["="] = {
    {0,1,3,2},
    {0,3,3,4},
}
Font["\'"] = {
    {1,3,2,5},
}
Font["\\"] = {
    {0,3,1,5},
    {1,2,2,3},
    {2,0,3,2},
}
Font["/"] = {
    {0,0,1,2},
    {1,2,2,3},
    {2,3,3,5},
}
Font["你"] = {
{3,10,4,12},
{5,8,6,12},
{2,0,3,10},
{6,9,11,10},
{10,8,11,9},
{1,7,2,8},
{4,7,5,8},
{7,0,8,8},
{9,7,10,8},
{0,6,1,7},
{5,3,6,6},
{9,5,10,6},
{10,2,11,5},
{4,2,5,3},
{6,0,7,1},
}
Font["们"] = {
{2,10,3,12},
{4,11,5,12},
{5,10,6,11},
{7,10,11,11},
{1,0,2,10},
{4,0,5,10},
{10,0,11,10},
{0,7,1,8},
{9,0,10,1},
}
Font["好"] = {
{2,8,3,12},
{5,10,10,11},
{9,9,10,10},
{0,8,2,9},
{3,8,5,9},
{8,8,9,9},
{1,5,2,8},
{4,5,5,8},
{7,0,8,8},
{5,5,7,6},
{8,5,11,6},
{0,4,1,5},
{3,3,4,5},
{1,3,2,4},
{2,2,3,3},
{1,1,2,2},
{3,1,4,2},
{0,0,1,1},
{4,0,5,1},
{6,0,7,1},
}
Font["啊"] = {
{0,2,1,11},
{1,10,3,11},
{4,0,5,11},
{5,10,7,11},
{8,10,11,11},
{2,2,3,10},
{6,8,7,10},
{9,0,10,10},
{7,4,8,9},
{8,8,9,9},
{5,6,6,8},
{6,3,7,6},
{8,4,9,5},
{1,3,2,4},
{5,2,6,3},
{8,0,9,1},
}
Font["我"] = {
{3,0,4,12},
{4,11,5,12},
{6,4,7,12},
{1,10,3,11},
{9,10,10,11},
{10,9,11,10},
{0,7,3,8},
{4,7,6,8},
{7,7,11,8},
{9,5,10,6},
{4,4,5,5},
{8,4,9,5},
{2,3,3,4},
{7,2,8,4},
{0,2,2,3},
{6,2,7,3},
{10,0,11,3},
{5,1,6,2},
{8,1,9,2},
{2,0,3,1},
{9,0,10,1},
}
Font["是"] = {
{2,11,9,12},
{2,7,3,11},
{8,7,9,11},
{3,9,8,10},
{3,7,8,8},
{0,5,11,6},
{5,0,6,5},
{2,2,3,4},
{6,3,10,4},
{1,1,2,2},
{3,1,4,2},
{0,0,1,1},
{4,0,5,1},
{6,0,11,1},
}
Font["水"] = {
{5,0,6,12},
{10,9,11,10},
{1,8,4,9},
{6,7,7,9},
{9,8,10,9},
{3,5,4,8},
{8,7,9,8},
{7,5,8,7},
{2,3,3,5},
{8,3,9,5},
{1,2,2,3},
{9,2,10,3},
{0,1,1,2},
{10,1,11,2},
{3,0,5,1},
}
Font["晶"] = {
{2,11,9,12},
{2,7,3,11},
{8,7,9,11},
{3,9,8,10},
{3,7,8,8},
{0,0,1,6},
{1,5,5,6},
{6,0,7,6},
{7,5,11,6},
{4,0,5,5},
{10,0,11,5},
{1,3,4,4},
{7,3,10,4},
{1,1,4,2},
{7,1,10,2},
}
Font["菌"] = {
{3,8,4,12},
{7,7,8,12},
{0,10,3,11},
{4,10,7,11},
{8,10,11,11},
{1,0,2,9},
{2,8,3,9},
{4,8,7,9},
{8,8,10,9},
{9,0,10,8},
{3,6,7,7},
{5,0,6,6},
{2,4,5,5},
{6,4,9,5},
{3,3,4,4},
{7,3,8,4},
{2,2,3,3},
{8,2,9,3},
{2,0,5,1},
{6,0,9,1},
}
Font["这"] = {
{1,11,2,12},
{6,11,7,12},
{2,10,3,11},
{7,9,8,11},
{4,9,7,10},
{8,9,11,10},
{9,7,10,9},
{0,7,3,8},
{5,7,6,8},
{2,2,3,7},
{6,6,7,7},
{8,6,9,7},
{7,5,8,6},
{6,4,7,5},
{8,4,9,5},
{5,3,6,4},
{9,3,10,4},
{4,2,5,3},
{10,2,11,3},
{1,1,2,2},
{3,1,4,2},
{0,0,1,1},
{4,0,11,1},
}
Font["一"] = {
{0,5,11,6},
}
Font["次"] = {
{5,9,6,12},
{0,10,1,11},
{1,9,2,10},
{6,9,11,10},
{4,7,5,9},
{10,8,11,9},
{6,5,7,8},
{9,7,10,8},
{3,6,4,7},
{2,4,3,5},
{5,3,6,5},
{7,3,8,5},
{1,3,2,4},
{0,2,1,3},
{4,2,5,3},
{8,2,9,3},
{3,1,4,2},
{9,1,10,2},
{2,0,3,1},
{10,0,11,1},
}
Font["更"] = {
{0,10,11,11},
{5,2,6,10},
{1,3,2,9},
{2,8,5,9},
{6,8,10,9},
{9,4,10,8},
{2,6,5,7},
{6,6,9,7},
{2,4,5,5},
{6,4,9,5},
{2,2,3,3},
{3,1,5,2},
{0,0,3,1},
{5,0,11,1},
}
Font["新"] = {
{3,10,4,12},
{10,11,11,12},
{1,10,3,11},
{4,10,6,11},
{7,2,8,11},
{8,10,10,11},
{1,8,2,9},
{5,8,6,9},
{2,6,3,8},
{4,6,5,8},
{8,7,11,8},
{0,6,2,7},
{3,0,4,7},
{5,6,6,7},
{9,0,10,7},
{1,4,3,5},
{4,4,6,5},
{1,2,2,3},
{5,2,6,3},
{0,1,1,2},
{6,1,7,2},
{2,0,3,1},
{5,0,6,1},
}
Font["了"] = {
{1,10,10,11},
{9,9,10,10},
{8,8,9,9},
{7,7,8,8},
{6,0,7,7},
{4,0,6,1},
}
Font["中"] = {
{5,0,6,12},
{1,3,2,9},
{2,8,5,9},
{6,8,10,9},
{9,3,10,8},
{2,4,5,5},
{6,4,9,5},
}
Font["文"] = {
{4,11,5,12},
{5,9,6,11},
{0,9,5,10},
{6,9,11,10},
{2,7,3,9},
{8,7,9,9},
{3,5,4,7},
{7,5,8,7},
{4,4,5,5},
{6,4,7,5},
{5,3,6,4},
{4,2,5,3},
{6,2,7,3},
{2,1,4,2},
{7,1,9,2},
{0,0,2,1},
{9,0,11,1},
}
Font["可"] = {
{0,10,11,11},
{9,0,10,10},
{1,2,2,8},
{2,7,7,8},
{6,3,7,7},
{2,3,6,4},
{7,0,9,1},
}
Font["以"] = {
{8,5,9,12},
{1,2,2,11},
{4,10,5,11},
{5,8,6,10},
{4,5,5,6},
{3,4,4,5},
{7,3,8,5},
{2,3,3,4},
{6,2,7,3},
{8,2,9,3},
{4,1,6,2},
{9,1,10,2},
{2,0,4,1},
{10,0,11,1},
}
Font["写"] = {
{0,11,11,12},
{0,10,1,11},
{2,7,3,11},
{10,10,11,11},
{3,8,10,9},
{1,5,2,7},
{2,5,10,6},
{9,1,10,5},
{0,2,8,3},
{6,0,9,1},
}
Font["啦"] = {
    {4,0,5,12},
    {8,11,9,12},
    {0,2,1,11},
    {1,10,3,11},
    {9,10,10,11},
    {2,2,3,10},
    {3,8,4,9},
    {5,8,6,9},
    {7,8,11,9},
    {7,3,8,7},
    {10,4,11,7},
    {5,5,6,6},
    {3,4,4,5},
    {1,3,2,4},
    {9,2,10,4},
    {8,0,9,2},
    {3,0,4,1},
    {6,0,8,1},
    {9,0,11,1},
    }

label = Text:new("你们好啊!",50,200)
label:setSize(3,38)
label:print()

labe2 = Text:new("我是水晶菌!",50,300)
labe2:setSize(4,48)
labe2:setColor(77,122,155,142)
labe2:print()

labe3 = Text:new("这一次更新了中文,可以写中文啦!",50,400)
labe3:setSize(5,58)
labe3:setColor(77,177,222,177)
labe3:print()
