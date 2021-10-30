# need "using SymPy" for all this

# inputs are two integers a and b.  
# output is the polynomial b[(x-a)^2 - 1]
# Lucas suggests -3 <= a <= 3 and 1 <= b <= 10
function Make_poly_LR(a :: Int64 , b :: Int64)
    @vars x
    return expand( b*((x-a)^2 - 1) )
end



# will make the sum \sum_{n=c}^\infty g(x)^n as a string, given g and c
# Lucas suggests the range 1 <= c <= 10. 
function Make_the_a_n_LR( g :: Sym , c :: Int64)

    gstring = string(g)

    gstring = replace(gstring, "*" => "")

    return "\\( \\sum_{n = "*string(c)*"}^{\\infty} ("*gstring*")^n\\)"

end



# given the range of possible values for a,b,c constructs a question with random values from these ranges.
function Calc2_P1_LR( RangeOfa, RangeOfb, RangeOfc )

    a = rand(RangeOfa)
    b = rand(RangeOfb)
    c = rand(RangeOfc)

    g = Make_poly_LR(a,b)

    suman = Make_the_a_n_LR(g,c)

    # these apm are things like "a + \sqrt{1+1/b}", apm means "a Plus sqrt{1 Minus 1/b}", etc.  It's written in TeX but DOESN'T have the \( \) at start and end!
    
    p = 1 + 1//b 
    m = 1 - 1//b

    if b == 1
        app = string(a)*" +  \\sqrt{2}"
        apm = string(a)
        amp = string(a)*" -  \\sqrt{2}"
        amm = string(a)
    else
        app = string(a)*" +  \\sqrt{"*string(p)*"}"
        apm = string(a)*" +  \\sqrt{"*string(m)*"}"
        amp = string(a)*" -  \\sqrt{"*string(p)*"}"
        amm = string(a)*" -  \\sqrt{"*string(m)*"}"

        app = replace(app, "//" => "/") 
        apm = replace(apm, "//" => "/") 
        amp = replace(amp, "//" => "/") 
        amm = replace(amm, "//" => "/") 
    end

    Qtext = "Para quais valores de \\(x\\), a série "*suman*" converge?"
    

    Qanswers = [ ("\\( ("*amp*", "*amm*") \\cup ("*apm*", "*app*")\\)", true)  ,
    ("\\( ("*apm*", "*app*")\\)" , false) , 
    ("\\( ("*amp*", "*amm*")\\)" , false) , 
    ("\\( (-\\infty, "*app*")\\)" , false) , 
    ("\\( ("*apm*", \\infty)\\)" , false) , 
    ("\\( ("*amm*", "*string(a)*") \\cup ("*apm*", "*app*")\\)", false) , 
    ("\\( ("*amp*", "*amm*") \\cup ("*string(a)*", "*app*")\\)", false) , 
    ("\\( ("*amp*", "*string(a)*") \\cup ("*apm*", "*app*")\\)", false) , 
    ]
  
   Q = multiple_choice_question("Q LR", Qtext, Qanswers, single = true, wrongmarkzero = true)

   return Q
end