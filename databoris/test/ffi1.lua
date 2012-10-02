
local ffi = require("ffi")
local winnt = require("winnt")

local kernel32 = ffi.load("kernel32")
local comctl32 = ffi.load("comctl32")
local user32   = ffi.load("user32")
local gdi32    = ffi.load("gdi32")

local function println(o)
	kernel32.OutputDebugStringA(stringit(o) .. "\n")
end

local function trace(event, line)
	local s = debug.getinfo(2)
	if string.find(s.short_src, "ffi1.lua") ~= nil then
		println(line .. ": " .. stringit(s.name))
	end
end 
--debug.sethook(trace, "l")

local NOT_HANDLED = 0xffffffff

function map_wndproc(handlers)
	return function(hwnd, msg, wparam, lparam)
		local f = handlers[msg]
		if f ~= nil then
			handled, result = f(hwnd, msg, wparam, lparam)
			if handled then
				return result
			end
		end
		return NOT_HANDLED
	end
end




local ID_FILE_EXIT   = 9001
local ID_STATUS_BAR  = 9002
local SBARS_SIZEGRIP = 0x100

local statusbar = 0

local function wnd_create(hwnd, msg, wparam, lparam)
	local menu = user32.CreateMenu()
	local file = user32.CreatePopupMenu()
	user32.AppendMenuA(file, winnt.MF_STRING, ID_FILE_EXIT, "E&xit")
	user32.AppendMenuA(menu, bit.bor(winnt.MF_STRING, winnt.MF_POPUP), file, "&File")
	user32.SetMenu(hwnd, menu)
	statusbar = comctl32.CreateStatusWindowA(0x50000000, "Ready", hwnd, ID_STATUS_BAR)
end

local function wnd_close(hwnd, msg, wparam, lparam)
	user32.DestroyWindow(hwnd)
end

local function wnd_command(hwnd, msg, wparam, lparam)
	if bit.band(wparam, 0xff) == ID_FILE_EXIT then
		user32.DestroyWindow(hwnd)
	end
end

local count = 0

local function wnd_lbuttondown(hwnd, ...)
	count = count + 1
	user32.RedrawWindow(hwnd, nil, 0, winnt.RDW_INVALIDATE)
end

local function wnd_rbuttondown(hwnd, ...)
	count = count - 1
	user32.RedrawWindow(hwnd, nil, 0, winnt.RDW_INVALIDATE)
end

local function wnd_destroy(...)
	user32.PostQuitMessage(0)
end

local function wnd_erasebkgnd(...)
	return true, 0
end

local OEM_FIXED_FONT = 11
local BLACK_PEN = 7
local OPAQUE = 2
local CS_OWNDC = 0x20
local CS_VREDRAW = 0x1
local CS_HREDRAW = 0x2

local function wnd_paint(hwnd, msg, wparam, lparam)	
	local ps = ffi.new("PAINTSTRUCT")
	local hdc = user32.BeginPaint(hwnd, ps)
	local rect = ffi.new("RECT")
	user32.GetClientRect(hwnd, rect)
	local hbr = gdi32.GetStockObject(count % 5)
	user32.FillRect(hdc, rect, hbr)	
	local sz  = "testing" .. count
	gdi32.TextOutA(hdc, 1, 1, sz, #sz)
	user32.EndPaint(hwnd, ps)
end

local function wnd_size(hwnd, msg, wparam, lparam)
	user32.SendMessageA(statusbar, msg, wparam, lparam)
end

local wnd_procs = {}

local function DefWindowProc(hwnd, msg, wparam, lparam)
	local handler = wnd_procs[hwnd]
	local result  = NOT_HANDLED
	if msg == winnt.WM_NCCREATE and lparam ~= 0 then
		local lpc = ffi.cast("CREATESTRUCTA*", lparam)
		handler = ffi.cast("WNDPROC", lpc.lpCreateParams)
		wnd_procs[hwnd] = handler 
	end
	if handler ~= nil then
		result = handler(hwnd, msg, wparam, lparam) 
	end
	--println({hwnd, msg, wparam, lparam, result=result})
	if result ~= NOT_HANDLED then
		return result or 0
	end
	return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
end

local cbDefWindowProc = ffi.cast("WNDPROC", DefWindowProc)

local function main(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
	local sz = ffi.sizeof("INITCOMMONCONTROLSEX")
	local ic = ffi.new("INITCOMMONCONTROLSEX", { dwSize = sz, dwICC = 4 })
	comctl32.InitCommonControlsEx(ic)

	hInstance = ffi.cast("HINSTANCE", hInstance)
	
	local clzName     = "lua_test_window"
	local clz         = ffi.new("WNDCLASSEXA")
	clz.cbSize        = ffi.sizeof("WNDCLASSEXA")
	clz.style         = bit.bor(CS_VREDRAW, CS_HREDRAW)
	clz.lpfnWndProc   = cbDefWindowProc
	clz.hInstance     = hInstance
	clz.hIcon         = user32.LoadIconA(hInstance, winnt.IDI_APPLICATION)
	clz.hCursor       = user32.LoadCursorA(hInstance, winnt.IDC_ARROW)
	clz.hbrBackground = gdi32.GetStockObject(0)
	clz.lpszClassName = clzName
	println(clz.hCursor)
	
	local atom = user32.RegisterClassExA(clz)

	local wndproc = map_wndproc({
		[winnt.WM_CREATE]      = wnd_create,
		[winnt.WM_CLOSE]       = wnd_close,
		[winnt.WM_COMMAND]     = wnd_command,
		[winnt.WM_DESTROY]     = wnd_destroy,
		[winnt.WM_LBUTTONDOWN] = wnd_lbuttondown,
		[winnt.WM_RBUTTONDOWN] = wnd_rbuttondown,
		[winnt.WM_ERASEBKGND]  = wnd_erasebkgnd,
		[winnt.WM_PAINT]       = wnd_paint,
		[winnt.WM_SIZE]        = wnd_size
	})

	local cb  = ffi.cast("WNDPROC", wndproc)
	local cbi = ffi.cast("LPVOID", cb)

	local hwnd = user32.CreateWindowExA(
		bit.bor(winnt.WS_EX_WINDOWEDGE, 0x2000000),
		clzName,
		"The title of my window",
		winnt.WS_OVERLAPPEDWINDOW,
		winnt.CW_USEDEFAULT,
		winnt.CW_USEDEFAULT,
		540,
		420,
		0, 
		0,
		hInstance,
		cbi)
		
	user32.ShowWindow(hwnd, nCmdShow)
	user32.UpdateWindow(hwnd)
			
	local msg = ffi.new("MSG")
	while user32.GetMessageA(msg, 0, 0, 0) ~= 0 do
		user32.TranslateMessage(msg)
		user32.DispatchMessageA(msg)
	end

	return msg.wParam	
end

return main
