# need "using SymPy" for all this

# inputs are a1 < a2 integers and sign which is 1 or -1.
# Makes the quadradic polynomial g(b) = (-1)^sign . (b - a1) . (b-a2) + 1
# if sign = 1, then g(b) > 1 iff b < a1 or b > a2
# if sign = -1, then g(b) > 1 iff b is in (a1 , a2)
function Make_poly_JWM(a1 :: Int64, a2 :: Int64, sign :: Int64)
    @vars b
    return expand((sign * (b-a1) * (b-a2)) + 1)
end



# will make the general term a_n = c / (n.ln(dn)^g(b)) in XML from a given polynomial g(b), and integers c,d
function Make_the_a_n_JWM( g :: Sym , c :: Int64 , d :: Int64)

    gstring = string(g)

    gstring = replace(gstring, "*" => "")

    dstring = string(d)

    dstring = replace(dstring, "1" => "")

    return "\\frac{"*string(c)*"}{n\\cdot \\textnormal{ln}("*dstring*"n)^{"*gstring*"}}"

end



# given the range of possible solutions a1, a2 of g(b) = 1 and the range of allowable values for b,c,
# constructs a question with random values from these ranges and a random choice of sign for the leading term of g.
# Negative values in RangeOfcandd are removed before choosing c and d.
# Two other random values are chosen: m and n, which will give four wrong answers.
function Calc2_P1_JWM( RangeOfPolySols, RangeOfcandd )
    local an :: String 
    local a1,a2,c,d,m,n,sign :: Int64

    a1,a2,m,n = sample(RangeOfPolySols, 4, replace = false)

    if a1 > a2 a1,a2 = a2,a1 
    end

    if m > n m,n = n,m 
    end

    sign = rand([-1,1])

    RangeOfcandd = [x for x in RangeOfcandd if x > 0]

    c,d = sample(RangeOfcandd, 2, replace = false)

    g = Make_poly_JWM(a1,a2,sign)

    an = Make_the_a_n_JWM(g,c,d)

    Qtext = "Seja \$\$ a_n ="*an*"\$\$.\n Qual dos seguintes é o conjunto dos valores de \\(b\\) para quais a série \\(\\sum_{n=2}^{\\infty}a_n\\) é convergente?"

    if sign == -1 IsIn = true
    else IsIn = false
    end

    Qanswers = [ ("\\( ("*string(a1)*", "*string(a2)*") \\)" , IsIn) , ("\\( (-\\infty, "*string(a1)*")\\cup ("*string(a2)*", \\infty) \\)" , !IsIn)
    , ("\\( ["*string(a1)*", "*string(a2)*"] \\)" , false) , ("\\( (-\\infty, "*string(a1)*"]\\cup ["*string(a2)*", \\infty) \\)" , false) 
    , ("\\( ("*string(m)*", "*string(n)*") \\)" , false) , ("\\( (-\\infty, "*string(m)*")\\cup ("*string(n)*", \\infty) \\)" , false)
    , ("\\( ["*string(m)*", "*string(n)*"] \\)" , false) , ("\\( (-\\infty, "*string(m)*"]\\cup ["*string(n)*", \\infty) \\)" , false) ]

   Q = multiple_choice_question("Q JWM", Qtext, Qanswers, single = true, wrongmarkzero = true)

   return Q
end