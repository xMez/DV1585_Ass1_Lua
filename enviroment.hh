#ifndef ENVIROMENT_HH
#define ENVIROMENT_HH
#include <string>
#include <map>
class Enviroment {
public:
	int value = 53;
	std::map<std::string, std::string> vars;
	Enviroment() {}
};
#endif
