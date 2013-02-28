
require "common"
setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))
local winnt    = require "winnt"
local ffi      = require "ffi"
local kernel32 = ffi.load("kernel32")
local comctl32 = ffi.load("comctl32")
local user32   = ffi.load("user32")
local gdi32    = ffi.load("gdi32")

-- initialize common stuff
local hInstance = kernel32.GetModuleHandleA(nil)
local sz = ffi.sizeof("INITCOMMONCONTROLSEX")
local ic = ffi.new("INITCOMMONCONTROLSEX", { dwSize = sz, dwICC = 4 })
comctl32.InitCommonControlsEx(ic)

local NOT_HANDLED = 0xffffffff

local function map_wndproc(handlers)
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
		pres, res = pcall(handler, hwnd, msg, wparam, lparam)
		if pres then
			result = res
		else
			println(res)
		end 
	end
	--println({hwnd, msg, wparam, lparam, result=result})
	if result ~= NOT_HANDLED then
		return result or 0
	end
	return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
end

local cbDefWindowProc = ffi.cast("WNDPROC", DefWindowProc)

local function window_create(class, handlers, title)
	local clzName     = class
	local clz         = ffi.new("WNDCLASSEXA")
	clz.cbSize        = ffi.sizeof("WNDCLASSEXA")
	clz.style         = bit.bor(CS_VREDRAW, CS_HREDRAW)
	clz.lpfnWndProc   = cbDefWindowProc
	clz.hInstance     = hInstance
	clz.hIcon         = user32.LoadIconA(hInstance, winnt.IDI_APPLICATION)
	clz.hCursor       = user32.LoadCursorA(hInstance, winnt.IDC_ARROW)
	clz.hbrBackground = 0
	clz.lpszClassName = clzName

	local atom    = user32.RegisterClassExA(clz)
	local wndproc = map_wndproc(handlers)
	local cb      = ffi.cast("WNDPROC", wndproc)
	
	local hwnd = user32.CreateWindowExA(
		bit.bor(winnt.WS_EX_WINDOWEDGE, 0x2000000),
		clzName,
		title or "WINDOW",
		winnt.WS_OVERLAPPEDWINDOW,
		1,1,1,1,0,0,
		hInstance,
		ffi.cast("LPVOID", cb))
end

local function msg_pump()
	local msg = ffi.new("MSG")
	while user32.GetMessageA(msg, 0, 0, 0) ~= 0 do
		user32.TranslateMessage(msg)
		user32.DispatchMessageA(msg)
	end

	return msg.wParam	
end

return {
	window = window_create,
	show   = user32.ShowWindow,
	update = user32.UpdateWindow,
	run    = msg_pump,
}
