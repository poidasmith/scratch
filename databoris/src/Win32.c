/******************************************************************************
* This program and the accompanying materials
* are made available under the terms of the Common Public License v1.0
* which accompanies this distribution, and is available at 
* http://www.eclipse.org/legal/cpl-v10.html
* 
* Contributors:
*     Peter Smith
*******************************************************************************/

#include "Databoris.h"

//#pragma comment(linker,"\"/manifestdependency:type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")

__declspec(dllexport) int win32_AppendMenu(lua_State *l)
{
	HMENU hMenu       = luaL_checkinteger(l, 1);
	UINT flags        = luaL_checkinteger(l, 2);
	UINT id           = luaL_checkinteger(l, 3);
	const char* label = luaL_checkstring(l, 4);
	BOOL res          = AppendMenu(hMenu, flags, id, label);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_BeginPaint(lua_State *l)
{
	HWND hwnd = luaL_checkinteger(l, 1);
	PAINTSTRUCT* ps = (PAINTSTRUCT*) lua_newuserdata(l, sizeof(PAINTSTRUCT));
	HDC hdc = BeginPaint(hwnd, ps);
	lua_pushinteger(l, hdc);
	return 2;
}

__declspec(dllexport) int win32_CreateIconFromResourceEx(lua_State *l)
{
	return 0;
}

__declspec(dllexport) int win32_CreateMenu(lua_State *l)
{
	lua_pushinteger(l, CreateMenu());
	return 1;
};

__declspec(dllexport) int win32_CreatePopupMenu(lua_State *l)
{
	lua_pushinteger(l, CreatePopupMenu());
	return 1;
};

__declspec(dllexport) int win32_CreateStatusWindow(lua_State *l)
{
	LONG style = luaL_checklong(l, 1);
	const char* lpszText = luaL_checkstring(l, 2);
	HWND hwndParent = luaL_checkinteger(l, 3);
	WORD wID = luaL_checkinteger(l, 4);
	HWND hwnd = CreateStatusWindow(style, lpszText, hwndParent, wID);
	lua_pushinteger(l, hwnd);
	return 1;
};

__declspec(dllexport) int win32_CreateSolidBrush(lua_State *l)
{
	COLORREF clr = luaL_checkinteger(l, 1);
	HBRUSH hbr   = CreateSolidBrush(clr);
	lua_pushinteger(l, hbr);
	return 1;
};

// A structure that we pass through windows and store in GWLP_USERDATA so we
// can call through the window handler functions in Lua
typedef struct {
	lua_State* l;
	int ref;
} LUA_WINDOW_CTX;

__declspec(dllexport) int win32_CreateWindowEx(lua_State *l)
{
	DWORD dwExStyle      = luaL_checkint(l, 1);
	LPCTSTR lpClassName  = luaL_checkstring(l, 2);
	LPCTSTR lpWindowName = luaL_checkstring(l, 3);
	DWORD dwStyle        = luaL_checklong(l, 4);
	int x                = luaL_optinteger(l, 5, 0);
	int y                = luaL_optinteger(l, 6, 0);
	int nWidth           = luaL_optinteger(l, 7, 0);
	int nHeight          = luaL_optinteger(l, 8, 0);
	HWND hWndParent      = luaL_optinteger(l, 9, 0);
	HMENU hMenu          = luaL_optinteger(l, 10, 0);
	HINSTANCE hInstance  = luaL_optinteger(l, 11, 0);

	// TODO: handle empty wndproc
	int ref              = luaL_ref(l, LUA_REGISTRYINDEX); // store a ref to the wnd proc fn
	LUA_WINDOW_CTX* ctx  = malloc(sizeof(LUA_WINDOW_CTX));
	HWND res             = 0;
	
	ctx->l = l;
	ctx->ref = ref;
	res = CreateWindowEx(dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, ctx);
	lua_pushinteger(l, res);
	return 1;
}

LRESULT CALLBACK win32_DefWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	LUA_WINDOW_CTX* ctx = NULL;
	int lResult         = 0;
	BOOL processed      = FALSE;
	BOOL destroy        = FALSE;
	lua_State *l        = NULL;

	switch(msg)
	{
	case WM_NCCREATE:
		SetWindowLongPtr(hwnd, GWLP_USERDATA, ((LPCREATESTRUCT)lParam)->lpCreateParams);
		break;
	case WM_DESTROY:
		destroy = TRUE;
	default:
		ctx = (LUA_WINDOW_CTX*) GetWindowLongPtr(hwnd, GWLP_USERDATA);
		if(ctx && ctx->ref != LUA_NOREF)
		{
			l = ctx->l;
			lua_rawgeti(l, LUA_REGISTRYINDEX, ctx->ref);
			lua_pushinteger(l, hwnd);
			lua_pushinteger(l, msg);
			lua_pushinteger(l, wParam);
			lua_pushinteger(l, lParam);
			lResult = lua_pcall(l, 4, 2, 0);
			processed = lua_toboolean(l, -2);
			lResult = lua_tointeger(l, -1);
		}
	}

	if(destroy && ctx) {
		luaL_unref(l, LUA_REGISTRYINDEX, ctx->ref);
		free(ctx);
		SetWindowLongPtr(hwnd, GWLP_USERDATA, 0);
	}

	return processed ? lResult : DefWindowProc(hwnd, msg, wParam, lParam);
};

