# using LinearAlgebra


# IntZeroMat(m,n) gives an mxn integer 0 matrix
function IntZeroMat(m :: Int64, n :: Int64)
    return Int64[0 for j in 1:m, i in 1:n]
end


# RandomSquareMatrix(n , min, max) gives an nxn integer matrix with entries in the range [min, max] 
function RandomSquareMatrix( n::Int64, rangemin :: Int64, rangemax :: Int64 )
    A = IntZeroMat(n,n)

    for i in 1:n 
        for j in 1:n 
            A[i,j] = rand(rangemin : rangemax)
         end
    end
    return A
end

# Gives determinant of integer matrix by converting it to a rational matrix, using the det function, 
# and converting the answer back to an integer (just using det can give floating points!)

#function IntDet( A :: Array{2,Integer})  CSABA: I get an error with the specification of Integer, dunno why
function IntDet( A :: Array)
    return Int(det(A//1))
end

# Given a tuple of things [X_1 , ... , X_n] and a function f taking X_i as an input, returns 
# [ [X_1 , f(X_1)] , .... , [X_n , f(X_n)] ].  "QApairs" is Question-Answer pairs
function QApairs( ListOfAnswers::Tuple , func )
    return [ [x,func(x)] for x in ListOfAnswers ]
end

#=

function moodle_latex_form( arg::Any )
    if typeof( arg ) == String 
        return arg
    else
        return "\\("*latex_form( arg )*"\\)"
    end
end
=#

function moodle_string( str )

    if !isa( str, AbstractString ) && !isa( str, Expr ) && 
        !isa( str, Symbol )
        str = "\\($(latex_form( str ))\\)"
    end 

    if isa( str, Expr ) || isa( str, Symbol )
        str = latexstring( str )
    end

    if typeof( str ) == LaTeXString
        str = str.s
    end

    dm_string = "\\["
    while typeof( findfirst( "\$\$", str )) != Nothing 
        str = replace( str, "\$\$" => dm_string, count = 1 )
        dm_string = dm_string == "\\[" ? "\\]" : "\\["
    end

    if dm_string == "\\]" 
        throw( "Something wrong with display math mode." )
    end

    m_string = "\\("
    while typeof( findfirst( "\$", str )) != Nothing
        str = replace( str, "\$" => m_string, count = 1 )
        m_string = m_string == "\\(" ? "\\)" : "\\("
    end

    if m_string == "\\)"
        throw( "Something wrong with math mode." )
    end


    return str
end

function substitute_latex_string( text::AbstractString, param::Tuple; 
        sep_left = "[[", sep_right = "]]" )::AbstractString
    
    text_is_latex_string = text isa LaTeXString 

    for k in 1:length(param)
        place = sep_left*string(k)*sep_right
        text = replace( text, place => string(param[k]))
        if text_is_latex_string 
            text = LaTeXString( text )
        end     
    end

    if text_is_latex_string 
            text = LaTeXString( text )
    end 
    return text
end 