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

__declspec(dllexport) int bit_orr(lua_State *l)
{
	int v1 = luaL_optinteger(l, 1, 0);
	int v2 = luaL_optinteger(l, 2, 0);
	int v3 = luaL_optinteger(l, 3, 0);
	int v4 = luaL_optinteger(l, 4, 0);
	int v5 = luaL_optinteger(l, 5, 0);
	lua_pushinteger(l, v1 | v2 | v3 | v4 | v5);
	return 1;
}

__declspec(dllexport) int bit_and(lua_State *l)
{
	int v1 = luaL_optinteger(l, 1, 0);
	int v2 = luaL_optinteger(l, 2, 0);
	int v3 = luaL_optinteger(l, 3, 0);
	int v4 = luaL_optinteger(l, 4, 0);
	int v5 = luaL_optinteger(l, 5, 0);
	lua_pushinteger(l, v1 & v2 & v3 & v4 & v5);
	return 1;
}

__declspec(dllexport) int bit_xor(lua_State *l)
{
	int v1 = luaL_optinteger(l, 1, 0);
	int v2 = luaL_optinteger(l, 2, 0);
	int v3 = luaL_optinteger(l, 3, 0);
	int v4 = luaL_optinteger(l, 4, 0);
	int v5 = luaL_optinteger(l, 5, 0);
	lua_pushinteger(l, v1 & v2 & v3 & v4 & v5);
	return 1;
}

__declspec(dllexport) int bit_not(lua_State *l)
{
	lua_pushinteger(l, LOWORD(luaL_optinteger(l, 1, 0)));
	return 1;
}

__declspec(dllexport) int bit_loword(lua_State *l)
{
	lua_pushinteger(l, LOWORD(luaL_optinteger(l, 1, 0)));
	return 1;
}

__declspec(dllexport) int bit_hiword(lua_State *l)
{
	lua_pushinteger(l, HIWORD(luaL_optinteger(l, 1, 0)));
	return 1;
}

