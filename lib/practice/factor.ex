defmodule Practice.Factor do
  
  def factor(x) do
     factorHelp(x, 2, [])
  end


  def factorHelp(n, f, factors) do 
    if n > 1 do 
      if rem(trunc(n), f) == 0 do 
        factorHelp(n / f, f, [f | factors])
      else 
        factorHelp(n, f + 1, factors)
      end
    else 
      factors |> Enum.reverse()
    end
  end 
end
