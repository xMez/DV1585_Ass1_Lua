#include "node.hh"
Enviroment Node::globals;
void Node::dump(int depth)
{
	for(int i=0; i<depth; i++)
		std::cout << "  ";
	std::cout << tag << ":" << value << std::endl;
	for(auto i=children.begin(); i!=children.end(); i++)
		(*i).dump(depth+1);
}

std::ostringstream Node::toStream(int &depth, int parent)
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
float Node::execute()
{
	float result;
	if(tag == "NUMBER")
		result = std::stof(value);
	else if(tag == "NAME")
		result = std::stof(globals.eval(value));
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
	else if(tag == "explist")
	{
		result = children.front().execute();
	}
	else if(tag == "stat")
	{
		assignVar(children.front().children.front(), children.back());
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
void Node::assignVar(Node &key, Node &value)
{
	std::cout << "new var " << key.value << std::endl;
	globals.assign(key.value, std::to_string(value.execute()));
	std::cout << globals.eval(key.value) << std::endl;
}
