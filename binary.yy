/* Existing syntax of Lua in EBNF
	chunk ::= {stat [';']} [laststat [';']]
	block ::= chunk
	stat ::= varlist '=' explist |
		functioncall |
		do block end |
		while exp do block end |
		repeat block until exp |
		if exp then block {elseif exp then block} [else block] end |
		for Name '=' exp ',' exp [',' exp] do block end |
		for namelist in explist do block end |
		function funcname funcbody |
		local function Name funcbody |
		local namelist ['=' explist]
	laststat ::= return [explist] |
		break
	funcname ::= Name {'.' Name} [':' Name]
	varlist ::= var {',' var}
	var ::= Name |
		prefixexp '[' exp ']' |
		prefixexp '.' Name
	namelist ::= Name {',' Name}
	explist ::= {exp ','} exp
	exp ::= nil |
		false |
		true |
		Number |
		String |
		'...' |
		function |
		prefixexp |
		tableconstructor |
		exp binop exp |
		unop exp
	prefixexp ::= var |
		functioncall |
		'(' exp ')'
	functioncall ::= prefixexp args |
		prefixexp ':' Name args
	args ::= '(' [explist] ')' |
		tableconstructor |
		String
	function ::= function funcbody
	funcbody ::= '(' [parlist] ')' block end
	parlist ::= namelist [',' '...'] |
		'...'
	tableconstructor ::= '{' [fieldlist] '}'
	fieldlist ::= field {fieldsep field} [fieldsep]
	field ::= '[' exp ']' '=' exp |
		Name '=' exp |
		exp
	fieldsep ::= ',' |
		';'
	binop ::= '+' |
		'-' |
		'*' |
		'/' |
		'^' |
		'%' |
		'..' |
		'<' |
		'<=' |
		'>' |
		'>=' |
		'==' |
		'~=' |
		and |
		or
	unop ::= '-' |
		not |
		'#'
*/
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
%type <Node> elseifexp
%type <Node> elseif
%type <Node> else
%%

block
	: chunk
	;

chunk
	: optchunk laststat
	| optchunk
	| laststat
	;

optchunk
	: stat optsemi
	| chunk stat optsemi
	;

laststat
	: RETURN explist optsemi
	| RETURN optsemi
	| BREAK optsemi
	;

optsemi
	: SEMI
	| /*empty*/
	;

stat
	: varlist ASSIGN explist
	| functioncall
	| DO block END
	| WHILE exp DO block END
	| REPEAT block UNTIL exp
	| IF exp THEN elseifexp else END
	| FOR name ASSIGN exp COMMA exp DO block END
	| FOR name ASSIGN exp COMMA exp COMMA exp DO block END
	| FOR namelist IN explist DO block END
	| FUNCTION funcname funcbody
	| LOCAL FUNCTION name funcbody
	| LOCAL namelist
	| LOCAL namelist ASSIGN explist
	;

ifexp
	: IF exp THEN block
	;

elseifexp
	: elseif
	| elseexp elseif
	| /*empty*/
	;

elseif
	: ELSEIF exp THEN block

else
	: ELSE block
	| /*empty*/
	;

funcnameexp
	: funcname
	| funcname COLON name

funcname
	: name
	| funcname DOT name
	;

varlist
	: var
	| varlist COMMA var
	;

var
	: name
	| prefixexp BRACK_L exp BRACK_R
	| prefixexp DOT name
	;

namelist
	: name
	| namelist COMMA name
	;

name
	: NAME
	;

explist
	: exp
	| explist COMMA exp
	;

exp
	: NIL
	| FALSE
	| TRUE
	| NUMBER
	| string
	| TDOT
	| function
	| prefixexp
	| tableconstructor
	| op
	;

prefixexp
	: var
	| functioncall
	| PARA_L exp PARA_R
	;

functioncall
	: prefixexp args
	| prefixexp COLON name args
	;

args
	: PARA_L PARA_R
	| PARA_L explist PARA_R
	| tableconstructor
	| string
	;

function
	: FUNCTION funcbody
	;

funcbody
	: PARA_L parlist PARA_R block END
	| PARA_L PARA_R block END
	;

parlist
	: namelist
	| namelist COMMA TDOT
	| TDOT
	;

tableconstructor
	: BRACE_L fieldlist BRACE_R
	| BRACE_L BRACE_R
	;

fieldlistexp
	: fieldlist optfieldsep
	;

fieldlist
	: field
	| fieldlist fieldsep field
	;

field
	: BRACK_L exp BRACK_R ASSIGN exp
	| name ASSIGN exp
	| exp
	;

fieldsep
	: COMMA
	| SEMI
	;

optfieldsep
	: fieldsep
	| /*empty*/

string
	: STRING
	;
