#include "node.hh"
#include <iostream>
#include <fstream>
#include "binary.tab.hh"
extern FILE *yyin;
extern Node root;
extern unsigned int total;

void yy::parser::error(std::string const&err)
{
	std::cout << "Error occured  " << total << std::endl;
}

void makeFile()
{
	std::ofstream ofs("parse.txt", std::ofstream::out);

	ofs << "digraph {\n";
	int depth = 0;
	ofs << root.toStream(depth).str();
	ofs << "}";

	ofs.close();
}

int main(int argc, char **argv)
{
	if(argc > 1)
		yyin = fopen(argv[1], "r");
	yy::parser parser;
	if(!parser.parse())
	{
		root.dump();
		//makeFile();
		root.execute();
	}
	fclose(yyin);
	return 0;
}
