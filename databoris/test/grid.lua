
local ffi, bit, win, ui, user32, gdi32 = require "setup" ()
local grn = require "grid_render"

local hbrBac = gdi32.CreateSolidBrush(0x00242424)

--[[
 calculate the span of rows and cols that are visible
   - height, width, x_offset, y_offset
]]

local function wm_paint(hwnd, msg, wparam, lparam)	
	local ps = nil
	local hdc = wparam
	if hdc == 0 then
		ps = ffi.new("PAINTSTRUCT")
		hdc = user32.BeginPaint(hwnd, ps)
	end
	
	-- draw background
	gdi32.SetBkMode(hdc, win.TRANSPARENT);
	local rect = ffi.new("RECT")
	user32.GetClientRect(hwnd, rect)
	user32.FillRect(hdc, rect, hbrBac)
end

local function wm_close(hwnd, msg, wparam, lparam)
	user32.DestroyWindow(hwnd)
end

local function wm_destroy(...)
	user32.PostQuitMessage(0)
end


local handlers = {
	[win.WM_PAINT]    = wm_paint,
	[win.WM_SIZE]     = wm_size,
	[win.WM_CLOSE]    = wm_close,
	[win.WM_DESTROY]  = wm_destroy,
	[win.WM_NOTIFY]   = wm_notify,
	[win.WM_SETFOCUS] = wm_setfocus,
	[win.WM_KEYDOWN]  = wm_keydown,
}

local mainWin = ui.window("DBOS_grid", handlers, "dbos [grid]")

-- run loop
user32.MoveWindow(mainWin, 10, 300, 1200, 650, true)
ui.show(mainWin, win.SW_SHOW)
ui.update(mainWin)
ui.run() 
