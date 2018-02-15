#ifndef NODE_HH
#define NODE_HH
#include <iostream>
#include <sstream>
#include <string>
#include <list>
#include <cmath>
#include "enviroment.hh"
class Node {
public:
	std::string tag, value;
	std::list<Node> children;
	static Enviroment globals;
	Node(std::string t, std::string v) : tag(t), value(v) {}
	Node() { tag="uninitilized"; value="uninitialized"; }
	void dump(int depth=0)
	{
		for(int i=0; i<depth; i++)
			std::cout << "  ";
		std::cout << tag << ":" << value << std::endl;
		for(auto i=children.begin(); i!=children.end(); i++)
			(*i).dump(depth+1);
	}
	std::ostringstream toStream(int &depth, int parent=0)
	{
		std::ostringstream oss;
		oss << depth << " [label=\"" << tag << ":" << value << "\"];\n";
		for(auto i=children.begin(); i!=children.end(); i++)
		{
			depth++;
			oss << parent << " -> " << depth << "\n";
			oss << (*i).toStream(depth, depth).str();
		}
		parent++;
		return oss;
	}
	float execute()
	{
		float result;
		if(tag == "NUMBER")
			result = std::stoi(value);
		else if(tag == "binop")
		{
			Node &val1 = children.front();
			Node &val2 = children.back();
			if(value == "^")
				result = std::pow(val2.execute(), val1.execute());
			else if(value == "%")
				result = std::fmod(val1.execute(), val2.execute());
			else if(value == "/")
				result = val1.execute() / val2.execute();
			else if(value == "*")
				result = val1.execute() * val2.execute();
			else if(value == "-")
				result = val1.execute() - val2.execute();
			else if(value == "+")
				result = val1.execute() + val2.execute();
			//else if(value == "..")
				//result = children.front().value + children.back().value;
			else if(value == "==")
				result = val1.execute() == val2.execute();
			//else if(value == "~=")
			//	result = val1.execute() % val2.execute();
			else if(value == ">=")
				result = val1.execute() >= val2.execute();
			else if(value == "<=")
				result = val1.execute() <= val2.execute();
			else if(value == ">")
				result = val1.execute() > val2.execute();
			else if(value == "<")
				result = val1.execute() < val2.execute();
			else if(value == "and")
				result = val1.execute() && val2.execute();
			else if(value == "or")
				result = val1.execute() || val2.execute();
		}
		else if(tag == "varlist")
		{
		}	
		else if(tag == "explist")
		{
			result = children.front().execute();
		}
		else if(tag == "stat")
		{
		}	
		else if(tag == "functioncall")
		{
			std::string name = children.front().value;
			if(name == "print")
				std::cout << children.back().execute();
		}
		else if(tag == "chunk")
		for(auto i=children.begin(); i!=children.end(); i++)
			(*i).execute();
		else if(tag == "block")
			result = children.front().execute();
		return result;
	}
};
#endif
