
local ffi, bit, win, ui, user32, gdi32 = require "setup" ()

local grv = require "grid_view"
local grm = require "grid_model"
local grc = require "grid_controller" 
local file_watcher = require "file_watcher"

local model = grm.build()

local ps = ffi.new("PAINTSTRUCT")
local function wm_paint(hwnd, msg, wparam, lparam)
	local hdc = user32.BeginPaint(hwnd, ps)

	-- invoke our view	
	grv.draw_things(hwnd, hdc, model)
	
	user32.EndPaint(hwnd, ps)
end

local function wm_create(hwnd, msg, wparam, lparam)
	user32.SetTimer(hwnd, 100, 1000, 0)
end

local function wm_close(hwnd, msg, wparam, lparam)
	user32.DestroyWindow(hwnd)
end

local function wm_destroy(...)
	user32.PostQuitMessage(0)
end

local function wm_timer(hwnd, msg, wparam, lparam)
	live.check(hwnd)
end

local handlers = {
	[win.WM_CREATE]   = wm_create,
	[win.WM_PAINT]    = wm_paint,
	[win.WM_SIZE]     = wm_size,
	[win.WM_CLOSE]    = wm_close,
	[win.WM_DESTROY]  = wm_destroy,
	[win.WM_NOTIFY]   = wm_notify,
	[win.WM_SETFOCUS] = wm_setfocus,
	[win.WM_KEYDOWN]  = wm_keydown,
	[win.WM_TIMER]    = wm_timer,
}

-- run loop
local mainWin = ui.window("DBOS_grid", handlers, "dbos [grid]")
user32.MoveWindow(mainWin, 10, 300, 1200, 650, true)
ui.show(mainWin, win.SW_SHOW)
ui.update(mainWin)
return ui.run() 
