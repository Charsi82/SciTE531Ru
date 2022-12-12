//#include "testab.h"
//void log_add(const char* s, int val = 0);
//
//testA::testA(int _x) {
//	log_add("new testA");
//	x = _x;
//};
//
//testA::~testA() {
//	log_add("~testA");
//}
//
//void testA::set_x(int _x)
//{
//	x = _x;
//}
//
//int testA::get_x()
//{
//	return x;
//}
//
//int do_set_x(lua_State* L)
//{
//	if (testA* obj = check_udata<testA>(L)) {
//		int tmp = lua_tointeger(L, 2);
//		obj->set_x(tmp);
//	}
//	return 0;
//}
//
//int do_get_x(lua_State* L)
//{
//	if (testA* obj = check_udata<testA>(L)) {
//		lua_pushinteger(L, obj->get_x());
//		return 1;
//	}
//	return 0;
//}
//
//const luaL_Reg LuaBinder<testA>::metamethods[] =
//{
//	{ "__gc", do_destroy<testA> },
//	{ NULL, NULL}
//};
//
//const luaL_Reg LuaBinder<testA>::methods[] =
//{
//	{ "set_x", do_set_x },
//	{ "get_x", do_get_x },
//	{ NULL, NULL}
//};
//
//void lua_openclass_testA(lua_State* L)
//{
//	LuaBinder<testA> lb;
//	lb.createClass(L);
//}
//
//int new_testA(lua_State* L)
//{
//	lua_push_newobject(L, new testA);
//	return 1;
//}
//
///////////////////////  class B  ////////////////////
//testB::testB() : testA(3)
//{
//	log_add("new testB");
//};
//
//testB::~testB()
//{
//	log_add("~testB");
//}
//
//int do_getB_x(lua_State* L)
//{
//	if (testB* obj = check_arg<testB>(L)) {
//		lua_pushinteger(L, obj->get_x());
//	}
//	return 1;
//}
//
//const luaL_Reg LuaBinder<testB>::metamethods[] =
//{
//	{ "__gc", do_destroy<testB> },
//	{ NULL,NULL}
//};
//
//const luaL_Reg LuaBinder<testB>::methods[] =
//{
//	{ "get_x", do_getB_x },
//	{ NULL,NULL}
//};
//
//void lua_openclass_testB(lua_State* L)
//{
//	LuaBinder<testB> lb;
//	lb.inherits.push_back("testA");
//	lb.createClass(L);
//}
//
//int new_testB(lua_State* L)
//{
//	lua_push_newobject(L, new testB);
//	return 1;
//}