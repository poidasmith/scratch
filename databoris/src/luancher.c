// Minimal Lua launcher - copy luancher.exe to myapp.exe, create myapp.lua, luanch.

#include <windows.h>
#include <lua.h>
#include <luaxlib.h>
#include <lualib.h>
#pragma comment(lib, "lua51.lib")

int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	TCHAR fn[MAX_PATH];
	int res, len = GetModuleFileName(hInstance, fn, MAX_PATH);
	lua_State* l = luaL_newstate();
	luaL_openlibs(l);
	memcpy(&fn[len-3], "lua", 3); // .exe -> .lua
	if(GetFileAttributes(fn) == INVALID_FILE_ATTRIBUTES) // check file exists
		return 1;
	if(AttachConsole(ATTACH_PARENT_PROCESS)) { // attach std streams to console
		freopen("CONIN$", "r", stdin);
		freopen("CONOUT$", "w", stdout);
		freopen("CONOUT$", "w", stderr);
		printf("\n");
	}
	res = luaL_dofile(1, fn); // execute the lua file
	lua_close(l);
	return res;
}