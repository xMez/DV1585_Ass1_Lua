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
	void dump(int depth=0);
	std::ostringstream toStream(int &depth, int parent=0);
	float execute();
	std::string evalString(Node &explist);
	void assignVar(Node &key, Node &value);
};
#endif
