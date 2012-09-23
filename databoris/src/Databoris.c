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

#define RT_INI_FILE MAKEINTRESOURCE(687)
#define RES_MAGIC_SIZE 4
#define INI_RES_MAGIC MAKEFOURCC('I','N','I',' ')

void dbos_openlib(lua_State *l);

// Helper stubs
void dbos_dump_stack(lua_State *L);

int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	int s = 1;
	HRSRC hi;
	char *script, *err;
	lua_State *l;
	char temp[MAX_PATH];

	l = lua_open();
	luaL_openlibs(l); // stdlibs
	dbos_openlib(l);

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
	lua_getglobal(l, "dbos");
	lua_pushstring(l, "main");
	lua_rawget(l, -2);
	lua_pushinteger(l, hInstance);
	lua_pushinteger(l, hPrevInstance);
	lua_pushstring(l, lpCmdLine);
	lua_pushinteger(l, nCmdShow);
	lua_pcall(l, 4, 1, 0);

	return lua_tointeger(l, -1);
}

int dbos_encode(lua_State *l)
{
	return 0;
}

int dbos_decode(lua_State *l)
{
	return 0;
}

int dbos_debug_print(lua_State *l)
{	
	const char* str = luaL_checkstring(l, 1);

	if(str)
		OutputDebugString(str);

	return 0;
}

int dbos_table_ref_test(lua_State *l)
{

}

int dbos_GetProcAddress(lua_State *l)
{
	const char* fn = luaL_checkstring(l, 1);
	FARPROC proc   = GetProcAddress(NULL, fn);
	lua_pushcfunction(l, (lua_CFunction) proc);
	return 1;
}

void dbos_openlib(lua_State *l)
{
	static const luaL_reg fns[] = 
	{
		{ "encode",         dbos_encode      },
		{ "decode",         dbos_decode      },
		{ "debug_print",    dbos_debug_print },
		{ "GetProcAddress", dbos_GetProcAddress },
	    { NULL,             NULL             }
	};

	lua_newtable(l);	
	lua_setglobal(l, "dbos");
	luaL_register(l, "dbos", fns);
};

void dbos_dump_stack(lua_State *L) 
{
	char tmp[1000];
	int i;
	int top = lua_gettop(L);

	for (i = 1; i <= top; i++) {  
		int t = lua_type(L, i);
		switch (t) 
		{
			case LUA_TBOOLEAN:  
				sprintf(tmp, "d: %s\n", i, lua_toboolean(L, i) ? "true" : "false");
				break;
			case LUA_TNUMBER:  
				sprintf(tmp, "%d: %g\n", i, lua_tonumber(L, i));
				break;
			case LUA_TSTRING:  
				sprintf(tmp, "%d: `%s'\n", i, lua_tostring(L, i));
				break;
			default:  
				sprintf(tmp, "%d: type(%s)\n", i, lua_typename(L, t));
			break;
		}

		OutputDebugString(tmp);
	}
}