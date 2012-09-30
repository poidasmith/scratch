
local win32 = require("win32")
local log   = require("log")
local bitop = require("bitop")

local ID_FILE_EXIT   = 9001
local ID_STATUS_BAR  = 9002
local SBARS_SIZEGRIP = 0x100

local statusbar = 0

local function wnd_create(hwnd, msg, wparam, lparam)
	local menu = win32.CreateMenu()
	local file = win32.CreatePopupMenu()
	win32.AppendMenu(file, win32.MF_STRING, ID_FILE_EXIT, "E&xit")
	win32.AppendMenu(menu, bitop.orr(win32.MF_STRING, win32.MF_POPUP), file, "&File")
	win32.SetMenu(hwnd, menu)
	statusbar = win32.CreateStatusWindow(0x50000000, "Ready", hwnd, ID_STATUS_BAR)
end

local function wnd_close(hwnd, msg, wparam, lparam)
	win32.DestroyWindow(hwnd)
end

local function wnd_command(hwnd, msg, wparam, lparam)
	if bitop.loword(wparam) == ID_FILE_EXIT then
		win32.DestroyWindow(hwnd)
	end
end

local count = 0

local function wnd_lbuttondown(hwnd, ...)
	count = count + 1
	win32.RedrawWindow(hwnd)
end

local function wnd_lbuttondown(hwnd, ...)
	count = count - 1
	win32.RedrawWindow(hwnd)
end

local function wnd_destroy(...)
	win32.PostQuitMessage(0)
end

local function wnd_erasebkgnd(...)
	return 0, true
end

local OEM_FIXED_FONT = 11
local BLACK_PEN = 7
local OPAQUE = 2
local CS_OWNDC = 0x20
local CS_VREDRAW = 0x1
local CS_HREDRAW = 0x2

local function wnd_paint(hwnd, msg, wparam, lparam)	
	local ps, hdc = win32.BeginPaint(hwnd)
	local rect = win32.RECT()
	--win32.GetClientRect(hwnd, rect)
	--log.println({top=rect.top, left=rect.left, right=rect.right, bottom=rect.bottom})
	--local hbr = win32.GetStockObject(count % 5)
	--win32.FillRect(hdc, rect, hbr)
	--local pen = win32.GetStockObject(BLACK_PEN)
	--local font = win32.GetStockObject(OEM_FIXED_FONT)
	--win32.SelectObject(pen)
	--win32.SelectObject(font)
	--win32.SetBkMode(hdc, OPAQUE)
	--win32.SetBkColor(hdc, win32.RGB(255, 0, 0))
	win32.SetTextColor(hdc, win32.RGB(255, 25, 2))
	win32.TextOut(hdc, 1, 1, "testing" .. count)
	win32.EndPaint(hwnd, ps)
end

local function wnd_size(hwnd, msg, wparam, lparam)
	win32.SendMessage(statusbar, msg, wparam, lparam)
end


local function main(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
	win32.InitCommonControlsEx()
	local clz = "lua_test_window"
	local cursor = win32.LoadCursor(win32.IDC_ARROW)
	local icon   = win32.LoadIcon(win32.IDI_APPLICATION)
	local bg     = win32.GetStockObject(0)
	win32.RegisterClassEx(clz, bitop.orr(CS_OWNDC, CS_VREDRAW, CS_HREDRAW), 0, 0, hInstance, icon, cursor, bg)
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

return main

