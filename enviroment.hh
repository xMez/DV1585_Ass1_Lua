#ifndef ENVIROMENT_HH
#define ENVIROMENT_HH
#include <string>
#include <map>
class Enviroment {
public:
	int value = 53;
	Enviroment() {}
	void assign(std::string key, std::string value)
	{
		if(vars.find(key) == vars.end())
			vars.insert(std::make_pair(key, value));
		else
			vars[key] = value;
	}
	std::string eval(std::string key)
	{
		return vars[key];
	}

private:
	std::map<std::string, std::string> vars;
};
#endif
