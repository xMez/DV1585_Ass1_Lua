#include "node.hh"
#include <iostream>
#include <fstream>
#include "binary.tab.hh"
extern Node root;
extern unsigned int total;

void yy::parser::error(std::string const&err)
{
	std::cout << "Error occured  " << total << std::endl;
}

int main(int argc, char **argv)
{
	yy::parser parser;
	if(!parser.parse())
		std::cout << "Parsed input" << std::endl;
	return 0;
}
