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
	else if(tag == "string")
	{}	
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
		std::string type = children.front().tag;
		if(type == "varlist")
			assignVar(children.front().children.front(), children.back());
	}	
	else if(tag == "functioncall")
	{
		std::string name = children.front().value;
		if(name == "print")
			std::cout << toString(children.back()) << std::endl;
	}
	else if(tag == "chunk")
	for(auto i=children.begin(); i!=children.end(); i++)
		(*i).execute();
	else if(tag == "block")
		result = children.front().execute();
	return result;
}
std::string Node::eval(Node &exp)
{
	std::string result;
	if(exp.tag == "NUMBER")
		result = std::stof(exp.value);
	else if(exp.tag == "NAME")
		result = std::stof(globals.eval(exp.value));
	else if(exp.tag == "string")
		result = exp.value;
	else if(exp.tag == "binop")
	{
		Node &op1 = children.front();
		Node &op2 = children.back();
		if(op1.tag == "NUMBER" && op2.tag == "NUMBER")
		{
			float val1 = std::stof(op1.eval());
			float val2 = std::stof(op2.eval());
		}
		else if(op1.tag == "NUMBER")
		{}
		else
		{
			std::string val1 = op1.eval();
			std::string val2 = op2.eval();
		}
		if(value == "^")
			result = std::pow(val2, val1);
		else if(value == "%")
			result = std::fmod(val1, val2);
		else if(value == "/")
			result = val1 / val2;
		else if(value == "*")
			result = val1 * val2;
		else if(value == "-")
			result = val1 - val2;
		else if(value == "+")
			result = val1 + val2;
		//else if(value == "..")
			//result = children.front().value + children.back().value;
		else if(value == "==")
			result = val1 == val2;
		//else if(value == "~=")
		//	result = val1.execute() % val2.execute();
		else if(value == ">=")
			result = val1 >= val2;
		else if(value == "<=")
			result = val1 <= val2;
		else if(value == ">")
			result = val1 > val2;
		else if(value == "<")
			result = val1 < val2;
		else if(value == "and")
			result = val1 && val2;
		else if(value == "or")
			result = val1 || val2;
	}
	return result;	
}
float Node::binopNum(Node &op)
{
	float result;
	if(op.tag == "NUMBER")
		result = std::stof(op.value);
	else if(op.tag == "NAME")
		result = std::stof(globals.eval(op.value));
	else
	{
		float val1 = binopNum(children.front());
		float val2 = binopNum(children.back());
		if(op.value == "^")
			result = std::pow(val2, val1);
		else if(op.value == "%")
			result = std::fmod(val1, val2);
		else if(op.value == "/")
			result = val1 / val2;
		else if(op.value == "*")
			result = val1 * val2;
		else if(op.value == "-")
			result = val1 - val2;
		else if(op.value == "+")
			result = val1 + val2;
		//else if(op.value == "..")
			//result = children.front().value + children.back().value;
		else if(op.value == "==")
			result = val1 == val2;
		//else if(op.value == "~=")
		//	result = val1.execute() % val2.execute();
		else if(op.value == ">=")
			result = val1 >= val2;
		else if(op.value == "<=")
			result = val1 <= val2;
		else if(op.value == ">")
			result = val1 > val2;
		else if(op.value == "<")
			result = val1 < val2;
		else if(op.value == "and")
			result = val1 && val2;
		else if(op.value == "or")
			result = val1 || val2;
	}
	return result
}
std::string Node::binopString()
{
}
std::string Node::toString(Node &explist)
{
	std::stringstream ss;
	for(auto i=explist.children.begin(); i!=explist.children.end(); i++)
		ss << eval(*i) << "\t";
	return ss.str();
}
void Node::assignVar(Node &key, Node &value)
{
	//std::cout << "new var " << key.value << std::endl;
	globals.assign(key.value, std::to_string(value.execute()));
	//std::cout << globals.eval(key.value) << std::endl;
}
