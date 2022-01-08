# this file contains the functions related to questions
# of type matching

@doc """
The data structure to hold a matching type Moodle question
""" ->

struct matching_question
    title::String                   # the title of the question
    text::String                    # the text of the question
    subquestions::Vector{Tuple}    # things to be matched
    defgrade::Int64                 # required by Moodle, usually 1
    penalty::Float64                # we're not sure about this.  required by Moodle, it's usually 0.1
    shuffle::Bool                  # Csaba says "1 if we want answers permuted" -- I guess it's 0 if not?
    tags::Vector{String}            # list of tags
end 



# the idea is that the question will take 4 inputs title, text, subquestions, shuffle.  
# penalty will be 0.1, defgrade will be 1, and tags will be empty.  I'm testing to see if I can avoid taking the first 4 entries above.

function matching_question( title, text, subquestions; defgrade = 1, penalty = 0.1, shuffle = true, tags = [] )
    
    if intersect( [ x[2] for x in subquestions if x[1] != "" ],
                [ x[2] for x in subquestions if x[1] == "" ]) != [] 
        throw( "Dummy option appears among answers in matching question" )
    end 

    return matching_question( title, text, 
                subquestions, defgrade, penalty, shuffle, tags )
end 

function MatchingQuestion( title::AbstractString, text::AbstractString, param::Tuple, 
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

function write_latex( q::matching_question ) 
    latex_answers = prod( (k[1] == "" ? "Nothing" : string( k[1] ))*"\\ \$\\rightarrow\$ "*string( k[2] )*";\\ \\ " for k in q.subquestions )  
    L"{\bf Title:} %$(q.title)\\\smallskip\\{\bf Type:} Matching\\\smallskip\\{\bf Text:} %$(q.text)\\\smallskip\\{\bf Answers: }%$(latex_answers)"
end 


show_pdf( q::matching_question ) = render( write_latex( q ), MIME( "application/pdf" ))

function MoodleSubQuestion( QApair::Tuple )
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
converts matching type question to XML string
""" ->

function QuestionToXML( question::matching_question )


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
        xmlstring *= MoodleSubQuestion( ans )
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