__declspec(dllexport) int win32_DestroyWindow(lua_State *l)
{
	int hWnd = luaL_checkinteger(l, 1);
	BOOL res = DestroyWindow(hWnd);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_DrawEdge(lua_State *l)
{
	HDC hdc       = luaL_checkinteger(l, 1);
	LPRECT qrc    = (LPRECT) lua_touserdata(l, 2);
	UINT edge     = luaL_checkinteger(l, 3);
	UINT grfFlags = luaL_checkinteger(l, 4);
	BOOL res      = DrawEdge(hdc, qrc, edge, grfFlags);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_DrawFocusRect(lua_State *l)
{
	HDC hdc       = luaL_checkinteger(l, 1);
	LPRECT qrc    = (LPRECT) lua_touserdata(l, 2);
	BOOL res      = DrawFocusRect(hdc, qrc);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_DrawFrameControl(lua_State *l)
{
	HDC hdc       = luaL_checkinteger(l, 1);
	LPRECT qrc    = (LPRECT) lua_touserdata(l, 2);
	UINT uType    = luaL_checkinteger(l, 3);
	UINT uState   = luaL_checkinteger(l, 4);
	BOOL res      = DrawFrameControl(hdc, qrc, uType, uState);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_DrawText(lua_State *l)
{
	HDC hdc         = luaL_checkinteger(l, 1);
	const char* str = luaL_checkstring(l, 2);
	int nCount      = luaL_optinteger(l, 3, lua_strlen(l, 2));
	LPRECT lprc     = (LPRECT) lua_touserdata(l, 4);
	UINT format     = luaL_checkinteger(l, 5);
	int res         = DrawText(hdc, str, nCount, lprc, format);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_EndPaint(lua_State *l)
{
	HWND hwnd = luaL_checkinteger(l, 1);
	PAINTSTRUCT* ps = (PAINTSTRUCT*) lua_touserdata(l, 2);
	EndPaint(hwnd, ps);
	return 0;
}

__declspec(dllexport) int win32_FillRect(lua_State *l)
{
	HDC hdc     = luaL_checkinteger(l, 1);
	LPRECT lprc = (LPRECT) lua_touserdata(l, 2);
	HBRUSH hbr  = luaL_checkinteger(l, 3);
	int res     = FillRect(hdc, lprc, hbr);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_GetBkColor(lua_State* l)
{
	HDC hdc     = luaL_checkinteger(l, 1);
	COLORREF bk = GetBkColor(hdc);
	lua_pushinteger(l, bk);
	return 1;
}

__declspec(dllexport) int win32_GetBkMode(lua_State* l)
{
	HDC hdc  = luaL_checkinteger(l, 1);
	int mode = GetBkMode(hdc);
	lua_pushinteger(l, mode);
	return 1;
}

__declspec(dllexport) int win32_GetClientRect(lua_State* l)
{
	HWND hwnd   = luaL_checkinteger(l, 1);
	LPRECT rect = (RECT*) lua_touserdata(l, 2);
	BOOL res    = GetClientRect(hwnd, rect);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_GetCurrentDirectory(lua_State* l)
{
	char path[MAX_PATH];
	DWORD len = GetCurrentDirectory(MAX_PATH, path);
	lua_pushlstring(l, path, len);
	return 1;
}

__declspec(dllexport) int win32_GetModuleFileName(lua_State *l)
{
	char path[MAX_PATH];
	int hModule = luaL_optinteger(l, 1, 0);
	GetModuleFileName(hModule, path, MAX_PATH);
	lua_pushstring(l, path);
	return 1;
}

__declspec(dllexport) int win32_GetModuleHandle(lua_State *l)
{
	char* module = luaL_optstring(l, 1, NULL);
	HMODULE hModule = GetModuleHandle(module);
	lua_pushinteger(l, hModule);
	return 1;
}

__declspec(dllexport) int win32_GetStockObject(lua_State *l)
{
	int obj     = luaL_checkinteger(l, 1);
	HGDIOBJ hob = GetStockObject(obj);
	lua_pushinteger(l, hob);
	return 1;
}

__declspec(dllexport) int win32_GetWindowDC(lua_State *l)
{
	HWND hwnd = luaL_checkinteger(l, 1);
	HDC hdc   = GetWindowDC(hwnd);
	lua_pushinteger(l, hdc);
	return 1;
}

__declspec(dllexport) int win32_InitCommonControlsEx(lua_State *l)
{
	INITCOMMONCONTROLSEX ics;
	BOOL res;
	ics.dwSize = sizeof(INITCOMMONCONTROLSEX);
	ics.dwICC = ICC_BAR_CLASSES;
	res = InitCommonControlsEx(&ics);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_InvalidateRect(lua_State *l)
{
	HWND hwnd   = luaL_checkinteger(l, 1);
	LPRECT lprc = (LPRECT) lua_touserdata(l, 2);
	BOOL erase  = lua_toboolean(l, 3);
	BOOL res    = InvalidateRect(hwnd, lprc, erase);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_LoadCursor(lua_State *l)
{
	HCURSOR hCursor = LoadCursor(NULL, MAKEINTRESOURCE(lua_tointeger(l, 1)));
	lua_pushinteger(l, hCursor);
	return 1;
}

__declspec(dllexport) int win32_LoadIcon(lua_State *l)
{
	HICON hIcon = LoadIcon(NULL, MAKEINTRESOURCE(lua_tointeger(l, 1)));
	lua_pushinteger(l, hIcon);
	return 1;
}

__declspec(dllexport) int win32_MessageBox(lua_State *l)
{
	HWND hWnd             = luaL_optinteger(l, 1, 0);
	const char* lpText    = lua_tostring(l, 2);
	const char* lpCaption = lua_tostring(l, 3);
	UINT uType            = luaL_optinteger(l, 4, 0);
	int res               = MessageBox(hWnd, lpText, lpCaption, uType);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_MessageLoop(lua_State *l)
{
	MSG msg;
	while(GetMessage(&msg, 0, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);		
	} 	
	lua_pushinteger(l, msg.wParam);
	return 1;
}

__declspec(dllexport) int win32_OutputDebugString(lua_State *l)
{
	const char* str = lua_tostring(l, 1);
	OutputDebugString(str);
	return 0;
}

__declspec(dllexport) int win32_PostMessage(lua_State *l)
{
	HWND hwnd      = luaL_checkinteger(l, 1);
	UINT msg       = luaL_checkinteger(l, 2);
	WPARAM wparam  = luaL_optinteger(l, 3, 0);
	LPARAM lparam  = luaL_optinteger(l, 4, 0);
	BOOL res       = PostMessage(hwnd, msg, wparam, lparam);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_PostQuitMessage(lua_State *l)
{
	int nExitCode = luaL_optinteger(l, 1, 0);
	PostQuitMessage(nExitCode);
	return 0;
}

__declspec(dllexport) int win32_Rectangle(lua_State *l)
{
	HDC hdc    = luaL_checkinteger(l, 1);
	int left   = luaL_checkinteger(l, 2);
	int top    = luaL_checkinteger(l, 3);
	int right  = luaL_checkinteger(l, 4);
	int bottom = luaL_checkinteger(l, 5);
	BOOL res   = Rectangle(hdc, left, top, right, bottom);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_RedrawWindow(lua_State *l)
{
	HWND hwnd  = luaL_checkinteger(l, 1);
	BOOL res   = RedrawWindow(hwnd, NULL, NULL, RDW_INVALIDATE);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_RegisterClassEx(lua_State *l)
{
	WNDCLASSEX wc;
	ATOM res;
	
	wc.cbSize        = sizeof(WNDCLASSEX);
	wc.lpfnWndProc   = win32_DefWndProc;
	wc.lpszClassName = luaL_checkstring(l, 1);
	wc.style         = luaL_optinteger(l, 2, 0);
	wc.cbClsExtra    = luaL_optinteger(l, 3, 0);
	wc.cbWndExtra    = luaL_optinteger(l, 4, 0);
	wc.hInstance     = luaL_optinteger(l, 5, 0);
	wc.hIcon         = luaL_optinteger(l, 6, 0);
	wc.hCursor       = luaL_optinteger(l, 7, 0);
	wc.hbrBackground = luaL_optinteger(l, 8, 0);
	wc.lpszMenuName  = luaL_optstring(l, 9, NULL);
	wc.hIconSm       = luaL_optinteger(l, 10, 0);

	res = RegisterClassEx(&wc);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_SelectObject(lua_State *l)
{
	HDC hdc     = luaL_checkinteger(l, 1);
	HGDIOBJ obj = luaL_checkinteger(l, 2);
	HGDIOBJ res = SelectObject(hdc, obj);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_SendMessage(lua_State *l)
{
	HWND hwnd     = luaL_checkinteger(l, 1);
	UINT msg      = luaL_checkinteger(l, 2);
	WPARAM wparam = luaL_checkinteger(l, 3);
	LPARAM lparam = luaL_checkinteger(l, 4);
	LRESULT res   = SendMessage(hwnd, msg, wparam, lparam);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_SetBkColor(lua_State *l)
{
	HDC hdc      = luaL_checkinteger(l, 1);
	COLORREF clr = luaL_checkinteger(l, 2);
	COLORREF old = SetBkColor(hdc, clr);
	lua_pushinteger(l, old);
	return 1;
}

__declspec(dllexport) int win32_SetBkMode(lua_State *l)
{
	HDC hdc  = luaL_checkinteger(l, 1);
	int mode = luaL_checkinteger(l, 2);
	int res  = SetBkMode(hdc, mode);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_SetMenu(lua_State *l)
{
	HWND hwnd  = luaL_checkinteger(l, 1);
	HMENU menu = luaL_checkinteger(l, 2);
	BOOL res   = SetMenu(hwnd, menu);;
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_SetTextColor(lua_State *l)
{
	HDC hdc      = luaL_checkinteger(l, 1);
	COLORREF clr = luaL_checkinteger(l, 2);
	COLORREF res = SetTextColor(hdc, clr);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_ShowWindow(lua_State *l)
{
	HWND hwnd = luaL_checkinteger(l, 1);
	int cmd   = luaL_checkinteger(l, 2);
	BOOL res  = ShowWindow(hwnd, cmd);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_TextOut(lua_State *l)
{
	HDC hdc              = luaL_checkinteger(l, 1);
	int x                = luaL_checkinteger(l, 2);
	int y                = luaL_checkinteger(l, 3);
	const char* lpString = luaL_checkstring(l, 4);
	int c                = luaL_optinteger(l, 5, lua_strlen(l, 4));
	BOOL res             = TextOut(hdc, x, y, lpString, c);
	lua_pushboolean(l, res);
	return 1;
}

__declspec(dllexport) int win32_UpdateWindow(lua_State *l)
{
	HWND hwnd = luaL_checkinteger(l, 1);
	BOOL res  = UpdateWindow(hwnd);
	lua_pushboolean(l, res);
	return 1;
}

// WINSOCK

__declspec(dllexport) int win32_accept(lua_State *l)
{
	SOCKET s = luaL_checkinteger(l, 1);
	SOCKET a = accept(s, 0, 0);
	lua_pushinteger(l, a);
	return 1;
}

__declspec(dllexport) int win32_AcceptEx(lua_State *l)
{
	SOCKET sListenSocket = luaL_checkinteger(l, 1);
	SOCKET sAcceptSocket = luaL_checkinteger(l, 2);
	PVOID lpOutputBuffer = lua_touserdata(l, 3);
	DWORD dwReceiveDataLength = luaL_checkinteger(l, 4);
	DWORD dwLocalAddressLength = luaL_checkinteger(l, 5);
	DWORD dwRemoteAddressLength = luaL_checkinteger(l, 6);
	DWORD dwBytesReceived;
	LPOVERLAPPED lpOverlapped = lua_touserdata(l, 7);
	BOOL res = AcceptEx(sListenSocket, sAcceptSocket, lpOutputBuffer, dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength, &dwBytesReceived, lpOverlapped);
	lua_pushboolean(l, res);
	lua_pushinteger(l, dwBytesReceived);
	return 2;
}

typedef struct {
	int len;
	struct sockaddr sa;
} SOCKADDREX;

__declspec(dllexport) int win32_bind(lua_State *l)
{
	SOCKET s = luaL_checkinteger(l, 1);
	const SOCKADDREX* namex = lua_touserdata(l, 2);
	int res = bind(s, &namex->sa, namex->len);
	lua_pushinteger(l, 1);
	return 1;
}

__declspec(dllexport) int win32_closesocket(lua_State *l)
{
	SOCKET s = luaL_checkinteger(l, 1);
	int res = closesocket(s);
	lua_pushinteger(l, res);
	return 1;
}

__declspec(dllexport) int win32_connect(lua_State *l)
{
	SOCKET s = luaL_checkinteger(l, 1);
	const SOCKADDREX* namex = lua_touserdata(l, 2);
	int res = connect(s, &namex->sa, namex->len);
	lua_pushinteger(l, 1);
	return 1;
}

__declspec(dllexport) int win32_ConnectEx(lua_State *l)
{
	SOCKET s = luaL_checkinteger(l, 1);
	const SOCKADDREX* namex = lua_touserdata(l, 2);
	PVOID lpSendBuffer = lua_touserdata(l, 3);
}

// HELPERS

__declspec(dllexport) int win32_RGB(lua_State *l)
{
	int r = luaL_optinteger(l, 1, 0);
	int g = luaL_optinteger(l, 2, 0);
	int b = luaL_optinteger(l, 3, 0);
	lua_pushinteger(l, RGB(r, g, b));
	return 1;
}

__declspec(dllexport) int win32_RECT_new(lua_State *l)
{
	int left   = luaL_optinteger(l, 1, 0);
	int top    = luaL_optinteger(l, 2, 0);
	int right  = luaL_optinteger(l, 3, 0);
	int bottom = luaL_optinteger(l, 4, 0);
	RECT* lprc = (RECT*) lua_newuserdata(l, sizeof(RECT));
	lprc->left = left;
	lprc->top  = top;
	lprc->right = right;
	lprc->bottom = bottom;
	return 1;
}

__declspec(dllexport) int win32_RECT_get(lua_State *l)
{
	int* lprc  = (int*) lua_touserdata(l, 1);
	int idx    = luaL_checkinteger(l, 2);
	int val    = lprc[idx];
	lua_pushinteger(l, val);
	return 1;
}