# structural infix parser

def isDigit?(c)
  /[0-9]/ =~ c
end

def getNumber(stream)
  number = c = stream.next
  while isDigit?(stream.peek) do
    c = stream.next
    number += c
  end
  return number.to_i
end

def execOp(op, a, b, o)
  case op
  when '+'
    a + b
  when '-'
    a - b
  when '*'
    a * b
  when '/'
    if a != 0 and b != 0 or o != true
      a.to_f / b.to_f
    else
      0
    end
  when '^'
    a ** b
  end
end

def sinfix(expression, opinionated=true)
  return 0   if /^[0-9]+([\s]*[+\-*^\/]+[\s]*[0-9]+)*$/ !~ expression
  expression += "\u0000"
  expression = expression.each_char.to_a.filter {|x| !(/[\s]/=~ x) }.join
  e          = expression.each_char
  value      = getNumber(e)
  loop {
    break if e.peek == "\u0000"
    # consume transformations
    operator  = e.next
    theNumber = getNumber(e)
    value = execOp(operator, value, theNumber, opinionated)
  }
  return value
end

p sinfix '15'                 # => 15
p sinfix '3 * 4 + 2'          # => 14
p sinfix '2 + 3 * 4'          # => 20
p sinfix '3 * 4 + 2 ^ 5 * 10' # => 5378240
p sinfix '3 * 4 + 2 * 10 + 2' # => 142
p sinfix '4 / 0'              # => 0
p sinfix '4 / 0',             # => Infinity
  opinionated=false

