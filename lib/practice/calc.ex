defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    arr = String.split(expr)
    tokens = tagTokens(arr)
    postfix = algorithm(tokens, [], [])
    calcAns = readExpr(postfix, [])
    calcAns
  end

  def tagTokens(arr) do 
    Enum.map(arr, fn x -> 
    case x do 
      "*" -> {:op, "*"}
      "/" -> {:op, "/"}
      "+" -> {:op, "+"}
      "-" -> {:op, "-"}
      _ -> {:num, parse_float(x)}
    end
    end)
  end

  def algorithm(tokens, outstack, opstack) do 
      if length(tokens) > 0 do
        element = hd tokens
        case element do 
           {:num, x} -> outstack ++ [x] 
           {:op, x} ->
             if length(opstack) == 0 do
                opstack ++ [x]
             else
               top = hd opstack 
               rank = checkrank(x) - checkrank(top)
               case rank do
                1 -> opstack = [x] ++ opstack
                0 -> outstack ++ [top]
                     opstack = tl opstack
                     opstack ++ [x]
 	        -1 -> opstack ++ [top]
   		      opstack = tl opstack
                      algorithm(tokens, outstack, opstack)
                _-> nil
                end
             end
            _ -> nil
      end
      tail = tl tokens
      algorithm(tail, outstack, opstack) 
   else
      outstack ++ opstack
      outstack 
   end
end 

def checkrank(x) do 
  rank = 0 
  if x == "+" or x == "-" do 
    rank = 1
  else 
   rank = 2
 end 
  rank 
end


def readExpr(postfix, stack) do 
  head = hd postfix
  if head == "+" or head == "-" or head == "/" or head == "*" do 
    num1 = hd stack
    stack = tl stack 
    num2 = hd stack 
    stack = tl stack 
    case head do 
      "+" -> calculation = num1 + num2
             stack = [calculation] ++ stack
      "-" -> calculation = num1 - num2
             stack = [calculation] ++ stack
      "/" -> calculation = num1 / num2
             stack = [calculation] ++ stack
      "*" -> calculation = num1 * num2
             stack = [calculation] ++ stack
       _ -> nil
   end
 else
    stack = [head] ++ stack
  end
  if length(postfix) > 0 do
     tailPost = tl postfix 
     readExpr(tailPost, stack)
  else 
    ans = hd stack
    ans 
   end
  end
end
