
local winnt = require "winnt"

--[[
	testing
]]

local function main(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
	win32.InitCommonControlsEx()
	local clz = "lua_test_window"
	local cursor = win32.LoadCursor(win32.IDC_ARROW)
	local icon   = win32.LoadIcon(win32.IDI_APPLICATION)
	local bg     = win32.GetStockObject(0)
	win32.RegisterClassEx(clz, bitop.orr(CS_VREDRAW, CS_HREDRAW), 0, 0, hInstance, icon, cursor, bg)
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
		win32.map_wndproc({
			[win32.WM_CREATE]      = wnd_create,
			[win32.WM_CLOSE]       = wnd_close,
			[win32.WM_COMMAND]     = wnd_command,
			[win32.WM_DESTROY]     = wnd_destroy,
			[win32.WM_LBUTTONDOWN] = wnd_lbuttondown,
			[win32.WM_RBUTTONDOWN] = wnd_rbuttondown,
			[win32.WM_ERASEBKGND]  = wnd_erasebkgnd,
			[win32.WM_PAINT]       = wnd_paint,
			[win32.WM_SIZE]        = wnd_size
		})
	)
	win32.ShowWindow(hwnd, nCmdShow)
	win32.UpdateWindow(hwnd)		
	return win32.MessageLoop()
end