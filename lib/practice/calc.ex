defmodule Practice.Calc do

    def eval(expr) do
        expr
        |>String.split(~r/()[\+|)|\(|\-|\*|\/|^|!|]()/,
                trim: true, include_captures: true)
        |> Enum.map(fn(x) -> String.trim(x) end)
        |> Enum.map(fn(x) -> if Integer.parse(x) == :error
				 do x
                             else 
				 Integer.parse(x)
                                 |> elem(0) end end)
        |> convertToPostfix([], [], -1)
        |> calculate([], -1, nil)
 
    end
 
    def pop(stack, top, popped) do
        if not isEmpty(top) do
            top = top - 1
            popped = List.last(stack)
            stack = Enum.drop(stack, -1)
            {stack,top,popped}
        else
            {stack,top,nil}
        end
    end
 
    def push(expr, stack, top) do
        top = top + 1
        stack = List.insert_at(stack, -1, expr)
        {stack,top}
    end
 
    def isEmpty(top) do
        if top == -1 do
            true
        else
            false
        end
    end
 
    def notGreater(expr, stack) do
        if (expr == "*" or expr == "/") and (peek(stack) == "+" or peek(stack) == "-") do
            false
        else
            true
        end
    end
 
    def peek(stack) do
        List.last(stack)
    end
 
    def encounteredOperator(expr, out, stack, top, popped) do
        if not isEmpty(top) and notGreater(expr, stack) do
            {stack,top,popped} = pop(stack, top, popped)
            out = List.insert_at(out, -1, popped)
            encounteredOperator(expr, out, stack, top, nil)
        else
            {out, stack, top}
        end
    end
 
    def popStack(out, stack, top, popped) do
        if not isEmpty(top) do
            {stack,top,popped} = pop(stack, top, popped)
            out = List.insert_at(out, -1, popped)
            popStack(out, stack, top, nil)
        else
            out
        end
    end
 
    def calculate(out, stack, top, popped) do
        {curr,rest} = List.pop_at(out, 0)
        if curr != nil do
            cond do
                curr == "+" -> {stack,top,popped} = pop(stack, top, nil)
                                var1 = popped
                                {stack,top,popped} = pop(stack, top, nil)
                                var2 = popped
                                {stack, top} = push(var2+var1, stack, top)
                                calculate(rest, stack, top, nil)
                curr == "-" -> {stack,top,popped} = pop(stack, top, nil)
                                var1 = popped
                                {stack,top,popped} = pop(stack, top, nil)
                                var2 = popped
                                {stack, top} = push(var2-var1, stack, top)
                                calculate(rest, stack, top, nil)
                curr == "*" -> {stack,top,popped} = pop(stack, top, nil)
                                var1 = popped
                                {stack,top,popped} = pop(stack, top, nil)
                                var2 = popped
                                {stack, top} = push(var2*var1, stack, top)
                                calculate(rest, stack, top, nil)
                curr == "/" -> {stack,top,popped} = pop(stack, top, nil)
                                var1 = popped
                                {stack,top,popped} = pop(stack, top, nil)
                                var2 = popped
                                {stack, top} = push(var2/var1, stack, top)
                                calculate(rest, stack, top, nil)
                true -> {stack, top} = push(curr, stack, top)
                        calculate(rest, stack, top, nil)
            end
        else
            {stack,top,popped} = pop(stack, top, nil)
            popped
        end
    end
 
    def convertToPostfix(expr, out, stack, top) do
        {curr,rest} = List.pop_at(expr, 0)
            if curr != nil do
                cond do
                    curr == "+" or curr == "-" or curr == "*" or curr == "/" ->
                                {out, stack, top} = encounteredOperator(curr, out, stack, top, nil)
                                {stack, top} = push(curr, stack, top)
                                convertToPostfix(rest, out, stack, top)
                    true -> out = List.insert_at(out, -1, curr)
                            convertToPostfix(rest, out, stack, top)
                end
            else
                popStack(out, stack, top, nil)
            end
    end
end
