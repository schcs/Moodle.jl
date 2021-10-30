group1 = [ ("Se \\(a_n\\) converge então \\(|a_n|\\) sempre converge" , true) ,     # \ V
("Se \\(a_n\\) converge então \\(|a_n|\\) pode ou não convergir" , false),  # \ F
("Se \\(a_n\\) converge então \\(|a_n|\\) sempre diverge" , false),         # \ F  
("Se \\(a_n\\) converge então \\(|a_n|\\) pode divergir" , false),          # \ F 
("Se \\(|a_n|\\) converge então \\(a_n\\) sempre converge" , false),        # \ F
("Se \\(|a_n|\\) converge então \\(a_n\\) pode convergir" , true),         # \ V
("Se \\(|a_n|\\) converge então \\(a_n\\) sempre diverge" , false),         # \ F
("Se \\(|a_n|\\) converge então \\(a_n\\) pode divergir" , true) ]         # \ V

group2 = [("Se \\(a_n\\) e \\(a_n - b_n\\) convergem então \\(b_n\\) pode divergir" , false) ,  #  \ F
("Se \\(a_n + b_n\\) e \\(a_n - b_n\\) convergem então \\(a_n\\) sempre converge" , true) ,    #  \ V
( "Se \\(a_n + b_n\\) e \\(a_n - b_n\\) convergem então \\(b_n\\) pode divergir" , false) ,    #  \ F
( "Se \\(a_n - b_n\\) converge e \\(b_n\\) diverge então \\(a_n\\) sempre diverge" , true) ,   #  \ V
( "Se \\(a_n\\) e \\(a_n b_n\\) convergem então \\(b_n\\) sempre converge" , false) ,          #  \ F
( "Se \\(a_n\\) e \\(a_n b_n\\) convergem então \\(b_n\\) pode divergir" , true) ,             #  \ V
( "Se \\(a_n b_n\\) converge e \\(b_n\\) diverge então \\(a_n\\) pode convergir" , true) ,     #  \ V
( "Se \\(a_n b_n\\) converge e \\(b_n\\) diverge então \\(a_n\\) sempre diverge" , false)      #  \ F
]

group3 = [("Se cada \\(a_n\\neq 0\\) e \\(a_n\\) é crescente então \\(\\frac{1}{a_n}\\) sempre converge", false),       #  \ F
("Se cada \\(a_n\\neq 0\\) e \\(a_n\\) é crescente então \\(\\frac{1}{a_n}\\) pode ou não convergir", true),            # \ V
("Se cada \\(a_n\\neq 0\\) e \\(a_n\\) é crescente então \\(\\frac{1}{a_n}\\) sempre diverge", false),               #   \ F
("Se cada \\(a_n\\neq 0\\) e \\(a_n\\) é crescente então \\(\\frac{1}{a_n}\\) pode divergir", true),                 # \ V
("Se cada \\(a_n\\neq 0\\) e \\(\\frac{1}{a_n}\\) é crescente então \\(a_n\\) sempre converge", false),              #  \ F
("Se cada \\(a_n\\neq 0\\) e \\(\\frac{1}{a_n}\\) é crescente então \\(a_n\\) pode convergir", true),                #  \ V
("Se cada \\(a_n\\neq 0\\) e \\(\\frac{1}{a_n}\\) é crescente então \\(a_n\\) sempre diverge", false),               # \ F
("Se cada \\(a_n\\neq 0\\) e \\(\\frac{1}{a_n}\\) é crescente então \\(a_n\\) pode divergir", true)                  # \ V    
]

group4 = [( "Se \\(a_n \\rightarrow 0^+\\) e \\(b_n \\rightarrow 0\\) então sempre \\(a_n^{b_n} \\rightarrow 1\\)" , false) ,   #    \ F
( "Se \\(a_n \\rightarrow 0^+\\) e \\(b_n \\rightarrow 0\\) então \\(a_n^{b_n}\\) pode convergir a \\(\\pi\\)" , true),             #    \ V
( "Se \\(a_n \\rightarrow + \\infty\\) e \\(b_n \\rightarrow 0\\) então sempre \\(a_n^{b_n} \\rightarrow 1\\)" , false) ,        #     \ F
( "Se \\(a_n \\rightarrow + \\infty\\) e \\(b_n \\rightarrow 0\\) então \\(a_n^{b_n}\\) pode convergir a \\(+ \\infty\\)" , true) ,   #   \ V
( "Se \\(a_n \\rightarrow 1\\) e \\(b_n \\rightarrow + \\infty\\) então sempre \\(a_n^{b_n} \\rightarrow 1\\)" , false) ,         #    \ F
( "Se \\(a_n \\rightarrow 1\\) e \\(b_n \\rightarrow + \\infty\\) então \\(a_n^{b_n}\\) pode convergir a \\(\\sqrt[3]{2}\\)" , true) , #   \ V
( "Se \\(a_n \\rightarrow 0^+\\) e \\(b_n \\rightarrow + \\infty\\) então \\(a_n^{b_n}\\) pode convergir a \\(1\\)" , false) ,        #    \ F
( "Se \\(a_n \\rightarrow 0^+\\) e \\(b_n \\rightarrow + \\infty\\) então sempre \\(a_n^{b_n} \\rightarrow 0\\)" , true)          #  \ V
]


group5 = [( "Se \\(a_n \\geq 0\\) converge então \\(\\sqrt[n]{a_n}\\) sempre converge" , false)      # \ F
( "Se \\(a_n \\geq 0\\) converge então \\(\\sqrt[n]{a_n}\\) pode convergir" , true)                  # \ V
( "Se \\(a_n \\geq 0\\) converge então \\(\\sqrt[n]{a_n}\\) sempre diverge" , false)                 # \ F
( "Se \\(a_n \\geq 0\\) converge então \\(\\sqrt[n]{a_n}\\) pode divergir" , true)                   # \ V
( "Se \\(a_n^n\\) converge então \\(a_n\\) sempre converge" , false)                                 # \ F
( "Se \\(a_n^n\\) converge então \\(a_n\\) pode convergir" , true)                                   # \ V
( "Se \\(a_n^n\\) converge então \\(a_n\\) sempre diverge" , false)                                  # \ F
( "Se \\(a_n^n\\) converge então \\(a_n\\) pode divergir" , true)                                    # \ V
]

AllQs = [group1 , group2 , group3 , group4 , group5]
AllQstogether = [group1 ; group2 ; group3 ; group4 ; group5]



# Qlist is a list of lists.  With each element of the big list a list of statements.  For us this is [group1 , ... , group5]
# Groupings is something like [[1] , [2] , [4,5]], which will give a question with three statements, the first chosen from group1, the second
# from group2, and the third from either group4 or group5.
Choose_Statements_By_Groupings = function(Qlist :: Vector , Groupings :: Vector )
    n = length(Groupings)

    Options = [[] for x in 1:n]
    
    for i in 1:n 
        for j in 1:length(Groupings[i])
            Options[i] = [Options[i] ; Qlist[Groupings[i][j]]]
        end
    end

    return [ rand(Options[i]) for i in 1:n]
end



Calc2_P1_MM = function(Qlist :: Vector , Groupings :: Vector )

    Qtext = "Sejam \\(a_n\\) e \\(b_n\\) sequências numéricas.  Decida se cada afirmação abaixo é verdadeira ou falsa."

    Statements = Choose_Statements_By_Groupings(Qlist, Groupings)


    return VF_CLOZE_question( "MMQ", Qtext, Statements)

end