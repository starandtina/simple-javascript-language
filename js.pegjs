Program = stmts:Statement* {  
    return ast.program(stmts);
}

Statement  
    = CallStmt
    / AssignStmt

Expression  
    = FunctionExpr
    / AssignExpr
    / CallExpr
    / ListExpr
    / Symbol
    / String
    / Number
    / Boolean
    / Nil

Callable  
    = FunctionExpr
    / Symbol

AssignStmt = expr:AssignExpr {  
    return ast.expressionStatement(expr);
}

CallStmt = expr:CallExpr {  
    return ast.expressionStatement(expr);
}


AssignExpr = lparen l:Symbol r:Expression rparen {  
    return ast.assignmentExpression('=', l, r);
}

CallExpr = lparen l:Callable colon arg:Expression? rparen {  
    return (arg == "")
        ? ast.callExpression(l, [])
        : ast.callExpression(l, [arg]);
}

FunctionExpr = lbrace stmts:Statement* rbrace {  
    var arg = ast.identifier("$");
    stmts.push(ast.returnStatement(arg));
    var block = ast.blockStatement(stmts);
    return ast.functionExpression(null, [arg], block);
}


ListExpr = lsqbct items:Expression* rsqbct {  
    return ast.arrayExpression(items);
}

Symbol  
    = Identifier
    / Cash

Identifier = chars:[A-Za-z]+ ws {  
    return ast.identifier(chars.join(''));
}

Cash = '$' ws {  
    return ast.identifier('$');
}

String = '"' chars:[^"]* '"' {  
    return ast.literal(chars.join(''));
}

Nil = "nil" ws {  
    return ast.literal(null);
}

Boolean  
    = Yes
    / No

Yes = "yes" ws {  
    return ast.literal(true);
}

No = "no" ws {  
    return ast.literal(false);
}

Number  
    = Float
    / Integer

Float = a:digit+ '.' b:digit+  ws {  
    var num = parseFloat(a.join('') + '.' + b.join(''));
    return ast.literal(num);
}

Integer = digits:digit+ ws {  
    var num = parseInt(digits.join(''));
    return ast.literal(num);
}


 digit = [0-9]
lparen = '(' ws  
rparen = ')' ws  
lbrace = '{' ws  
rbrace = '}' ws  
lsqbct = '[' ws  
rsqbct = ']' ws  
 colon = ':' ws

ws = wschar*  
wschar = [ \r\n\t]  