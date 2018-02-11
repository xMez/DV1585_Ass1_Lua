#ifndef NODE_HH
#define NODE_HH
#include <iostream>
#include <string>
#include <list>
class Node {
public:
	std::string tag, value;
	std::list<Node> children;
	Node(std::string t, std:string v) : tag(t), value(v) {}
	Node() { tag="uninitilized"; value="uninitialized"; }
};
#endif
