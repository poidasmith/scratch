
local win32 = require "win32"

local function map_wndproc(handlers)
	return function(hwnd, msg, wparam, lparam)
		local f = handlers[msg]
		if f ~= nil then
			return f(hwnd, msg, wparam, lparam) 
		end
		return false
	end
end

local function wnd_close(hwnd, msg, wparam, lparam)
	win32.DestroyWindow(hwnd)
	return true, 0
end

local function wnd_lbuttondown(hwnd, ...)
	return true, 0
end

local function wnd_destroy(...)
	win32.PostQuitMessage(0)
	return false, 0
end

local function wnd_erasebknd(...)	
	return false, 0
end

local function wnd_paint(hwnd, msg, wparam, lparam)	
	local ps, hdc = win32.BeginPaint(hwnd)
	
	win32.EndPaint(hwnd, ps)
	return true, 0
end

local main = function(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
	local clz = "lua_test_window"
	local cursor = win32.LoadCursor(win32.IDC_ARROW)
	local icon   = win32.LoadIcon(win32.IDI)
	win32.RegisterClassEx(clz, 0, 0, hInstance, icon, cursor, 11)
	local hwnd = win32.CreateWindowEx( 
		win32.WS_EX_WINDOWEDGE, 
		clz, 
		"The title of my window",
		win32.WS_OVERLAPPEDWINDOW,
		win32.CW_USEDEFAULT,
		win32.CW_USEDEFAULT,
		540,
		420,
		nil,
		nil,
		hInstance,
		nil,
		map_wndproc({
			[win32.WM_CLOSE]       = wnd_close,
			[win32.WM_DESTROY]     = wnd_destroy,
			[win32.WM_LBUTTONDOWN] = wnd_lbuttondown,
			[win32.WM_ERASEBKGND]  = wnd_erasebknd,
			[win32.WM_PAINT]       = wnd_paint
		})
	)
	win32.ShowWindow(hwnd, nCmdShow)
	win32.UpdateWindow(hwnd)		
	return win32.MessageLoop()
end

return main

