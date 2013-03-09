
require "common"
setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))
local winnt    = require "winnt"
local ffi      = require "ffi"
local kernel32 = ffi.load("kernel32")
local comctl32 = ffi.load("comctl32")
local user32   = ffi.load("user32")
local gdi32    = ffi.load("gdi32")
local shell32  = ffi.load("shell32")

-- initialize common stuff
local hInstance = kernel32.GetModuleHandleA(nil)
local sz = ffi.sizeof("INITCOMMONCONTROLSEX")
local ic = ffi.new("INITCOMMONCONTROLSEX", { dwSize = sz, dwICC = 4 })
comctl32.InitCommonControlsEx(ic)

-- 
local NOT_HANDLED = 0xffffffff
local function mapWindowProc(handlers)
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
--
local wnd_procs = {}
local function defWindowProc(hwnd, msg, wparam, lparam)
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
			-- TODO: fix this somehow
			println(res)
		end 
	end
	--println({hwnd, msg, wparam, lparam, result=result})
	if result ~= NOT_HANDLED then
		return result or 0
	end
	return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
end
local cbDefWindowProc = ffi.cast("WNDPROC", defWindowProc)
--
local CS_OWNDC = 0x20
local CS_VREDRAW = 0x1
local CS_HREDRAW = 0x2

local function WindowCreate(class, handlers, title)
	local clzName     = class
	local clz         = ffi.new("WNDCLASSEXA")
	clz.cbSize        = ffi.sizeof("WNDCLASSEXA")
	clz.style         = bit.bor(CS_VREDRAW, CS_HREDRAW)
	clz.lpfnWndProc   = cbDefWindowProc
	clz.hInstance     = hInstance

	local hicl = ffi.new("HICON[1]")
	local hics = ffi.new("HICON[1]")
	shell32.ExtractIconExA("../src/Databoris.ico", 0, hicl, hics, 1)
	clz.hIcon         = hics[0]
	clz.hCursor       = user32.LoadCursorA(hInstance, winnt.IDC_ARROW)
	clz.hbrBackground = 0
	clz.lpszClassName = clzName

	local atom    = user32.RegisterClassExA(clz)
	local wndproc = mapWindowProc(handlers)
	local cb      = ffi.cast("WNDPROC", wndproc)	
	
	local hwnd = user32.CreateWindowExA(
		bit.bor(winnt.WS_EX_WINDOWEDGE, 0x2000000),
		clzName,
		title or "WINDOW",
		winnt.WS_OVERLAPPEDWINDOW,
		0,0,0,0,0,0,
		hInstance,
		ffi.cast("LPVOID", cb))
		
	return hwnd
end
--
local function WindowSubclass(hwnd, handlers)
	local prevProc
	local function proc(hwnd, msg, wparam, lparam)
		local f = handlers[msg]
		local result = false
		if f ~= nil then
			pres, res = pcall(f, hwnd, msg, wparam, lparam)
			if pres then
				result = res and res ~= 0 
			else
				print(res)
			end 
		end
		if result then
			return result
		end
		if prevProc then
			return user32.CallWindowProcA(prevProc, hwnd, msg, wparam, lparam)
		else
			return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
		end
	end
	local cbProc = ffi.cast("WNDPROC", proc)
	prevProc = user32.SetWindowLongA(hwnd, winnt.GWLP_WNDPROC, ffi.cast("LONG_PTR", cbProc))
	prevProc = ffi.cast("WNDPROC", prevProc)
	return prevProc
end
--
local function MsgPump()
	local msg = ffi.new("MSG")
	while user32.GetMessageA(msg, 0, 0, 0) ~= 0 do
		user32.TranslateMessage(msg)
		user32.DispatchMessageA(msg)
	end

	return msg.wParam	
end
--------------------------------------------------------------------------------
return {
	window   = WindowCreate,
	subclass = WindowSubclass,
	show     = user32.ShowWindow,
	update   = user32.UpdateWindow,
	run      = MsgPump,
}
