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
        length = string.len(self.text)
        for i=1,length do
            char = self.text:sub(i,i)
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