parser: lex.yy.c binary.tab.o main.cc node.cc
	g++ -std=c++11 -g -oint binary.tab.o lex.yy.c main.cc node.cc
binary.tab.o: binary.tab.cc
	g++ -std=c++11 -g -c binary.tab.cc
binary.tab.cc: binary.yy
	bison -v --report-file=report.txt binary.yy
lex.yy.c: binary.ll binary.tab.cc
	flex binary.ll
clean:
	rm -f binary.tab.* ley.yy.c* int
submission:
	rm -r ass1-int
	mkdir ass1-int
	cp -t ass1-int/ binary.ll binary.yy enviroment.hh main.cc makefile node.cc node.hh
	tar -zcvf /home/$$USER/submission.tgz ass1-int
	rm -r ass1-int
