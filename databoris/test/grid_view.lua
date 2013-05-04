
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
local cell_style = {
	font_face  = "Bitstream Vera Sans", 
	font_size  = 14,
	font_width = 6,		
	fore       = 0xe0e0e0, 
	back       = 0x242424, 
	comment    = 0x808080,
	string     = 0xFED8A9,
	keyword    = 0xE4C9C9,
	sel_fore   = 0xffffff, 
	sel_back   = 0x201000, 
	--sel_back   = 0x804000, 
	caret_fore = 0xaaaa88, 
	line_back  = 0x101010, 
}

local cell_models = {
	{ 
		text = "Hello, World! this is ok for now", -- data
		x = 10, y = 10, width = 200, height = 25, -- dimensions
		is_selected = false,
		style  = cell_style,
	},
	{ 
		text = "22", -- data
		x = 10, y = 35, width = 200, height = 25, -- dimensions
		is_selected = false,
		halign = "right",
		style  = cell_style,
	},
	{ 
		text = "Hello, World! ok then", -- data
		x = 210, y = 10, width = 200, height = 25, -- dimensions
		is_selected = true,
		is_primary_selected = true,
		is_current_row = false,
		style  = cell_style,
		halign = "centre",
		valign = "centre",
	},
	{ 
		text = string.format("%0.2f", 12344544.22),
		x = 410, y = 10, width = 20, height = 25, -- dimensions
		is_selected = false,
		is_current_row = true, -- should this be a style
		halign = "right",
		valign = "centre",
		style  = cell_style,
		hash_obs = true,
	},
}

local function draw_cell(hwnd, hdc, model)
	local rect = ffi.new("RECT", {left=model.x, right=model.x + model.width, top=model.y, bottom=model.y + model.height})
	local vm = model.vmargin or 3
	local hm = model.hmargin or 4
	local inset = model.inset or 1

	-- draw bottom/right bg/border (or not if not set)	
	if model.style.line_back then
		local hbrBac = gdi32.CreateSolidBrush(model.style.line_back)
		user32.FillRect(hdc, rect, hbrBac)		
	end
	
	-- draw bg/selection
	rect.right = rect.right - inset
	rect.bottom = rect.bottom - inset
	local hbrBac = gdi32.CreateSolidBrush(model.is_selected and model.style.sel_back or model.is_current_row and model.style.line_back or model.style.back)
	gdi32.SelectObject(hdc, hbrBac)
	user32.FillRect(hdc, rect, hbrBac)
	
	local text = model.text
	if not text then
		return
	end
	
	-- setup font
	local font = gdi32.CreateFontA(model.style.font_size, model.style.font_width, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, model.style.font_face)
	gdi32.SelectObject(hdc, font)
	gdi32.SetTextColor(hdc, model.is_selected and model.style.sel_fore or model.style.fore)
	gdi32.SetTextAlign(hdc, win.TA_BOTTOM)
	gdi32.SetBkMode(hdc, win.TRANSPARENT)
	
	-- calculate size of text
	local size = ffi.new("SIZE[1]")
	gdi32.GetTextExtentPointA(hdc, text, #text, size)
	local cx, cy = size[0].cx, size[0].cy
	print(stringit{cx,cy})
	
	-- we may modify data that cannot all be displayed
	local maxw = model.width - (2 * hm)
	local clipped = false
	if cx > maxw then
		if model.hash_obs then
			text = string.rep("#", #text)
		end
		while cx > maxw do
			text = string.sub(text, 1, -2)
			gdi32.GetTextExtentPointA(hdc, text, #text, size)
			cx, cy = size[0].cx, size[0].cy
		end
		clipped = true
	end
	
	-- calculate text location
	local tx = model.x + hm
	if model.halign == "right" then
		tx = model.x + model.width - cx - hm
	elseif model.halign == "centre" then
		tx = model.x + model.width / 2 - cx / 2 + hm / 2	
	end
	local ty = model.y + model.height - vm
	if model.valign == "top" then
		ty = model.y + cy + vm
	elseif model.valign == "centre" then
		ty = model.y + model.height / 2 + cy / 2 + vm / 2
	end
	
	-- draw text
	gdi32.TextOutA(hdc, tx, ty, text, #text)
	
end

local hbrBac = gdi32.CreateSolidBrush(0x00242424)

local function test(hwnd, hdc)
	-- draw background
	local rect = ffi.new("RECT[1]")
	user32.GetClientRect(hwnd, rect)
	rect[0].right = rect[0].right - rect_width(rect[0])/2+400
	rect[0].left = 100
	user32.FillRect(hdc, rect, hbrBac)
	
	-- draw column headers
	
	-- draw row headers

	-- get visible cell range
	
	-- draw visible cells
	for i,model in ipairs(cell_models) do
		draw_cell(hwnd, hdc, model)
	end
	
	-- draw primary selection
end

return { draw_things = test }
