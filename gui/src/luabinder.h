#pragma once
/*
		Lua class with multiple inheritance by David Demelier
		http://lua-users.org/lists/lua-l/2013-06/msg00492.html
*/
#include <vector>
#include <string>
#include "lua.hpp"

template<class T>
class LuaBinder
{
public:
	static const luaL_Reg metamethods[];
	static const luaL_Reg methods[];
	std::vector<std::string> inherits;
	void createClass(lua_State* L);
};

int lookup(lua_State* L);

template<class T>
void LuaBinder<T>::createClass(lua_State* L)
{
	// createMetatable
	luaL_newmetatable(L, T::classname());

	// Add optional metamethods, except __index
	luaL_setfuncs(L, metamethods, 0);

	// Add methods
	lua_createtable(L, 0, 0);
	luaL_setfuncs(L, methods, 0);
	lua_setfield(L, -2, "__index"); // mt.__index = methods
	lua_pop(L, 1);

	// createInheritance
	if (inherits.size())
	{
		luaL_getmetatable(L, T::classname());
		lua_getfield(L, -1, "__index");

		lua_createtable(L, 1, 1);
		lua_pushcfunction(L, lookup);
		lua_setfield(L, -2, "__index");
		lua_createtable(L, inherits.size(), inherits.size());

		for (int i = 0; i < inherits.size();) {
			lua_pushstring(L, inherits[i].c_str());
			lua_rawseti(L, -2, ++i);
		}

		lua_setfield(L, -2, "inherits");
		lua_setmetatable(L, -2);
		lua_pop(L, 2);
	}
}

//////////////////////////////////////////////////////

template<class T>
inline void lua_push_newobject(lua_State* L, T* pObj)
{
	T** data = reinterpret_cast<T**>(lua_newuserdata(L, sizeof(T*)));
	*data = pObj;
	luaL_getmetatable(L, T::classname());
	lua_setmetatable(L, -2);
}

template<class T>
inline T* check_udata(lua_State* L, int n = 1)
{
	T** obj = reinterpret_cast<T**>(lua_touserdata(L, n));
	//T** obj = reinterpret_cast<T**>(luaL_checkudata(L, n, T::classname()));
	return obj ? *obj : NULL;
}

template<class T>
inline T* check_arg(lua_State* L)
{
	T* obj = check_udata<T>(L);
	if (!obj)
	{
		lua_pushfstring(L, "there is not %s", T::classname());
		lua_error(L);
	}
	return obj;
}

template<class T>
inline int do_destroy(lua_State* L)
{
	if (T* obj = check_udata<T>(L))
		delete obj;
	return 0;
}
