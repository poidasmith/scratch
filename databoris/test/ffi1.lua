
local ffi = require("ffi")
local winnt = {}

local kernel32 = ffi.load("kernel32")
local comctl32 = ffi.load("comctl32")
local user32   = ffi.load("user32")
local gdi32    = ffi.load("gdi32")

ffi.cdef[[
typedef unsigned short WORD;
typedef long           LONG;
typedef long           LONG_PTR;
typedef long           LRESULT;
typedef unsigned int   UINT;
typedef unsigned int   UINT_PTR;
typedef long           HANDLE;
typedef long           HWND;
typedef long           HBRUSH;
typedef long           HMENU;
typedef long           HINSTANCE;
typedef long           HMODULE;
typedef long           HGDIOBJ;
typedef long           HCURSOR;
typedef long           HICON;
typedef long           HDC;
typedef long           HRGN;
typedef void*          LPVOID;
typedef unsigned long  DWORD;
typedef const char*    LPCSTR;
typedef int            BOOL;
typedef int            COLORREF;
typedef unsigned char  BYTE;
typedef unsigned long  WPARAM;
typedef long           LPARAM;
typedef WORD           ATOM;

typedef DWORD (__stdcall* WNDPROC)(HANDLE, DWORD, DWORD, DWORD);

typedef struct tagRECT
{
    long    left;
    long    top;
    long    right;
    long    bottom;
} RECT;

typedef struct tagPAINTSTRUCT {
    HANDLE      hdc;
    BOOL        fErase;
    RECT        rcPaint;
    BOOL        fRestore;
    BOOL        fIncUpdate;
    BYTE        rgbReserved[32];
} PAINTSTRUCT;

typedef struct tagINITCOMMONCONTROLSEX {
    DWORD dwSize; 
    DWORD dwICC; 
} INITCOMMONCONTROLSEX;

typedef struct tagWNDCLASSEXA {
    UINT        cbSize;
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCSTR      lpszMenuName;
    LPCSTR      lpszClassName;
    HICON       hIconSm;
} WNDCLASSEXA;

typedef struct tagPOINT
{
    LONG  x;
    LONG  y;
} POINT;

typedef struct tagMSG {
    HWND        hwnd;
    UINT        message;
    WPARAM      wParam;
    LPARAM      lParam;
    DWORD       time;
    POINT       pt;
} MSG;

typedef struct tagCREATESTRUCTA {
    LPVOID      lpCreateParams;
    HINSTANCE   hInstance;
    HMENU       hMenu;
    HWND        hwndParent;
    int         cy;
    int         cx;
    int         y;
    int         x;
    LONG        style;
    LPCSTR      lpszName;
    LPCSTR      lpszClass;
    DWORD       dwExStyle;
} CREATESTRUCTA;

BOOL     AppendMenuA(HMENU hMenu, DWORD uFlags, DWORD uIDNewItem, LPCSTR lpNewItem);
HDC      BeginPaint(HMENU hWnd, PAINTSTRUCT *lpPaint);
HMENU    CreateMenu();
HMENU    CreatePopupMenu();
HWND     CreateStatusWindowA(LONG style, LPCSTR lpszText, HWND hwndParent, UINT wID);
HBRUSH   CreateSolidBrush(COLORREF color);
HWND     CreateWindowExA(DWORD dwExStyle, LPCSTR lpClassName, LPCSTR lpWindowName, DWORD dwStyle, int X, int Y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam);
LRESULT  DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
BOOL     DestroyWindow(HWND hWnd);
LRESULT  DispatchMessageA(const MSG *lpMsg);           
BOOL     DrawEdge(HDC hdc, RECT* qrc, UINT edge, UINT grfFlags);
BOOL     DrawFocusRect(HDC hDC, const RECT* lprc);
BOOL     DrawFrameControl(HDC hdc, RECT* lprc, UINT uType, UINT uState);         
int      DrawTextA(HDC hdc, LPCSTR lpchText, int cchText, RECT* lprc, UINT format);
BOOL     EndPaint(HWND hWnd, const PAINTSTRUCT *lpPaint);
int      FillRect(HDC hDC, const RECT* lprc, HBRUSH hbr);
COLORREF GetBkColor(HDC hdc);
int      GetBkMode(HDC hdc);
BOOL     GetClientRect(HWND hWnd, RECT* lpRect);
DWORD    GetCurrentDirectoryA(DWORD nBufferLength, LPCSTR lpBuffer);
BOOL     GetMessageA(MSG* lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);
DWORD    GetModuleFileNameA(HMODULE hModule, LPCSTR lpFilename, DWORD nSize);
HGDIOBJ  GetStockObject(int i);
HDC      GetWindowDC(HWND hWnd);
BOOL     InitCommonControlsEx(const INITCOMMONCONTROLSEX *picce);
BOOL     InvalidateRect(HWND hWnd, const RECT *lpRect, BOOL bErase);
HCURSOR  LoadCursorA(HINSTANCE hInstance, WORD lpCursorName);
HICON    LoadIconA(HINSTANCE hInstance, WORD lpIconName);
int      MessageBoxA(HANDLE hwnd, LPCSTR txt, LPCSTR cap, DWORD type);
void     OutputDebugStringA(LPCSTR lpOutputString);
BOOL     PostMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
void     PostQuitMessage(int nExitCode);
BOOL     Rectangle(HDC hdc, int left, int top, int right, int bottom);
BOOL     RedrawWindow(HWND hWnd, const RECT *lprcUpdate, HRGN hrgnUpdate, UINT flags);
ATOM     RegisterClassExA(const WNDCLASSEXA *);
HGDIOBJ  SelectObject(HDC hdc, HGDIOBJ h);
LRESULT  SendMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
COLORREF SetBkColor(HDC hdc, COLORREF color);
int      SetBkMode(HDC hdc, int mode);
BOOL     SetMenu(HWND hWnd, HMENU hMenu);
COLORREF SetTextColor(HDC hdc, COLORREF color);
BOOL     ShowWindow(HWND hWnd, int nCmdShow);
BOOL     TextOutA(HDC hdc, int x, int y, LPCSTR lpString, int c);
BOOL     TranslateMessage(const MSG *lpMsg);
BOOL     UpdateWindow(HWND hWnd);

]]

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

-- styles
winnt.WS_EX_WINDOWEDGE    = 0x100
winnt.WS_EX_CLIENTEDGE    = 0x200
winnt.WS_OVERLAPPEDWINDOW = 0xCF0000
winnt.CW_USEDEFAULT       = 0x80000000

-- messages
winnt.WM_NCCREATE         = 0x0081
winnt.WM_CREATE           = 0x0001
winnt.WM_CLOSE            = 0x0010
winnt.WM_DESTROY          = 0x0002
winnt.WM_COMMAND          = 0x0111
winnt.WM_LBUTTONDOWN      = 0x0201
winnt.WM_RBUTTONDOWN      = 0x0204
winnt.WM_MOUSEWHEEL       = 0x020A
winnt.WM_ERASEBKGND		  = 0x0014
winnt.WM_PAINT            = 0x000F
winnt.WM_SIZE             = 0x0005

-- icons
winnt.IDI_APPLICATION = 32512

-- cursors
winnt.IDC_ARROW = 32512

-- message box
winnt.MB_OK       = 0
winnt.MB_OKCANCEL = 1

-- menu flags
winnt.MF_STRING = 0x00
winnt.MF_POPUP  = 0x10

winnt.RDW_INVALIDATE = 0x1


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
		winnt.WS_EX_WINDOWEDGE,
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
