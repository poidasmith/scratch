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
	lua_pushstring(l, lpCmdLine);
	lua_pcall(l, 1, 1, 0);

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


/*

1. variants/tables (first part to do)
	- decide on variants vs tables
	- encode/decode as binary (with crc checksums?)
	- need to encode/decode files and sockets; some stream impl perhaps
	- encode as diff for edits on large tables (path-based diffs at first level probably)
	- can we use code fragments to encode diffs?
	- can look at: http://files.luaforge.net/releases/bintable/bintable/bintable-0.1
2. file/buffer handling
	- open file, setvbuf, close
	- performance tests
3. database
	- in-memory structure (skiplist, indexes (name, type, other), compartments)
	- http://git.cyrusimap.org/cyrus-imapd/tree/lib/cyrusdb_skiplist.c
	- http://www.dekorte.com/projects/opensource/skipdb/
	- how to handle iteration of variants/tables by type and name?
	- transaction id, database id
	- structure of files (error handling, checksums)
	- transaction logs
	- table of transactions to log files
	- incremental change and compression of logs into an image
4. networking
	- socket select, open, close, bind, accept?
	- handler framework (fn name and table of args)
	- function impls (insert, update, remove, admin)
5. replication
	- topic/queue system
	- listeners for transactions
6. graph
	- a node contains attributes that depend on other nodes (and attributes within the node)
	- an attribute is calculated or a datastore
	- how to refer to the code? 
	- https://github.com/amix/redis_graph

*/

int dbos_debug_print(lua_State *l)
{	
	const char* str = luaL_checkstring(l, 1);

	if(str)
		OutputDebugString(str);

	return 0;
}

void dbos_openlib(lua_State *l)
{
	static const luaL_reg fns[] = 
	{
		{ "encode",      dbos_encode },
		{ "decode",      dbos_decode },
		{ "debug_print", dbos_debug_print },
	    { NULL,          NULL             }
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