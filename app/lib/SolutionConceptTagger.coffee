concepts = require 'schemas/concepts'

module.exports = TagSolution = ({source, ast, language}) ->
  engine = new esper.Engine()
  if source
    engine.load(source)
  else if ast
    engine.loadAST(ast)
  ast = engine.evaluator.ast
  if language is 'python'
    ast.body.shift() # remove the first variable assignment
  result = []
  for key of concepts
    tkn = concepts[key].tagger
    continue unless tkn
    if typeof tkn is 'function'
      result.push concepts[key].concept if tkn(ast)
    else
      result.push concepts[key].concept if ast.find(tkn).length > 0
  result
