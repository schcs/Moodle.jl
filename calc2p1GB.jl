# need "using SymPy" for all this


 
# for the time being let's take p and q to be integers (p has to be positive)!  This makes the a_n term WITHOUT putting it in
# tex mode
function Make_the_a_n_GB( p , q )

    if q < 0
        num = "x^2 - "*string(-q)
    elseif q > 0
        num = "x^2 + "*string(q)
    else 
        num = "x^2"
    end

    denom = string(p^2 + q)
    
 #  if typeof(p) == Int
 #       denom = string(p^2 + q)
 ##   elseif q < 0
  #      denom = string(p)*"^2 - "*string(-q)
  ##  else  
   #     denom = string(p)*"^2 + "*string(q)
  #  end 
    
  #\sum_{n = 1}^{+\infty}\,\,\, n^{-\left[\frac{x^2 + q}{p^2 + q}\right]}


    return " \\sum_{n = 1}^{+\\infty}\\,\\,\\, n^{-\\left(\\frac{"*num*"}{"*denom*"}\\right)}"
    
   # "\\( \\sum_{n = 1}^{+\\infty}\\,\\,\\, \\frac{1}{n^{\\left[\\frac{"*num*"}{"*denom*"}\\right]}}\\)"

end



# given the range of possible values for a,b,c constructs a question with random values from these ranges.
function Calc2_P1_GB( RangeOfp, RangeOfq )
    local A

    q = rand(RangeOfq)

  #  p = 0
   # A = 0
    p = q^2
    
    while p == q^2
        p,A = sample(RangeOfp, 2, replace = false)
    end
    

    suman = Make_the_a_n_GB(p,q)



    Qtext = "A alternativa que representa o conjunto dos valores de \\(x\\) para os quais a série \\["*suman*"\\] converge, é:"

    Qanswers = [ ("\\( (-\\infty, -"*string(p)*") \\cup ("*string(p)*", \\infty)\\)", true)  ,
    ("\\( ("*string(p)*", \\infty)\\)" , 50) , 
    ("\\( (-"*string(p)*", "*string(p)*")\\)" , false) , 
    ("\\( ["*string(p)*", \\infty)\\)" , false) , 
    ("\\( (-\\infty, -"*string(p)*"] \\cup ["*string(p)*", \\infty)\\)", false)  ,
    ("\\( (-\\infty, -"*string(A)*") \\cup ("*string(A)*", \\infty)\\)", false)  ,
    ("\\( ("*string(A)*", \\infty)\\)" , false) , 
    ("\\( (-"*string(A)*", "*string(A)*")\\)" , false) , 
    ("\\( ["*string(A)*", \\infty)\\)" , false) , 
    ("\\( (-\\infty, -"*string(A)*"] \\cup ["*string(A)*", \\infty)\\)", false)
    ]
  
   Q = multiple_choice_question("Q GB", Qtext, Qanswers, single = true, wrongmarkzero = true)

   return Q
end