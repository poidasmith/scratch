
local ffi = require("ffi")

if not defined_winnt then
ffi.cdef[[
typedef unsigned short WORD;
typedef long           LONG;
typedef long           LONG_PTR;
typedef long           LRESULT;
typedef long           LSTATUS;
typedef unsigned int   UINT;
typedef unsigned int   UINT_PTR;
typedef long           HANDLE;
typedef long           HBRUSH;
typedef long           HCURSOR;
typedef long           HDC;
typedef long           HFONT;
typedef long           HGDIOBJ;
typedef long           HICON;
typedef long           HINSTANCE;
typedef long           HKEY;
typedef long           HMENU;
typedef long           HMODULE;
typedef long           HPEN;
typedef long           HRGN;
typedef long           HWND;
typedef long           SC_HANDLE;
typedef void*          LPVOID;
typedef unsigned long  DWORD;
typedef unsigned long* LPDWORD;
typedef char*          LPSTR;
typedef const char*    LPCSTR;
typedef int            BOOL;
typedef int            COLORREF;
typedef unsigned char  BYTE;
typedef unsigned long  WPARAM;
typedef long           LPARAM;
typedef WORD           ATOM;

typedef DWORD (__stdcall* WNDPROC)(HANDLE, DWORD, DWORD, DWORD);

typedef struct tagRECT {
    long    left;
    long    top;
    long    right;
    long    bottom;
} RECT;

typedef struct tagSIZE { 
  LONG cx; 
  LONG cy; 
} SIZE; 

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

typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME;

typedef struct tagNMHDR {
  HWND     hwndFrom;
  UINT_PTR idFrom;
  UINT     code;
} NMHDR;

typedef struct _WIN32_FILE_ATTRIBUTE_DATA {
  DWORD    dwFileAttributes;
  FILETIME ftCreationTime;
  FILETIME ftLastAccessTime;
  FILETIME ftLastWriteTime;
  DWORD    nFileSizeHigh;
  DWORD    nFileSizeLow;
} WIN32_FILE_ATTRIBUTE_DATA;

typedef struct tagSCNotification {
	HWND hwndFrom;
	UINT_PTR idFrom;
	UINT code;
	int position;
	int ch;
	int modifiers;
	int modificationType;
	const char *text;
	int length;		
	int linesAdded;	
	int message;	
	UINT_PTR wParam;	
	LONG_PTR lParam;	
	int line;		
	int foldLevelNow;
	int foldLevelPrev;
	int margin;
	int listType;
	int x;
	int y;
	int token;
	int annotationLinesAdded;
	int updated;
} SCNotification;

typedef struct _WIN32_FIND_DATA {
  DWORD    dwFileAttributes;
  FILETIME ftCreationTime;
  FILETIME ftLastAccessTime;
  FILETIME ftLastWriteTime;
  DWORD    nFileSizeHigh;
  DWORD    nFileSizeLow;
  DWORD    dwReserved0;
  DWORD    dwReserved1;
  char     cFileName[260];
  char     cAlternateFileName[14];
} WIN32_FIND_DATA;

BOOL     AppendMenuA(HMENU hMenu, DWORD uFlags, DWORD uIDNewItem, LPCSTR lpNewItem);
HDC      BeginPaint(HMENU hWnd, PAINTSTRUCT *lpPaint);
LRESULT  CallWindowProcA(WNDPROC lpPrevWndFunc, HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
HFONT    CreateFontA(int nHeight, int nWidth, int nEscapement, int nOrientation, int fnWeight, DWORD fdwItalic, DWORD fdwUnderline, DWORD fdwStrikeOut, DWORD fdwCharSet, DWORD fdwOutputPrecision, DWORD fdwClipPrecision, DWORD fdwQuality, DWORD fdwPitchAndFamily, LPCSTR lpszFace);
HMENU    CreateMenu();
HPEN     CreatePen(int fnPenStyle, int nWidth, COLORREF crColor);
HMENU    CreatePopupMenu();
SC_HANDLE CreateServiceA(SC_HANDLE hSCManager, LPCSTR lpServiceName, LPCSTR lpDisplayName, DWORD dwDesiredAccess, DWORD dwServiceType, DWORD dwStartType, DWORD dwErrorControl, LPCSTR lpBinaryPathName, LPCSTR lpLoadOrderGroup, LPDWORD lpdwTagId, LPCSTR lpDependencies, LPCSTR lpServiceStartName, LPCSTR lpPassword);
HWND     CreateStatusWindowA(LONG style, LPCSTR lpszText, HWND hwndParent, UINT wID);
HBRUSH   CreateSolidBrush(COLORREF color);
HWND     CreateWindowExA(DWORD dwExStyle, LPCSTR lpClassName, LPCSTR lpWindowName, DWORD dwStyle, int X, int Y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam);
BOOL     CloseServiceHandle(SC_HANDLE hSCObject);
LRESULT  DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
BOOL     DestroyWindow(HWND hWnd);
LRESULT  DispatchMessageA(const MSG *lpMsg);           
BOOL     DrawEdge(HDC hdc, RECT* qrc, UINT edge, UINT grfFlags);
BOOL     DrawFocusRect(HDC hDC, const RECT* lprc);
BOOL     DrawFrameControl(HDC hdc, RECT* lprc, UINT uType, UINT uState);         
int      DrawTextA(HDC hdc, LPCSTR lpchText, int cchText, RECT* lprc, UINT format);
BOOL     EndPaint(HWND hWnd, const PAINTSTRUCT *lpPaint);
UINT     ExtractIconExA(LPCSTR lpszFile,int nIconIndex,HICON *phiconLarge,HICON *phiconSmall,UINT nIcons);
int      FillRect(HDC hDC, const RECT* lprc, HBRUSH hbr);
BOOL 	 FindClose(HANDLE hFindFile);
HANDLE   FindFirstFileA(LPCSTR lpFileName, WIN32_FIND_DATA* lpFindFileData);
BOOL     FindNextFileA(HANDLE hFindFile, WIN32_FIND_DATA* lpFindFileData);
COLORREF GetBkColor(HDC hdc);
int      GetBkMode(HDC hdc);
BOOL     GetClientRect(HWND hWnd, RECT* lpRect);
LPSTR    GetCommandLineA();
DWORD    GetCurrentDirectoryA(DWORD nBufferLength, LPCSTR lpBuffer);
DWORD    GetFileAttributesA(LPCSTR lpFileName);
BOOL     GetFileAttributesExA(LPCSTR lpFileName, DWORD fInfoLevelId, WIN32_FILE_ATTRIBUTE_DATA* lpFileInformation);
short    GetKeyState(int nVirtKey);
BOOL     GetMessageA(MSG* lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);
DWORD    GetModuleFileNameA(HMODULE hModule, LPCSTR lpFilename, DWORD nSize);
HMODULE  GetModuleHandleA(LPCSTR lpModuleName);
HGDIOBJ  GetStockObject(int i);
BOOL     GetTextExtentPointA(HDC hdc, LPCSTR lpString, int cbString, SIZE* lpSize);
HDC      GetWindowDC(HWND hWnd);
BOOL     InitCommonControlsEx(const INITCOMMONCONTROLSEX *picce);
BOOL     InvalidateRect(HWND hWnd, const RECT *lpRect, BOOL bErase);
HCURSOR  LoadCursorA(HINSTANCE hInstance, WORD lpCursorName);
HICON    LoadIconA(HINSTANCE hInstance, WORD lpIconName);
int      MessageBoxA(HANDLE hwnd, LPCSTR txt, LPCSTR cap, DWORD type);
BOOL     MoveWindow(HWND hWnd, int X, int Y, int nWidth, int nHeight, BOOL bRepaint);
SC_HANDLE OpenSCManagerA(LPCSTR lpMachineName, LPCSTR lpDatabaseName, DWORD dwDesiredAccess);
void     OutputDebugStringA(LPCSTR lpOutputString);
BOOL     Polyline(HDC hdc, const POINT *lppt, int cPoints);
BOOL     PostMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
void     PostQuitMessage(int nExitCode);
BOOL     Rectangle(HDC hdc, int left, int top, int right, int bottom);
BOOL     RedrawWindow(HWND hWnd, const RECT *lprcUpdate, HRGN hrgnUpdate, UINT flags);
ATOM     RegisterClassExA(const WNDCLASSEXA *);
LSTATUS  RegOpenKeyA(HKEY hKey, LPCSTR lpSubKey, HKEY* phkResult);
LSTATUS  RegSetValueExA(HKEY hKey, LPCSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE* lpData, DWORD cbData);
HGDIOBJ  SelectObject(HDC hdc, HGDIOBJ h);
LRESULT  SendMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
COLORREF SetBkColor(HDC hdc, COLORREF color);
int      SetBkMode(HDC hdc, int mode);
BOOL     SetForegroundWindow(HWND hWnd);
BOOL     SetMenu(HWND hWnd, HMENU hMenu);
HWND     SetFocus(HWND hWnd);
UINT     SetTextAlign(HDC hdc, UINT fMode);
COLORREF SetTextColor(HDC hdc, COLORREF color);
UINT_PTR SetTimer(HWND hWnd, UINT_PTR nIDEvent, UINT uElapse, UINT_PTR lpTimerFunc);
LONG_PTR SetWindowLongA(HWND hWnd, int nIndex, LONG_PTR dwNewLong);
BOOL     ShowWindow(HWND hWnd, int nCmdShow);
void     Sleep(DWORD dwMilliseconds);
BOOL     TextOutA(HDC hdc, int x, int y, LPCSTR lpString, int c);
BOOL     TranslateMessage(const MSG *lpMsg);
BOOL     UpdateWindow(HWND hWnd);
]]
defined_winnt = true
end

local winnt = {
	-- styles
	WS_EX_WINDOWEDGE    = 0x100,
	WS_EX_CLIENTEDGE    = 0x200,
	WS_OVERLAPPEDWINDOW = 0xCF0000,
	WS_CHILD            = 0x40000000,
	WS_VISIBLE          = 0x10000000,
	WS_TABSTOP          = 0x00010000,
	WS_CLIPCHILDREN     = 0x02000000,
	CW_USEDEFAULT       = 0x80000000,

	-- messages
	WM_NCCREATE         = 0x0081,
	WM_CREATE           = 0x0001,
	WM_SETFONT          = 0x0030,
	WM_CLOSE            = 0x0010,
	WM_DESTROY          = 0x0002,
	WM_COMMAND          = 0x0111,
	WM_LBUTTONDOWN      = 0x0201,
	WM_RBUTTONDOWN      = 0x0204,
	WM_MOUSEWHEEL       = 0x020A,
	WM_ERASEBKGND		= 0x0014,
	WM_PAINT            = 0x000F,
	WM_SIZE             = 0x0005,
	WM_TIMER            = 0x0113,
	WM_KEYDOWN          = 0x0100,
	WM_CHAR             = 0x0102,
	WM_SYSKEYDOWN       = 0x0104,
	WM_NOTIFY           = 0x004E,
	WM_SETFOCUS         = 0x0007,
	
	-- service start type
	SERVICE_BOOT_START   = 0x00000000,
	SERVICE_SYSTEM_START = 0x00000001,
	SERVICE_AUTO_START   = 0x00000002,
	SERVICE_DEMAND_START = 0x00000003,
	SERVICE_DISABLED     = 0x00000004,	
	
	-- text align
	TA_BOTTOM   = 8,
	TA_BASELINE = 24,
}


winnt.SW_SHOW=5

winnt.GWLP_WNDPROC = -4
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

-- bk mode
winnt.TRANSPARENT = 1
winnt.OPAQUE      = 2

winnt.PS_SOLID = 0

-- keys
winnt.VK_RIGHT = 0x27
winnt.VK_PGUP  = 0x21
winnt.VK_PGDOWN= 0x22
winnt.VK_END   = 0x23
winnt.VK_HOME  = 0x24
winnt.VK_LEFT  = 0x25
winnt.VK_UP    = 0x26
winnt.VK_RIGHT = 0x27
winnt.VK_DOWN  = 0x28
winnt.VK_LSHIFT  =0xA0
winnt.VK_RSHIFT  =0xA1
winnt.VK_LCONTROL=0xA2
winnt.VK_RCONTROL=0xA3
winnt.VK_LMENU   =0xA4
winnt.VK_RMENU   =0xA5

winnt.LOWORD = function(dword)
	return bit.band(dword, 0xffff)
end

winnt.HIWORD = function(dword)
	return bit.band(bit.rshift(dword, 16), 0xffff)
end

function winnt.GetKeyStates(lparam)
	local user32 = ffi.load "user32"
	local shift = bit.bor(user32.GetKeyState(winnt.VK_LSHIFT), user32.GetKeyState(winnt.VK_RSHIFT)) < 0
	local ctrl  = bit.bor(user32.GetKeyState(winnt.VK_LCONTROL), user32.GetKeyState(winnt.VK_RCONTROL)) < 0
	local alt   = bit.band(lparam, 0x20000000) ~= 0
	return shift, ctrl, alt
end

return winnt


