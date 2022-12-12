#pragma once
#include "luabinder.h"

class testA
{
protected:
	int x;
public:
	testA(int _x = 2);
	~testA();
	int get_x();
	void set_x(int);
	static const char* classname() { return "testA"; }
};

class testB : public testA
{
public:
	testB();
	~testB();
	int get_x() { return x * x; }
	static const char* classname() { return "testB"; }
};
