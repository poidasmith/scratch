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

int win32_CreateIconFromResourceEx(lua_State *l)
{
	

	return 1;
}

// A structure that we pass through windows and store in GWLP_USERDATA so we
// can call through the window handler functions in Lua
typedef struct {
	lua_State* l;
	int ref;
} LUA_WINDOW_CTX;

int win32_CreateWindowEx(lua_State *l)
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

int win32_DestroyWindow(lua_State *l)
{
	int hWnd = luaL_checkinteger(l, 1);
	BOOL res = DestroyWindow(hWnd);
	lua_pushboolean(l, res);
	return 1;
}

int win32_GetModuleFileName(lua_State *l)
{
	char path[MAX_PATH];
	int hModule = luaL_optinteger(l, 1, 0);
	GetModuleFileName(hModule, path, MAX_PATH);
	lua_pushstring(l, path);
	return 1;
}

int win32_GetModuleHandle(lua_State *l)
{
	char* module = luaL_optstring(l, 1, NULL);
	HMODULE hModule = GetModuleHandle(module);
	lua_pushinteger(l, hModule);
	return 1;
}

int win32_LoadCursor(lua_State *l)
{
	HCURSOR hCursor;
	if(lua_isstring(l, 1))
		hCursor = LoadCursor(NULL, lua_tostring(l, 1));
	else
		hCursor = LoadCursor(NULL, MAKEINTRESOURCE(lua_tointeger(l, 1)));
	lua_pushinteger(l, hCursor);
	return 1;
}

int win32_LoadIcon(lua_State *l)
{
	HICON hIcon;
	if(lua_isstring(l, 1))
		hIcon = LoadIcon(NULL, lua_tostring(l, 1));
	else
		hIcon = LoadIcon(NULL, MAKEINTRESOURCE(lua_tointeger(l, 1)));
	lua_pushinteger(l, hIcon);
	return 1;
}

int win32_MessageBox(lua_State *l)
{
	HWND hWnd             = luaL_optinteger(l, 1, 0);
	const char* lpText    = lua_tostring(l, 2);
	const char* lpCaption = lua_tostring(l, 3);
	UINT uType            = luaL_optinteger(l, 4, 0);
	int res               = MessageBox(hWnd, lpText, lpCaption, uType);
	lua_pushinteger(l, res);
	return 1;
}

int win32_MessageLoop(lua_State *l)
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

int win32_PostMessage(lua_State *l)
{
	HWND hwnd      = luaL_checkinteger(l, 1);
	UINT msg       = luaL_checkinteger(l, 2);
	WPARAM wparam  = luaL_optinteger(l, 3, 0);
	LPARAM lparam  = luaL_optinteger(l, 4, 0);
	BOOL res       = PostMessage(hwnd, msg, wparam, lparam);
	lua_pushboolean(l, res);
	return 1;
}

int win32_PostQuitMessage(lua_State *l)
{
	int nExitCode = luaL_optinteger(l, 1, 0);
	PostQuitMessage(nExitCode);
	return 0;
}

int win32_RegisterClassEx(lua_State *l)
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

int win32_ShowWindow(lua_State *l)
{
	HWND hwnd = luaL_checkinteger(l, 1);
	int cmd   = luaL_checkinteger(l, 2);
	BOOL res  = ShowWindow(hwnd, cmd);

	lua_pushboolean(l, res);
	return 1;
}

int win32_UpdateWindow(lua_State *l)
{
	HWND hwnd = luaL_checkinteger(l, 1);
	BOOL res  = UpdateWindow(hwnd);

	lua_pushboolean(l, res);
	return 1;
}

void win32_openlib(lua_State *l)
{
	static const luaL_reg fns[] = 
	{
		{ "CreateWindowEx",    win32_CreateWindowEx },
		{ "DestroyWindow",     win32_DestroyWindow },
		{ "GetModuleFileName", win32_GetModuleFileName },
		{ "GetModuleHandle",   win32_GetModuleHandle },
		{ "LoadCursor",        win32_LoadCursor },
		{ "LoadIcon",          win32_LoadIcon },
		{ "MessageBox",        win32_MessageBox },
		{ "MessageLoop",	   win32_MessageLoop },
		{ "PostMessage",       win32_PostMessage },
		{ "PostQuitMessage",   win32_PostQuitMessage },
		{ "RegisterClassEx",   win32_RegisterClassEx },
		{ "ShowWindow",		   win32_ShowWindow },
		{ "UpdateWindow",	   win32_UpdateWindow },
	    { NULL,                NULL             }
	};

	lua_newtable(l);	
	lua_setglobal(l, "win32");
	luaL_register(l, "win32", fns);
};