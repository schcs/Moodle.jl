# this file contains the functions related to questions
# of type matching

@doc """
The data structure to hold a matching question.

$(TYPEDEF)
$(TYPEDFIELDS)

The standard way to create a matching question is the following. 

```@repl
q = matching_question( "Absolute value", "Combine each number with its absolute value.", [(2,2),(-2,2),(0,0),(-1.5,1.5), ("",3),("",-3)] )
```

As with the other types of questions, one can create a matching question with parameters. Consider the following example.

```@repl 
q = matching_question( "Additive inverse", "Match each number with its additive inverse modulo [[1]].", (10,(3,4,5),(1,2,3)), (x,y) -> (-y) % x + x )
```

This line creates a question that is asking for matching the numbers 3, 4, 5 with their additive inverse modulo 10. The inverses are calculated by the function given as the fourth argument. The tuple (1,2,3) contains the list of answers that do not correspond to any of the listed options in the matching question. This last entry can be omitted and in this case each answer corresponds to an option in the first list. A check is performed to make sure that the dummy options do not in fact appear among the right answers. 

This second form of the function is useful for creating lists of questions as was explaned in the documentation of `short_answer_question` and `multiple_choice_question`.

Both methods accept the optional arguments penalty, defgrade, shuffle and tags. For the meaning of penalty and defgrade, consult the documentation of Moodle. The argument tags is a list of strings that will appear as tags for the question once imported from Moodle. The argument shuffle is true or false and indicates whether the options need to appear in a random shuffle.

The second version also accepts the optional argument `sep_left` and/or `sep_right` that are strings marking the beginning and the end of the placeholders. The default values are "[[" and "]]", but these can be changed if the user needs these characters for other purposes. 

""" ->


struct matching_question
    title::AbstractString                   # the title of the question
    text::AbstractString                    # the text of the question
    subquestions::Vector{Tuple}    # things to be matched
    defgrade::Int64                 # required by Moodle, usually 1
    penalty::Float64                # we're not sure about this.  required by Moodle, it's usually 0.1
    shuffle::Bool                  # Csaba says "1 if we want answers permuted" -- I guess it's 0 if not?
    tags::Vector{String}            # list of tags
end 



# the idea is that the question will take 4 inputs title, text, subquestions, shuffle.  
# penalty will be 0.1, defgrade will be 1, and tags will be empty.  I'm testing to see if I can avoid taking the first 4 entries above.

@doc """
Version 1

$(SIGNATURES)
""" ->

function matching_question( title::AbstractString, text::AbstractString, 
                            subquestions::Vector; 
                    defgrade = 1, penalty = 0.1, shuffle = true, tags = [] )::matching_question
    
    if intersect( [ x[2] for x in subquestions if x[1] != "" ],
                [ x[2] for x in subquestions if x[1] == "" ]) != [] 
        throw( "Dummy option appears among answers in matching question" )
    end 

    return matching_question( title, text, 
                subquestions, defgrade, penalty, shuffle, tags )
end 

@doc """
Version 2

$(SIGNATURES)
""" ->

function matching_question( title::AbstractString, text::AbstractString, param::Tuple, 
            func; sep_left = "[[", sep_right = "]]", tags = [] )::matching_question

    text = substitute_latex_string( text, param, sep_left = sep_left, sep_right = sep_right )
    has_dummy_options = param[end-1] isa Tuple
    lp = has_dummy_options ? length( param ) - 1 : length( param )
    
    answers::Vector{Any} = [( param[lp][k], func( Tuple( vcat( [ x for x in param[1:lp-1]], param[lp][k]))...)) 
    for k in 1:length(param[lp])]

    if has_dummy_options && length( intersect( [ x[2] for x in answers ], param[end] )) != 0
        throw( "Dummy option appears among answers in matching question" )
    end 

    
    if has_dummy_options 
        append!( answers, [ ("", k ) for k in param[lp+1]])
    end 

    return matching_question( title, text, answers, tags = tags ) 
end 

@doc """
Writes a Moodle question into a LaTeX string.

$(SIGNATURES)
""" ->

function write_latex( q::matching_question ) 
    latex_answers = prod( (k[1] == "" ? "Nothing" : string( k[1] ))*"\\ \$\\rightarrow\$ "*string( k[2] )*";\\ \\ " for k in q.subquestions )  
    L"{\bf Title:} %$(q.title)\\\smallskip\\{\bf Type:} Matching\\\smallskip\\{\bf Text:} %$(q.text)\\\smallskip\\{\bf Answers: }%$(latex_answers)"
end 

@doc """
Shows a question or a list of questions as a pdf document. Requires external LaTeX engines for proper functioning.

$(SIGNATURES)
""" ->

show_pdf( q::matching_question ) = render( write_latex( q ), MIME( "application/pdf" ))

function moodle_subquestion( QApair::Tuple )
    question = QApair[1] 
    answer = QApair[2]

    if question != "" 

        text = "<subquestion format=\"html\">\n"* 
                "<text><![CDATA[<p>"*
                moodle_string(question) *
                "</p>]]></text>\n"*
                "<answer><text>"*  string(answer) * "</text></answer>\n"* 
                "</subquestion>\n"
    else 

        text = "<subquestion format=\"html\">\n"* 
                "<text></text>\n"*
                "<answer><text>"*  string(answer) * "</text></answer>\n"* 
                "</subquestion>\n"
    end

    return text

end

@doc """ 
    Writes a Moodle question into an XML string.

$(SIGNATURES)
""" ->

function question_to_xml( question::matching_question )


    xmlstring = "<question type=\"matching\">\n<name format=\"html\">\n"*
            "<text><![CDATA["*moodle_string( question.title )* "]]></text>\n"*
            "</name>\n"* 
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>"*moodle_string( question.text )* "</p>]]></text>\n"*
            "</questiontext>\n"*
            "<defaultgrade>"* string( question.defgrade )* "</defaultgrade>\n"* 
            "<generalfeedback format=\"html\"><text/></generalfeedback>\n"*
            "<penalty>"* string(question.penalty)* "</penalty>\n"*
            "<hidden>0</hidden>\n"*
            "<shuffleanswers>"* string( question.shuffle )* "</shuffleanswers>\n" 
   


    for ans in question.subquestions
        xmlstring *= moodle_subquestion( ans )
    end


    # if question has at least one tag, then they are added
    if length( question.tags ) > 0  
        xmlstring *= "<tags>\n"
        for tag in question.tags 
            xmlstring *= "<tag>\n<text>"*tag*"</text>\n</tag>\n"
        end 
        xmlstring *= "</tags>\n"
    end

    # end of question
    xmlstring *= "</question>\n" 
    return xmlstring
end



