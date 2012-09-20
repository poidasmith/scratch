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

__declspec(dllexport) int win32_LoadCursor(lua_State *l)
{
	HCURSOR hCursor;
	if(lua_isstring(l, 1))
		hCursor = LoadCursor(NULL, lua_tostring(l, 1));
	else
		hCursor = LoadCursor(NULL, MAKEINTRESOURCE(lua_tointeger(l, 1)));
	lua_pushinteger(l, hCursor);
	return 1;
}

__declspec(dllexport) int win32_LoadIcon(lua_State *l)
{
	HICON hIcon;
	if(lua_isstring(l, 1))
		hIcon = LoadIcon(NULL, lua_tostring(l, 1));
	else
		hIcon = LoadIcon(NULL, MAKEINTRESOURCE(lua_tointeger(l, 1)));
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

__declspec(dllexport) int win32_RegisterClassEx(lua_State *l)
{
	WNDCLASSEX wc;
	ATOM res;
	
	wc.cbSize        = sizeof(WNDCLASSEX);
	wc.lpfnWndProc   = win32_DefWndProc;
	wc.lpszClassName = luaL_checkstring(l, 1);
	wc.style         = luaL_optinteger(l, 2, 0);
	wc.cbClsExtra    = luaL_optinteger(l, 2, 0);
	wc.cbWndExtra    = luaL_optinteger(l, 3, 0);
	wc.hInstance     = luaL_optinteger(l, 4, 0);
	wc.hIcon         = luaL_optinteger(l, 5, 0);
	wc.hCursor       = luaL_optinteger(l, 6, 0);
	wc.hbrBackground = luaL_optinteger(l, 7, 0);
	wc.lpszMenuName  = luaL_optstring(l, 8, NULL);
	wc.hIconSm       = luaL_optinteger(l, 9, 0);

	res = RegisterClassEx(&wc);
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

