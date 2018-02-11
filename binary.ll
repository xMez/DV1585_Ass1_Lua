%top{
#include "binary.tab.hh"
#define YY_DECL yy::parser::symbol_type yylex()
}
%option noyywrap nounput batch noinput
%%
/* Comments */
--\[\[([^\]])*\]\]--
--[^\n]*

/* Keywords */
do
while
for
until
repeat
end
in
if
then
elseif
else

/* Binary operators */
[+]
[-]
[*]
[/]
[\^]
[%]
[=][=]
[<]
[<][=]
[>]
[>][=]
[~][=]
[.][.]

/* Unary operators */
and
or
[#]
not

local

/* Function */
function
return
break

/* Values */
nil
false
true
[0-9]+
\"[^\"]*\"
\.\.\.
[a-zA-Z_][a-zA-Z0-9_]*

/* Single tokens */
=
\.
:
,
;

/* Blocks */
\(
\)
\{
\}
[\[]
[\]]

/* Spacing */
[ \t]
[\n]
<<EOF>>
%%
