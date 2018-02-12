%skeleton "larl1.cc"
%defines
%define api.value.type variant
%define api.token.constructor
%code requires{
	#include "node.hh"
}
%code{
	unsigned int total = 0;
	#include <string>
	#define YY_DECL yy::parser::symbol_type yylex()
	YY_DECL;
	Node root;
}
%token <std::string> DO
%token <std::string> WHILE
%token <std::string> FOR
%token <std::string> UNTIL
%token <std::string> REPEAT
%token <std::string> END
%token <std::string> IN
%token <std::string> IF
%token <std::string> THEN
%token <std::string> ELSEIF
%token <std::string> ELSE
%token <std::string>

%token <std::string> PLUS
%token <std::string> MIN
%token <std::string> MUL
%token <std::string> DIV
%token <std::string> POW
%token <std::string> MOD
%token <std::string> EQUAL
%token <std::string> LESS_THAN
%token <std::string> MORE_THAN
%token <std::string> LESS_EQUAL_THAN
%token <std::string> MORE_EQUAL_THAN
%token <std::string> TILDE_EQUAL
%token <std::string> APPEND

%token <std::string> AND
%token <std::string> OR
%token <std::string> SQUARE
%token <std::string> NOT

%token <std::string> LOCAL

%token <std::string> FUNCTION
%token <std::string> RETURN
%token <std::string> BREAK

%token <std::string> NIL
%token <std::string> FALSE
%token <std::string> TRUE
%token <std::string> NUMBER
%token <std::string> STRING
%token <std::string> TDOT
%token <std::string> NAME

%token <std::string> ASSIGN
%token <std::string> DOT
%token <std::string> COLON
%token <std::string> COMMA
%token <std::string> SEMI
%token <std::string> PARA_L
%token <std::string> PARA_R
%token <std::string> BRACE_L
%token <std::string> BRACE_R
%token <std::string> BRACK_L
%token <std::string> BRACK_R

%token QUIT 0 "end of file"

%type <Node> block
%type <Node> chunk
%type <Node> optchunk
%type <Node> laststat
%type <Node> optsemi
%type <Node> stat
%type <Node> ifexp
%type <Node> optelseif
%type <Node> elseif
%type <Node> else
%type <Node> funcnamelist
%type <Node> funcname
%type <Node> varlist
%type <Node> var
%type <Node> namelist
%type <Node> name
%type <Node> explist
%type <Node> exp
%type <Node> prefixexp
%type <Node> functioncall
%type <Node> args
%type <Node> function
%type <Node> funcbody
%type <Node> parlist
%type <Node> tableconstructor
%type <Node> fieldlistexp
%type <Node> fieldlist
%type <Node> field
%type <Node> fieldsep
%type <Node> optfieldsep
%type <Node> string
%type <Node> ops
%type <Node> ops_1
%type <Node> ops_2
%type <Node> ops_3
%type <Node> ops_4
%type <Node> ops_5
%type <Node> ops_6
%type <Node> ops_7
%type <Node> ops_8
%type <Node> ops_9
%%

block
	: chunk			{ $$ = Node("block", "");
				  $$.children.push_back($1):
				  root = $$;
				}
	;

chunk
	: optchunk laststat	{ $$ = $1:
				  $$.children.push_back($2);
				}
	| optchunk		{ $$ = $1; }
	| laststat		{ $$ = Node("chunk", "");
				  $$.children.push_back($1);
				}
	;

optchunk
	: stat optsemi		{ $$ = Node("chunk", "");
				  $$.children.push_back($1);
				}
	| chunk stat optsemi	{ $$ = $1;
				  $$.children.push_back($2);
				}
	;

laststat
	: RETURN explist optsemi
				{ $$ = Node("laststat", "");
				  $$.children.push_back($2);
				}
	| RETURN optsemi	{ $$ = Node("laststat", "empty"); }
	| BREAK optsemi		{ $$ = Node("laststat", "empty"); }
	;

optsemi
	: SEMI
	| /*empty*/
	;

