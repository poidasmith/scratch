
local ffi = require("ffi")

ffi.cdef[[
typedef unsigned short WORD;
typedef long           LONG;
typedef long           LONG_PTR;
typedef long           LRESULT;
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
typedef long           HMENU;
typedef long           HMODULE;
typedef long           HPEN;
typedef long           HRGN;
typedef long           HWND;
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

typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME;

typedef struct _WIN32_FILE_ATTRIBUTE_DATA {
  DWORD    dwFileAttributes;
  FILETIME ftCreationTime;
  FILETIME ftLastAccessTime;
  FILETIME ftLastWriteTime;
  DWORD    nFileSizeHigh;
  DWORD    nFileSizeLow;
} WIN32_FILE_ATTRIBUTE_DATA;

BOOL     AppendMenuA(HMENU hMenu, DWORD uFlags, DWORD uIDNewItem, LPCSTR lpNewItem);
HDC      BeginPaint(HMENU hWnd, PAINTSTRUCT *lpPaint);
HFONT    CreateFontA(int nHeight, int nWidth, int nEscapement, int nOrientation, int fnWeight, DWORD fdwItalic, DWORD fdwUnderline, DWORD fdwStrikeOut, DWORD fdwCharSet, DWORD fdwOutputPrecision, DWORD fdwClipPrecision, DWORD fdwQuality, DWORD fdwPitchAndFamily, LPCSTR lpszFace);
HMENU    CreateMenu();
HPEN     CreatePen(int fnPenStyle, int nWidth, COLORREF crColor);
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
DWORD    GetFileAttributesA(LPCSTR lpFileName);
BOOL     GetFileAttributesExA(LPCSTR lpFileName, DWORD fInfoLevelId, WIN32_FILE_ATTRIBUTE_DATA* lpFileInformation);
BOOL     GetMessageA(MSG* lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);
DWORD    GetModuleFileNameA(HMODULE hModule, LPCSTR lpFilename, DWORD nSize);
HMODULE  GetModuleHandleA(LPCSTR lpModuleName);
HGDIOBJ  GetStockObject(int i);
HDC      GetWindowDC(HWND hWnd);
BOOL     InitCommonControlsEx(const INITCOMMONCONTROLSEX *picce);
BOOL     InvalidateRect(HWND hWnd, const RECT *lpRect, BOOL bErase);
HCURSOR  LoadCursorA(HINSTANCE hInstance, WORD lpCursorName);
HICON    LoadIconA(HINSTANCE hInstance, WORD lpIconName);
int      MessageBoxA(HANDLE hwnd, LPCSTR txt, LPCSTR cap, DWORD type);
BOOL     MoveWindow(HWND hWnd, int X, int Y, int nWidth, int nHeight, BOOL bRepaint);
void     OutputDebugStringA(LPCSTR lpOutputString);
BOOL     Polyline(HDC hdc, const POINT *lppt, int cPoints);
BOOL     PostMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
void     PostQuitMessage(int nExitCode);
BOOL     Rectangle(HDC hdc, int left, int top, int right, int bottom);
BOOL     RedrawWindow(HWND hWnd, const RECT *lprcUpdate, HRGN hrgnUpdate, UINT flags);
ATOM     RegisterClassExA(const WNDCLASSEXA *);
HGDIOBJ  SelectObject(HDC hdc, HGDIOBJ h);
LRESULT  SendMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
COLORREF SetBkColor(HDC hdc, COLORREF color);
int      SetBkMode(HDC hdc, int mode);
BOOL     SetForegroundWindow(HWND hWnd);
BOOL     SetMenu(HWND hWnd, HMENU hMenu);
HWND     SetFocus(HWND hWnd);
COLORREF SetTextColor(HDC hdc, COLORREF color);
UINT_PTR SetTimer(HWND hWnd, UINT_PTR nIDEvent, UINT uElapse, UINT_PTR lpTimerFunc);
BOOL     ShowWindow(HWND hWnd, int nCmdShow);
BOOL     TextOutA(HDC hdc, int x, int y, LPCSTR lpString, int c);
BOOL     TranslateMessage(const MSG *lpMsg);
BOOL     UpdateWindow(HWND hWnd);

]]

local winnt = {}

-- styles
winnt.WS_EX_WINDOWEDGE    = 0x100
winnt.WS_EX_CLIENTEDGE    = 0x200
winnt.WS_OVERLAPPEDWINDOW = 0xCF0000
winnt.WS_CHILD            = 0x40000000
winnt.WS_VISIBLE          = 0x10000000
winnt.WS_TABSTOP          = 0x00010000
winnt.WS_CLIPCHILDREN     = 0x02000000
winnt.CW_USEDEFAULT       = 0x80000000

-- messages
winnt.WM_NCCREATE         = 0x0081
winnt.WM_CREATE           = 0x0001
winnt.WM_SETFONT          = 0x0030
winnt.WM_CLOSE            = 0x0010
winnt.WM_DESTROY          = 0x0002
winnt.WM_COMMAND          = 0x0111
winnt.WM_LBUTTONDOWN      = 0x0201
winnt.WM_RBUTTONDOWN      = 0x0204
winnt.WM_MOUSEWHEEL       = 0x020A
winnt.WM_ERASEBKGND		  = 0x0014
winnt.WM_PAINT            = 0x000F
winnt.WM_SIZE             = 0x0005
winnt.WM_TIMER            = 0x0113
winnt.WM_KEYDOWN          = 0x0100
winnt.WM_NOTIFY           = 0x004E
winnt.WM_SETFOCUS         = 0x0007

winnt.SW_SHOW=5

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

winnt.VK_RIGHT = 0x27
winnt.VK_NEXT  = 0x22
winnt.VK_END   = 0x23
winnt.VK_HOME  = 0x24
winnt.VK_LEFT  = 0x25
winnt.VK_UP    = 0x26
winnt.VK_RIGHT = 0x27
winnt.VK_DOWN  = 0x28

winnt.LOWORD = function(dword)
	return bit.band(dword, 0xffff)
end

winnt.HIWORD = function(dword)
	return bit.band(bit.rshift(dword, 16), 0xffff)
end

return winnt


