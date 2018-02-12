%top{
#include "binary.tab.hh"
#define YY_DECL yy::parser::symbol_type yylex()
}
%option noyywrap nounput batch noinput
%%
--\[\[([^\]])*\]\]--	{}
--[^\n]*		{}

do			{ return yy::parser::make_DO(yytext); }
while			{ return yy::parser::make_WHILE(yytext); }
for			{ return yy::parser::make_FOR(yytext); }
until			{ return yy::parser::make_UNTIL(yytext); }
repeat			{ return yy::parser::make_REPEAT(yytext); }
end			{ return yy::parser::make_END(yytext); }
in			{ return yy::parser::make_IN(yytext); }
if			{ return yy::parser::make_IF(yytext); }
then			{ return yy::parser::make_THEN(yytext); }
elseif			{ return yy::parser::make_ELSEIF(yytext); }
else			{ return yy::parser::make_ELSE(yytext); }

[+]			{ return yy::parser::make_PLUS(yytext); }
[-]			{ return yy::parser::make_MIN(yytext); }
[*]			{ return yy::parser::make_MUL(yytext); }
[/]			{ return yy::parser::make_DIV(yytext); }
[\^]			{ return yy::parser::make_POW(yytext); }
[%]			{ return yy::parser::make_MOD(yytext); }
[=][=]			{ return yy::parser::make_EQUAL(yytext); }
[<]			{ return yy::parser::make_LESS_THAN(yytext); }
[<][=]			{ return yy::parser::make_LESS_EQUAL_THAN(yytext); }
[>]			{ return yy::parser::make_MORE_THAN(yytext); }
[>][=]			{ return yy::parser::make_MORE_EQUAL_THAN(yytext); }
[~][=]			{ return yy::parser::make_TILDE_EQUAL(yytext); }
[.][.]			{ return yy::parser::make_CONCAT(yytext); }

and			{ return yy::parser::make_AND(yytext); }
or			{ return yy::parser::make_OR(yytext); }
[#]			{ return yy::parser::make_LEN(yytext); }
not			{ return yy::parser::make_NOT(yytext); }

local			{ return yy::parser::make_LOCAL(yytext); }

function		{ return yy::parser::make_FUNCTION(yytext); }
return			{ return yy::parser::make_RETURN(yytext); }
break			{ return yy::parser::make_BREAK(yytext); }

nil			{ return yy::parser::make_NIL(yytext); }
false			{ return yy::parser::make_FALSE(yytext); }
true			{ return yy::parser::make_TRUE(yytext); }
[0-9]+			{ return yy::parser::make_NUMBER(yytext); }
\"[^\"]*\"		{ return yy::parser::make_STRING(yytext); }
\.\.\.			{ return yy::parser::make_TDOT(yytext); }
[a-zA-Z_][a-zA-Z0-9_]*	{ return yy::parser::make_NAME(yytext); }

=			{ return yy::parser::make_ASSIGN(yytext); }
\.			{ return yy::parser::make_DOT(yytext); }
:			{ return yy::parser::make_COLON(yytext); }
,			{ return yy::parser::make_COMMA(yytext); }
;			{ return yy::parser::make_SEMI(yytext); }

\(			{ return yy::parser::make_PARA_L(yytext); }
\)			{ return yy::parser::make_PARA_R(yytext); }
\{			{ return yy::parser::make_BRACE_L(yytext); }
\}			{ return yy::parser::make_BRACE_R(yytext); }
[\[]			{ return yy::parser::make_BRACK_L(yytext); }
[\]]			{ return yy::parser::make_BRACK_R(yytext); }

[ \t]			{  }
[\n]			{  }
<<EOF>>			{ return yy::parser::make_QUIT(); }
%%
