
local ffi, bit, win, ui, user32, gdi32 = require "setup" ()

local function rect_new(x, y, width, height)
	return ffi.new("RECT", {left=x, right=x+width, top=y, bottom=y+height})	
end

local function text_size(hdc, text)
	local size = ffi.new("SIZE[1]")
	gdi32.GetTextExtentPointA(hdc, text, #text, size)
	local cx, cy = size[0].cx, size[0].cy
	--print(stringit{text=text, cx=cx, cy=cy})
	return cx, cy
end

local function draw_cell(hwnd, hdc, model)
	local rect = rect_new(model.x, model.y, model.width, model.height)
	local vm = model.vmargin or 3
	local hm = model.hmargin or 4
	local inset = model.inset or 1

	-- TODO: rounded rect? eg for pop out
	-- TODO: borders/selection

	-- draw bottom/right bg/border (or not if not set)	
	if model.style.line_back then
		local hbrBac = gdi32.CreateSolidBrush(model.style.line_back)
		user32.FillRect(hdc, rect, hbrBac)		
	end	
	
	-- draw bg/selection
	rect.right = rect.right - inset
	rect.bottom = rect.bottom - inset
	-- TODO: style should manage choice of bg
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
	gdi32.SetTextColor(hdc, model.is_selected and model.style.sel_fore or model.style.fore) -- TODO: move into style
	gdi32.SetTextAlign(hdc, win.TA_BOTTOM)
	gdi32.SetBkMode(hdc, win.TRANSPARENT)
	
	-- calculate size of text
	local cx, cy = text_size(hdc, text)
	
	-- we may modify data that cannot all be displayed
	local maxw = model.width - (2 * hm)
	local clipped = false
	if cx > maxw then
		if model.hash_obs then
			text = string.rep("#", #text)
		end
		while cx > maxw do
			text = string.sub(text, 1, -2)
			cx, cy = text_size(hdc, text)
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

--local hbrBac = gdi32.CreateSolidBrush(0x00242424)
--user32.FillRect(hdc, rect, hbrBac)

local function test(hwnd, hdc, model)
	-- draw cells (including headers)
	for i, cm in model:visible_cells() do
		draw_cell(hwnd, hdc, cm)
	end

	-- draw primary selection
end

return { draw_things = test }
