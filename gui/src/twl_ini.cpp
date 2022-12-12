// TWL_INI.CPP
/*
 * Steve Donovan, 2003
 * This is GPL'd software, and the usual disclaimers apply.
 * See LICENCE
*/
#include "Twl.h"
#include "twl_ini.h"
#include "luabinder.h"
#include "utf.h"

class IniFile {
private:
	static const int BUFSZ = MAX_PATH;
	static TCHAR tmpbuff[BUFSZ];
	TCHAR m_file[BUFSZ], m_section[BUFSZ];
public:
	IniFile(pchar file, bool in_cwd = false);
	static const char* classname() { return "IniFile"; }
	void set_section(pchar section);
	void write_string(pchar key, pchar value);
	TCHAR* read_string(pchar key, pchar def = L"");
	void write_number(pchar key, double val);
	double read_number(pchar key, double def = 0.0);
};

wchar_t IniFile::tmpbuff[BUFSZ]{};

IniFile::IniFile(pchar file, bool in_cwd)
{
	lstrcpy(m_section, L"default_section");
	if (!in_cwd)
		lstrcpy(m_file, file);
	else if (!lstrlen(m_file)) {
		ZeroMemory(m_file, BUFSZ);
		int nLen = GetModuleFileName(NULL, m_file, BUFSZ);
		while (nLen > 0 && m_file[nLen] != L'\\') m_file[nLen--] = 0;
		lstrcat(m_file, file);
	}
}

void IniFile::write_number(pchar key, double val)
{
	write_string(key, std::to_wstring(val).c_str());
}

double IniFile::read_number(pchar key, double def)
{
	std::wstring s = read_string(key);
	return (s.size()) ? _wtof(s.c_str()) : def;
}

void IniFile::set_section(pchar section)
{
	lstrcpy(m_section, section);
}

void IniFile::write_string(pchar key, pchar value)
{
	WritePrivateProfileString(m_section, key, value, m_file);
}

TCHAR* IniFile::read_string(pchar key, pchar def)
{
	GetPrivateProfileString(m_section, key, def, tmpbuff, BUFSZ, m_file);
	return tmpbuff;
}

//////////////////////////////////

#define check_inifile check_arg<IniFile>

// ini:set_section(sect)
int do_set_section(lua_State* L)
{
	IniFile* pini = check_inifile(L);
	const char* sect = luaL_checkstring(L, 2);
	pini->set_section(StringFromUTF8(sect).c_str());
	return 0;
}

// ini:write_string(key, val)
int do_write_string(lua_State* L)
{
	IniFile* pini = check_inifile(L);
	const char* key = luaL_checkstring(L, 2);
	const char* val = lua_tostring(L, 3);
	pini->write_string(StringFromUTF8(key).c_str(), StringFromUTF8(val).c_str());
	return 0;
}

// ini:read_string(sect[, def=""])
int do_read_string(lua_State* L)
{
	IniFile* pini = check_inifile(L);
	const char* key = luaL_checkstring(L, 2);
	const char* def = luaL_optstring(L, 3, "");
	std::wstring str = pini->read_string(StringFromUTF8(key).c_str());
	lua_pushstring(L, str.size() ? UTF8FromString(str).c_str() : def);
	return 1;
}

// ini:read_number(sect[, def=0])
int do_read_number(lua_State* L)
{
	IniFile* pini = check_inifile(L);
	const char* key = luaL_checkstring(L, 2);
	lua_Number def = luaL_optnumber(L, 3, 0.0);
	lua_Number res = pini->read_number(StringFromUTF8(key).c_str(), def);
	lua_pushnumber(L, res);
	if (res == lua_tointeger(L, -1)) lua_pushinteger(L, res);
	return 1;
}

const luaL_Reg LuaBinder<IniFile>::metamethods[] =
{
	{ "__gc", do_destroy<IniFile> },
	{ NULL, NULL}
};

const luaL_Reg LuaBinder<IniFile>::methods[] =
{
	{"set_section", do_set_section},
	{"write_string", do_write_string},
	{"write_number", do_write_string},
	{"read_string", do_read_string},
	{"read_number", do_read_number},
	{ NULL, NULL}
};

void lua_openclass_iniFile(lua_State* L)
{
	LuaBinder<IniFile>().createClass(L);
}

int new_inifile(lua_State* L)
{
	const char* path = luaL_checkstring(L, 1);
	bool in_cwd = lua_toboolean(L, 2);
	lua_push_newobject(L, new IniFile(StringFromUTF8(path).c_str(), in_cwd));
	return 1;
}