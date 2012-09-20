
local win32 = require "win32"
local log   = require "log"

local ID_FILE_EXIT = 9001

--AppendMenu(hSubMenu, MF_STRING, ID_FILE_EXIT, "E&xit");
  --      AppendMenu(hMenu, MF_STRING | MF_POPUP, (UINT)hSubMenu, "&File");
local function wnd_create(hwnd, msg, wparam, lparam)
	local menu = win32.CreateMenu();
	local file = win32.CreatePopupMenu();
	win32.AppendMenu(file, win32.MF_STRING, ID_FILE_EXIT, "E&xit");
	win32.AppendMenu(menu, win32.bitor(win32.MF_STRING, win32.MF_POPUP), file, "&File")
	win32.SetMenu(hwnd, menu);
end

local function wnd_close(hwnd, msg, wparam, lparam)
	win32.DestroyWindow(hwnd)
end

local function wnd_lbuttondown(hwnd, ...)
end

local function wnd_destroy(...)
	win32.PostQuitMessage(0)
end

local function wnd_erasebkgnd(...)	
end

local function wnd_paint(hwnd, msg, wparam, lparam)	
	local ps, hdc = win32.BeginPaint(hwnd)
	win32.TextOut(hdc, 10, 10, "testing");
	win32.EndPaint(hwnd, ps)
end

local function main(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
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
		win32.map_wndproc({
			[win32.WM_CREATE]      = wnd_create,
			[win32.WM_CLOSE]       = wnd_close,
			[win32.WM_COMMAND]     = wnd_command,
			[win32.WM_DESTROY]     = wnd_destroy,
			[win32.WM_LBUTTONDOWN] = wnd_lbuttondown,
			[win32.WM_ERASEBKGND]  = wnd_erasebkgnd,
			[win32.WM_PAINT]       = wnd_paint
		})
	)
	win32.ShowWindow(hwnd, nCmdShow)
	win32.UpdateWindow(hwnd)		
	return win32.MessageLoop()
end

return main

