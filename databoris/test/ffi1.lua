
local ffi = require("ffi")
local win32 = ffi.C
local winnt = {}

ffi.cdef[[
typedef unsigned short WORD;
typedef long           LONG;
typedef long           LONG_PTR;
typedef long           LRESULT;
typedef unsigned int   UINT;
typedef unsigned int   UINT_PTR;
typedef void*          HANDLE;
typedef void*          HWND;
typedef void*          HBRUSH;
typedef void*          HMENU;
typedef void*          HINSTANCE;
typedef void*          HMODULE;
typedef void*          HGDIOBJ;
typedef void*          HCURSOR;
typedef void*          HICON;
typedef void*          HDC;
typedef void*          HRGN;
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

BOOL     AppendMenuA(HANDLE hMenu, DWORD uFlags, DWORD uIDNewItem, LPCSTR lpNewItem);
HANDLE   BeginPaint(HANDLE hWnd, PAINTSTRUCT *lpPaint);
HWND     CreateStatusWindowA(LONG style, LPCSTR lpszText, HWND hwndParent, UINT wID);
HBRUSH   CreateSolidBrush(COLORREF color);
HWND     CreateWindowExA(DWORD dwExStyle, LPCSTR lpClassName, LPCSTR lpWindowName, DWORD dwStyle, int X, int Y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam);
LRESULT  DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
BOOL     DestroyWindow(HWND hWnd);           
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
DWORD    GetModuleFileNameA(HMODULE hModule, LPCSTR lpFilename, DWORD nSize);
HGDIOBJ  GetStockObject(int i);
HDC      GetWindowDC(HWND hWnd);
BOOL     InitCommonControlsEx(const INITCOMMONCONTROLSEX *picce);
BOOL     InvalidateRect(HWND hWnd, const RECT *lpRect, BOOL bErase);
HCURSOR  LoadCursorA(HINSTANCE hInstance, LPCSTR lpCursorName);
HICON    LoadIconA(HINSTANCE hInstance, LPCSTR lpIconName);
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
BOOL     UpdateWindow(HWND hWnd);

]]

function map_wndproc(handlers)
	return function(hwnd, msg, wparam, lparam)
		local f = handlers[msg]
		if f ~= nil then
			return f(hwnd, msg, wparam, lparam) 
		end
		return false
	end
end

-- styles
winnt.WS_EX_WINDOWEDGE    = 0x100
winnt.WS_EX_CLIENTEDGE    = 0x200
winnt.WS_OVERLAPPEDWINDOW = 0xCF0000
winnt.CW_USEDEFAULT       = 0x80000000

-- messages
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


local ID_FILE_EXIT   = 9001
local ID_STATUS_BAR  = 9002
local SBARS_SIZEGRIP = 0x100

local statusbar = 0

local function wnd_create(hwnd, msg, wparam, lparam)
	local menu = win32.CreateMenu()
	local file = win32.CreatePopupMenu()
	win32.AppendMenuA(file, winnt.MF_STRING, ID_FILE_EXIT, "E&xit")
	win32.AppendMenuA(menu, bit.bor(winnt.MF_STRING, winnt.MF_POPUP), file, "&File")
	win32.SetMenu(hwnd, menu)
	statusbar = win32.CreateStatusWindowA(0x50000000, "Ready", hwnd, ID_STATUS_BAR)
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
	local ps = ffi.new("PAINTSTRUCT")
	win32.BeginPaint(hwnd, ps)
	win32.TextOutA(hdc, 1, 1, "testing" .. count)
	win32.EndPaint(hwnd, ps)
end

local function wnd_size(hwnd, msg, wparam, lparam)
	win32.SendMessage(statusbar, msg, wparam, lparam)
end

local wnd_procs = {}

local function DefWindowProc(hwnd, msg, wparam, lparam)
	local handler = wnd_procs[hwnd]
	local handled = false
	local result  = 0
	if handler ~= nil then
		
	end
	return win32.DefWindowProcA(hwnd, msg, wparam, lparam)
end

local function main(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
	local cc = ffi.new("INITCOMMONCONTROLSEX")
	cc.dwSize = ffi.sizeof("INITCOMMONCONTROLSEX")
	cc.dwICC  = 4
	win32.InitCommonControlsEx(cc)
	
	local cursor = win32.LoadCursor(winnt.IDC_ARROW)
	local icon   = win32.LoadIcon(winnt.IDI_APPLICATION)
	local bg     = win32.GetStockObject(0)
	
	local clz = ffi.new("WNDCLASSEXA")
	clz.cbSize      = ffi.sizeof("WNDCLASSEXA")
	clz.style       = bit.bor(CS_VREDRAW, CS_HREDRAW)
	clz.lpfnWndProc = map_wndproc({
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
	clz.cbClsExtra    = 0
	clz.cbWndExtra    = 0
	clz.hInstance     = hInstance
	clz.hIcon         = icon
	clz.hCursor       = cursor
	clz.hbrBackground = bg
	clz.lpszMenuName  = 0
	clz.hIconSm       = 0
	
	local atom = win32.RegisterClassExA(clz)
	
end

return main