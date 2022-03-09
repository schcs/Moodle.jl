# write string in moodle compatible format

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

# substitute [[k]] with k-th entry of param in string

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