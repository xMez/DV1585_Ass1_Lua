#ifndef ENVIROMENT_HH
#define ENVIROMENT_HH
#include <string>
#include <map>
#include <utility>
class Enviroment {
public:
	int value = 53;
	Enviroment() {}
	void assign(std::string key, std::string type, std::string value)
	{
		vars[key] = std::make_pair(type, value);
	}
	std::string eval(std::string key)
	{
		return vars[key].second;
	}

private:
	std::map<std::string, std::pair<std::string, std::string>> vars;
};
#endif
