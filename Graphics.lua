Graphics = (function()
    local Graphics = {
        id = 1,
        root = {},
        color = {255,255,255,255},
    };

    function Graphics:DrawRect(x,y,width,height)
        local box = UI.Box.Create();
        if box == nil then
            print("无法绘制矩形:已超过最大限制");
            return;
        end
        box:Set({x=x,y=y,width=width,height=height,r=self.color[1],g=self.color[2],b=self.color[3],a=self.color[4]});
        box:Show();
        self.root[#self.root + 1] = {self.id,{box}};
        self.id = self.id + 1;
        return self.id - 1;
    end

    function Graphics:DrawText(x,y,size,letterspacing,text)
        local str = {
            array = {},
            length = 0,
            charAt = function(self,index)
                if index > 0 and index <= self.length then
                    return self.array[index];
                end
                print("数组下标越界");
            end,
        };
        local currentIndex = 1;
        while currentIndex <= #text do
            local cs = 1;
            local seperate = {0, 0xc0, 0xe0, 0xf0};
            for i = #seperate, 1, -1 do
                if string.byte(text, currentIndex) >= seperate[i] then
                    cs = i;
                    break;
                end
            end
            str.array[#str.array+1] = string.sub(text,currentIndex,currentIndex+cs-1);
            currentIndex = currentIndex + cs;
            str.length = str.length + 1;
        end
        self.root[#self.root + 1] = {self.id,{}};
        for i=1,str.length do
            local char = str:charAt(i)
            if Font[char] == nil then
                char = '?';
            end
            for j = 1,#Font[char],4 do
                local x1 = Font[char][j];
                local y1 = Font[char][j+1];
                local x2 = Font[char][j+2];
                local y2 = Font[char][j+3];

                local box = UI.Box.Create();
                if box == nil then
                    print("无法绘制矩形:已超过最大限制");
                    return;
                end
                if i == 1 then
                    box:Set({x=x + x1*size,y=y + (12 - y2)*size,width=(x2 - x1)*size,height=(y2 - y1)*size,r=self.color[1],g=self.color[2],b=self.color[3],a=self.color[4]});
                else
                    box:Set({x=x + (i-1) * letterspacing + x1*size,y=y + (12 - y2)*size,width=(x2 - x1)*size,height=(y2 - y1)*size,r=self.color[1],g=self.color[2],b=self.color[3],a=self.color[4]});
                end
                (self.root[#self.root][2])[#self.root[#self.root][2] + 1] = box;
                box:Show();
            end
        end
        self.id = self.id + 1;
        return self.id - 1;
    end

    function Graphics:Remove(id)
        for i = 1,#self.root do
            if self.root[i][1] == id then
                self.root[i] = nil;
                collectgarbage("collect");
                return;
            end
        end
    end

    function Graphics:Show(id)
        for i = 1,#self.root do
            if self.root[i][1] == id then
                for j = 1,#self.root[i][2] do
                    self.root[i][2][j]:Show();
                end
                return;
            end
        end
    end

    function Graphics:Hide(id)
        for i = 1,#self.root do
            if self.root[i][1] == id then
                for j = 1,#self.root[i][2] do
                    self.root[i][2][j]:Hide();
                end
                return;
            end
        end
    end

    function Graphics:GetTextSize(length,fontsize,letterspacing)
        if length == 0 then
            return 0,12 * fontsize;
        end
        local width = (length - 1) * letterspacing + 11 * fontsize;
        local height = 12 * fontsize;
        return width,height;
    end

    
    function Graphics:Clean()
        self.root = {};
        collectgarbage("collect");
    end

    return Graphics;
end)();

Graphics.color = {222,55,12,255}
local box1 = Graphics:DrawRect(0,0,128,30);

local text1 = Graphics:DrawText(30,100,2,48,"你们好,我是iPad水晶,这个脚本是我写滴");
local text2 = Graphics:DrawText(30,160,4,88,"QQ:1419427247");


Graphics.color = {255,255,255,255}
local text3 = Graphics:DrawText(50,400,2,48,"请在聊天框输入文字");
function UI.Event:OnChat(text)
    Graphics:Remove(text3);
    text3 = Graphics:DrawText(50,400,2,36,text);
end