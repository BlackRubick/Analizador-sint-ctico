start
  = mainFunction / statement+

statement
  = function
  / assignment
  / print
  / forLoop
  / ifStatement

mainFunction
  = def:def _ main:main _ openParen:openParen _ closeParen:closeParen _ openBrace:openBrace _ statements:statement* _ closeBrace:closeBrace { return { type: 'mainFunction', def, main, openParen, closeParen, openBrace, statements: statements[0], closeBrace }; }

ifStatement
  = ifs:if  _ condition:condition _ openBrace:openBrace _ ifStatements:statement* _ closeBrace:closeBrace _ elseClause:(elses:else _ bracket:openBrace _ elseStatements:statement* _ bracketC:closeBrace {return {elses, bracket, elseStatements, bracketC}})? {
    return { type: 'ifStatement', ifs, condition, openBrace, ifStatements: ifStatements[0], closeBrace, elseClause: elseClause ? elseClause : null };
  }

condition
  = variable:variable _ operator:conditional _ value:value { return { variable, operator, value }; }

forLoop
  = forL:forL _ variable:variable _ ini:in _ openParen:openParen _ range:range _ closeParen:closeParen _ openBrace:openBrace _ statements:statement* _ closeBrace:closeBrace {
    return { type: 'forLoop', forL, variable, ini, openParen, range, closeParen, openBrace, statements: statements, closeBrace};
  }

range
  = start:number _ come:come _ end:number { return { start, come, end }; }

function
  = def:def _ name:variable _ openParen:openParen _ params:variable? _ closeParen:closeParen _ openBrace:openBrace _ statements:statement* _ closeBrace:closeBrace { return { type: 'function', def, name, openParen, params, closeParen, openBrace, statements: statements[0], closeBrace }; }

assignment
  = variable:variable _ arrow:arrow _ value:value { return { type: 'assignment', variable, arrow, value }; }

print
  = mostrarlo:mostrarlo _ openParen:openParen _ args:args _ closeParen:closeParen { 
    return { type: 'print', mostrarlo, openParen, value: args, closeParen }; 
  }

main
  = "main"

else
  = "tons"

if
  = "ira"

come
  = ","

in
  = "en"

forL
  = "vos"

def
  = "act"

mostrarlo
  ="mostralo"

variable
  = $[a-zA-Z][a-zA-Z0-9_]*

arrow
  = "->"

openParen
  = "("

closeParen
  = ")"

openBrace
  = "{"

closeBrace
  = "}"

_ "whitespace"
  = [ \t\n\r]*

value
  = number
  / string
  / variable

number
  = $[0-9]+

string
  = "\"" chars:$[^"]* "\"" { return chars; }

operator
  =$[+*/-]

conditional
  = ">=" / "<=" / "==" / "!=" / ">" / "<"

args
  = first:value _ rest:(op:operator _ val:value _ { return { operator: op, value: val }; })* { return [first].concat(rest); }