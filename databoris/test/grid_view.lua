
local ffi, bit, win, ui, user32, gdi32 = require "setup" ()

local function rect_width(rect)
	return rect.right-rect.left
end

local function draw(hwnd, hdc, model)
end


local view = {
	state = { all_dirty = false, },
	
	paint = function(hdc) end,
}


local function draw_row(hwnd, hdc, model)
end


--[[
	data
	formatter (data -> string)
	set of styles
		- background
		- borders
		- font type, size, style
		- horizontal/vert alignment
		- 
]]

local function draw_cell(hwnd, hdc, model)
end

--local hbrBac = gdi32.CreateSolidBrush(0x00242424)
local hbrBac = gdi32.CreateSolidBrush(0x00ffaa24)


local function test(hwnd, hdc)
	--gdi32.SelectObject(hdc, hbrBac)
	local rect = ffi.new("RECT[1]")
	user32.GetClientRect(hwnd, rect)
	rect[0].right = rect[0].right - rect_width(rect[0])/2+400
	rect[0].left = 100
	user32.FillRect(hdc, rect, hbrBac)
end

return { draw_things = test }