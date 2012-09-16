
--local win32 = {}

local win32 = {}

-- styles
win32.WS_EX_WINDOWEDGE    = 0x100
win32.WS_EX_CLIENTEDGE    = 0x200
win32.WS_OVERLAPPEDWINDOW = 0xCF0000
win32.CW_USEDEFAULT       = 0x80000000

-- messages
win32.WM_CLOSE            = 0x0010
win32.WM_DESTROY          = 0x0002
win32.WM_LBUTTONDOWN      = 0x0201
win32.WM_ERASEBKGND		  = 0x0014
win32.WM_PAINT            = 0x000F

-- icons
win32.IDI_APPLICATION = 32512

-- cursors
win32.IDC_ARROW = 32512

-- message box
win32.MB_OK       = 0
win32.MB_OKCANCEL = 1

fns = {
	"BeginPaint",
	"EndPaint",
	"CreateIconFromResourceEx",
	"CreateWindowEx",
	"DestroyWindow",
	"GetCurrentDirectory",
	"GetModuleFileName",
	"GetModuleHandle",
	"LoadCursor",
	"LoadIcon",
	"MessageBox",
	"MessageLoop",
	"OutputDebugString",
	"PostMessage",
	"PostQuitMessage",
	"RegisterClassEx",
	"ShowWindow",
	"UpdateWindow",
}

for k, v in next, fns do
	win32[ v ] = dbos.GetProcAddress( "win32_" .. v )
end

return win32