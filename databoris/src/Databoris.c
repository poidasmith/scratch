/******************************************************************************
* This program and the accompanying materials
* are made available under the terms of the Common Public License v1.0
* which accompanies this distribution, and is available at 
* http://www.eclipse.org/legal/cpl-v10.html
* 
* Contributors:
*     Peter Smith
*******************************************************************************/

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <windows.h>
#include <commctrl.h>

#define RT_INI_FILE MAKEINTRESOURCE(687)
#define RES_MAGIC_SIZE 4
#define INI_RES_MAGIC MAKEFOURCC('I','N','I',' ')


int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	int s = 1;
	HRSRC hi;
	char *script, *err;
	lua_State *l;
	char temp[MAX_PATH];

	l = lua_open();
	luaL_openlibs(l); // stdlibs

	// Load and execute "kernel"
	hi = FindResource(hInstance, MAKEINTRESOURCE(1), MAKEINTRESOURCE(RT_INI_FILE));
	if(hi)	{
		HGLOBAL hg = LoadResource(hInstance, hi);
		PBYTE pb = (PBYTE) LockResource(hg);
		DWORD* pd = (DWORD*) pb;
		script = *pd == INI_RES_MAGIC ? (char *) &pb[RES_MAGIC_SIZE] : (char *) pb;
		s = luaL_dostring(l, script);	
	}

	// Check result
	if(s) {
		err = lua_tostring(l, -1);
		OutputDebugString("dbos: ");
		OutputDebugString(err == NULL ? "script could not be loaded\n" : err);
		return -1;
	} 

	// Run our main
	lua_getglobal(l, "main");
	lua_pushinteger(l, hInstance);
	lua_pushinteger(l, hPrevInstance);
	lua_pushstring(l, lpCmdLine);
	lua_pushinteger(l, nCmdShow);
	lua_pcall(l, 4, 1, 0);

	return lua_tointeger(l, -1);
}