stat
	: varlist ASSIGN explist
				{ $$ = Node("stat", "");
				  $$.children.push_back($1);
				  $$.children.push_back($3);
				}
	| functioncall		{ $$ = $1 }
	| DO block END		{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				}
	| WHILE exp DO block END
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				}
	| REPEAT block UNTIL exp
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				}	
	| IF exp THEN optelseif optelse END
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				  $$.children.push_back($5);
				}
	| FOR name ASSIGN exp COMMA exp DO block END
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				  $$.children.push_back($6);
				  $$.children.push_back($8);
				}
	| FOR name ASSIGN exp COMMA exp COMMA exp DO block END
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				  $$.children.push_back($6);
				  $$.children.push_back($8);
				  $$.children.push_back($10);
				}
	| FOR namelist IN explist DO block END
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				  $$.children.push_back($6);
				}
	| FUNCTION funcnamelist funcbody
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($3);
				}
	| LOCAL FUNCTION name funcbody
				{ $$ = Node("stat", "");
				  $$.children.push_back($3);
				  $$.children.push_back($4);
				}
	| LOCAL namelist	{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				}
	| LOCAL namelist ASSIGN explist
				{ $$ = Node("stat", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				}
	;

ifexp
	: IF exp THEN block	{ $$ = Node("ifexp", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				}
	;

optelseif
	: elseif		{ $$ = Node("optelseif", "");
				  $$.children.push_back($1);
				}
	| optelseif elseif	{ $$ = $1;
				  $$.children.push_back($2);
				}
	| /*empty*/		{ $$ = Node("optelseif", "empty"); }
	;

elseif
	: ELSEIF exp THEN block	{ $$ = Node("elseif", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				}

optelse
	: ELSE block		{ $$ = Node("optelse", "");
				  $$.children.push_back($2);
				}
	| /*empty*/		{ $$ = Node("optelse", "empty"); }
	;

funcnamelist
	: funcname		{ $$ = $1; }
	| funcname COLON name	{ $$ = $1;
				  $$.children.push_back($3);
				}

funcname
	: name			{ $$ = Node("funcname", "");
				  $$.children.push_back($2);
				}
	| funcname DOT name	{ $$ = $1;
				  $$.children.push_back($3);
				}
	;

varlist
	: var			{ $$ = Node("varlist", "");
				  $$.children.push_back($3);
				}
	| varlist COMMA var	{ $$ = $1;
				  $$.children.push_back($3);
				}
	;

var
	: name			{ $$ = Node("var", "");
				  $$.children.push_back($1);
				}
	| prefixexp BRACK_L exp BRACK_R
				{ $$ = Node("var", "bracket");
				  $$.children.push_back($1);
				  $$.children.push_back($3);
				}
	| prefixexp DOT name	{ $$ = $1;
				  $$.children.push_back($3);
				}
	;

namelist
	: name			{ $$ = Node("namelist", "");
				  $$.children.push_back($1);
				}
	| namelist COMMA name	{ $$ = $1;
				  $$.children.push_back($3);
				}
	;

name
	: NAME			{ $$ = Node("NAME", $1); }
	;

explist
	: exp			{ $$ = Node("explist", "");
				  $$.children.push_back($1);
				}
	| explist COMMA exp	{ $$ = $1;
				  $$.children.push_back($3);
				}
	;

exp
	: NIL			{ $$ = Node("NIL", $1); }
	| FALSE			{ $$ = Node("FALSE", $1); }
	| TRUE			{ $$ = Node("TRUE", $1); }
	| NUMBER		{ $$ = Node("NUMBER", $1); }
	| string		{ $$ = $1; }
	| TDOT			{ $$ = Node("TDOT", $1); }
	| function		{ $$ = Node("exp", "");
				  $$.children.push_back($1);
				}
	| prefixexp		{ $$ = $1; }
	| tableconstructor	{ $$ = Node("exp", "");
				  $$.children.push_back($1);
				}
	| op			{ $$ = $1; }
	;

prefixexp
	: var			{ $$ = $1; }
	| functioncall		{ $$ = $1; }
	| PARA_L exp PARA_R	{ $$ = $2; }
	;

functioncall
	: prefixexp args	{ $$ = Node("functioncall", "");
				  $$.children.push_back($1);
				  $$.children.push_back($2);
				}
	| prefixexp COLON name args
				{ $$ = Node("functioncall", "");
				  $$.children.push_back($1);
				  $$.children.push_back($3);
				  $$.children.push_back($4);
				}
	;

args
	: PARA_L PARA_R		{ $$ = Node("args", "empty"); }
	| PARA_L explist PARA_R	{ $$ = $2; }
	| tableconstructor	{ $$ = $1; }
	| string		{ $$ = $1; }
	;

function
	: FUNCTION funcbody	{ $$ = Node("function", "");
				  $$.children.push_back($2);
				}
	;

funcbody
	: PARA_L parlist PARA_R block END
				{ $$ = Node("funcbody", "");
				  $$.children.push_back($2);
				  $$.children.push_back($4);
				}
	| PARA_L PARA_R block END
				{ $$ = Node("funcbody", "");
				  $$.children.push_back(Node("parlist", "empty"));
				  $$.children.push_back($3);
				}
	;

parlist
	: namelist		{ $$ = Node("parlist", "");
				  $$.children.push_back($1);
				}
	| namelist COMMA TDOT	{ $$ = $1;
				  $$.children.push_back(Node("argover", ""));
				}
	| TDOT			{ $$ = Node("parlist", "tdot"); }
	;

tableconstructor
	: BRACE_L fieldlist BRACE_R
				{ $$ = Node("tableconstructor", ""); 
				  $$.children.push_back($2);
				}
	| BRACE_L BRACE_R	{ $$ = Node("tableconstructor", "empty"); }
	;

fieldlistexp
	: fieldlist optfieldsep	{ $$ = $1;
				  $$.children.push_back($2);
				}
	;

fieldlist
	: field			{ $$ = Node("fieldlist", "");
				  $$.children.push_back($1);
				}
	| fieldlist fieldsep field
				{ $$ = $1;
				  $$.children.push_back($2);
				  $$.children.push_back($3);
				}
	;

field
	: BRACK_L exp BRACK_R ASSIGN exp
				{ $$ = Node("field", "backet");
				  $$.children.push_back($2);
				  $$.children.push_back($5);
				}
	| name ASSIGN exp
				{ $$ = Node("field", "assign");
				  $$.children.push_back($1);
				  $$.children.push_back($3);
				}
	| exp
				{ $$ = Node("field", "exp");
				  $$.children.push_back($1);
				}
	;

fieldsep
	: COMMA			{ $$ = Node("fieldsep", $1); }
	| SEMI			{ $$ = Node("fieldsep", $1); }
	;

optfieldsep
	: fieldsep		{ $$ = $1; }
	| /*empty*/

string
	: STRING		{ $$ = Node("string", $1); }
	;

/* Operator precedence in reverse since LARL */
ops
	: ops_1			{ $$ = $1; }
	;

ops_1
	: ops_1 OR ops_2	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_2			{ $$ = $1; }

	;

ops_2
	: ops_2 AND ops_3	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_3			{ $$ = $1; }

	;

ops_3
	: ops_3 LESS_THAN ops_4	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_3 MORE_THAN ops_4	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_3 LESS_EQUAL_THAN ops_4
				{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_3 MORE_EQUAL_THAN ops_4
				{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_3 TILDE_EQUAL_THAN ops_4
				{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_3 EQUAL ops_4	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_4			{ $$ = $1; }

	;

ops_4
	: ops_4 CONCAT ops_5	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_5			{ $$ = $1; }

	;

ops_5
	: ops_5 PLUS ops_6	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_5 MIN ops_6	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_6			{ $$ = $1; }

	;

ops_6
	: ops_6 MUL ops_7	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_6 DIV ops_7	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_6 MOD ops_7	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_7			{ $$ = $1; }

	;

ops_7
	: NOT ops_8		{ $$ = Node("op", "unop");
				  $$.children.push_back(Node("binop", $1));
				  $$.children.push_back($2);
				}
	| LEN ops_8		{ $$ = Node("op", "unop");
				  $$.children.push_back(Node("binop", $1));
				  $$.children.push_back($2);
				}
	| MIN ops_8		{ $$ = Node("op", "unop");
				  $$.children.push_back(Node("binop", $1));
				  $$.children.push_back($2);
				}
	| ops_8			{ $$ = $1; }

	;

ops_8
	: ops_8 POW ops_9	{ $$ = Node("op", "binop");
				  $$.children.push_back($1);
				  $$.children.push_back(Node("binop", $2));
				  $$.children.push_back($3);
				}
	| ops_9			{ $$ = $1; }

	;

ops_9
	: exp			{ $$ = $1; }

	;
