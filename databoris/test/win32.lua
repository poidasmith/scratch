
local win32 = {}

-- styles
win32.WS_EX_WINDOWEDGE    = 0x100
win32.WS_EX_CLIENTEDGE    = 0x200
win32.WS_OVERLAPPEDWINDOW = 0xCF0000
win32.CW_USEDEFAULT       = 0x80000000

-- messages
win32.WM_CREATE           = 0x0001
win32.WM_CLOSE            = 0x0010
win32.WM_DESTROY          = 0x0002
win32.WM_COMMAND          = 0x0111
win32.WM_LBUTTONDOWN      = 0x0201
win32.WM_RBUTTONDOWN      = 0x0204
win32.WM_MOUSEWHEEL       = 0x020A
win32.WM_ERASEBKGND		  = 0x0014
win32.WM_PAINT            = 0x000F
win32.WM_SIZE             = 0x0005

-- icons
win32.IDI_APPLICATION = 32512

-- cursors
win32.IDC_ARROW = 32512

-- message box
win32.MB_OK       = 0
win32.MB_OKCANCEL = 1

-- menu flags
win32.MF_STRING = 0x00
win32.MF_POPUP  = 0x10

fns = {
	"AppendMenu",
	"BeginPaint",
	"EndPaint",
	"CreateIconFromResourceEx",
	"CreateMenu",
	"CreatePopupMenu",
	"CreateStatusWindow",
	"CreateSolidBrush",
	"CreateWindowEx",
	"DestroyWindow",
	"DrawEdge",
	"DrawFocusRect",
	"DrawFrameControl",
	"DrawText",
	"EndPaint",
	"FillRect",
	"GetBkColor",
	"GetBkMode",
	"GetClientRect",
	"GetCurrentDirectory",
	"GetModuleFileName",
	"GetModuleHandle",
	"GetStockObject",
	"GetWindowDC",
	"InitCommonControlsEx",
	"InvalidateRect",
	"LoadCursor",
	"LoadIcon",
	"MessageBox",
	"MessageLoop",
	"OutputDebugString",
	"PostMessage",
	"PostQuitMessage",
	"Rectangle",
	"RedrawWindow",
	"RegisterClassEx",
	"SelectObject",
	"SendMessage",
	"SetBkColor",
	"SetBkMode",
	"SetMenu",
	"ShowWindow",
	"TextOut",
	"UpdateWindow",
	
	-- helpers
	"RGB",
}

for k, v in next, fns do
	-- TODO: check for errors
	win32[ v ] = dbos.GetProcAddress("win32_" .. v)
end

-- RECT

local RECT_new = dbos.GetProcAddress("win32_RECT_new")
local RECT_get = dbos.GetProcAddress("win32_RECT_get")
local RECT_idx_vals = { left = 0, top = 1, right = 2, bottom = 3}
local function RECT_idx(fc, key)
	return RECT_get(rc, REC_idx_vals[key])
end
local RECT_mt = { __index = RECT_idx } 
win32.RECT = function(left, top, right, bottom)
	local rc = RECT_new(left, top, right, bottom)
	--setmetatable(rc, RECT_mt)
	return rc	
end

-- general purpose table-based wndproc

function win32.map_wndproc(handlers)
	return function(hwnd, msg, wparam, lparam)
		local f = handlers[msg]
		if f ~= nil then
			return f(hwnd, msg, wparam, lparam) 
		end
		return false
	end
end

return table.readonly(win32)

