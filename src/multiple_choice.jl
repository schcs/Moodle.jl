# this file contains the functions related to 
# multiple choice questions

@doc """
The data structure to hold a multiple choice type Moodle question
""" ->

struct multiple_choice_question
    title::String                   # the title of the question
    text::String                    # the text of the question
    answers::Vector{Tuple}          # the answers
    penalty::Float64                # required by Moodle, it's usually 0.1
    tags::Vector{String}            # list of tags
    defgrade::Int64                 # required by Moodle, usually 1
    single::Bool                    # true for radio button type question
    shuffle::Bool                   # true of questions are shuffled
    wrongmarkzero::Bool             # true of wrong mark gets zero point
end 

# the following function creates multiple_choice_question from the first 
# three attributes -- the others will take the default value

function multiple_choice_question( title, text, answers; 
                                    penalty = 0.1, 
                                    tags = [], 
                                    defgrade = 1, 
                                    single = false,
                                    shuffle = true,
                                    wrongmarkzero = false )
    
    # the following is the list of valid marks in Moodle
    validmarks = [ 100, 90, 83.33333, 80, 75, 70, 66.66667, 60, 50, 40, 33.33333, 
                    30, 25, 20, 16.66667, 14.28571, 12.5, 11.11111, 10, 5, 0, 
                    -100, -90, -83.33333, -80, -75, -70, -66.66667, -60, -50, 
                    -40, -33.33333, -30, -25, -20, -16.66667, -14.28571, -12.5, 
                    -11.11111, -10, -5 ]    

    answers = Array{Tuple{Any,Real}}(answers)

    if single && length( findall( x->x[2] == 100 || x[2] == true, answers )) != 1
        throw( "Error: Precisely one right answer in radio button type." )
    end
    
    ind_true = findall( x -> isa( x[2], Bool ) && x[2], answers )
    ind_false = findall( x -> isa( x[2], Bool ) && !x[2], answers )
    ind_pos = findall( x -> !isa( x[2], Bool ) && x[2] > 0, answers )
    ind_neg = findall( x -> !isa( x[2], Bool ) && x[2] <= 0, answers )

    if nothing in [ findfirst( x->abs(x-answers[y][2]) < 1, 
                    validmarks ) for y in vcat( ind_pos, ind_neg )] 
        throw( "Error: Invalid mark!" )
    end

    sum_pos = sum((x->x[2]).(answers[ind_pos]))
    sum_neg = sum((x->x[2]).(answers[ind_neg]))


    if ( !single && sum_pos > 100) || (sum_pos == 100 && length(ind_true) > 0) || 
                ( sum_pos < 100 && length( ind_true ) == 0 )
        throw( "Error: sum of positive marks is incorrect!" )
    end

    if sum_neg < -100 
        throw( "Error: sum of positive marks is incorrect!" )
    end

    if single 
        
        default_rightmark = 100

    elseif length( ind_true ) > 0 
        
        default_rightmark = findfirst( 
            x->abs( x - (100-sum_pos)/length( ind_true )) < 1, validmarks )
        if typeof( default_rightmark ) == Nothing
            throw( "Error: Could not determine a valid right mark." )
        end
        default_rightmark = validmarks[default_rightmark]

    else
        
        default_rightmark = 0
        
    end

    if wrongmarkzero || length( ind_false ) == 0
        default_wrongmark = 0
    else
        default_wrongmark = findfirst( 
                x->abs( x - (-100-sum_neg)/length( ind_false )) < 1, validmarks )
        if typeof( default_wrongmark ) == Nothing
            throw( "Error: Could not determine a valid wrong mark." )
        end
        default_wrongmark = validmarks[default_wrongmark] 
            
    end
    
    for i in ind_true
        answers[i] = (answers[i][1],default_rightmark)
    end

    for i in ind_false
        answers[i] = (answers[i][1], default_wrongmark)
    end

    return multiple_choice_question( title, text, answers, penalty, 
                                    tags, defgrade, single, shuffle, wrongmarkzero )
end 

# in the following function we can create multiple choice question specifying the 
# lists of right and wrong answers

function multiple_choice_question_by_lists( title, text, rightanswers, wronganswers;  
    penalty = 0.1, 
    tags = [], 
    defgrade = 1, 
    single = false,
    shuffle = true, 
    wrongmarkzero = false )

    answers = [ (x,true) for x in rightanswers ]
    append!( answers, [ (x,false) for x in wronganswers ])

    return multiple_choice_question( title, text, answers, penalty, 
        tags, defgrade, single, shuffle, wrongmarkzero )
end 

function multiple_choice_question_by_function( title, text, answers, func;  
    penalty = 0.1, 
    tags = [], 
    defgrade = 1, 
    single = false,
    shuffle = true, 
    wrongmarkzero = false )

    answers = [ (x,func( x )) for x in answers ]

    return multiple_choice_question( title, text, answers, penalty, 
        tags, defgrade, single, shuffle, wrongmarkzero )
end 


function Base.show( io::IO, q::multiple_choice_question )  
        print(io, "Multiple choice question\n\tTitle: ", q.title, 
                "\n\tText: ", q.text[1:min(length(q.text),40)]*"...", 
                "\n\t", length( q.answers ), " options" )
end


function moodle_answer( answer, value )

    text = "<answer fraction=\""*string( value )*"\" format=\"html\">\n"* 
            "<text><![CDATA[<p>"*moodle_latex_form( answer )*
            "</p>]]></text>\n</answer>\n"

    return text
end


function QuestionToXML( question::multiple_choice_question )
   
    xmltext = "<question type=\"multichoice\">\n<name format=\"html\">\n"*
            "<text><![CDATA["*question.title*"]]></text>\n"*
            "</name>\n"*
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>"*question.text*"</p>]]></text>\n"*
            "</questiontext>\n"*
            "<defaultgrade>"*string( question.defgrade )*"</defaultgrade>\n"* 
            "<generalfeedback format=\"html\"><text/></generalfeedback>\n"*
            "<penalty>"*string( question.penalty )*"</penalty>\n"*
            "<hidden>0</hidden>\n"*
            "<single>"*string( question.single )*"</single>\n"* 
            "<shuffleanswers>"*string( Int64( question.shuffle ))*
            "</shuffleanswers>\n"* 
            "<answernumbering>abc</answernumbering>\n"
    
    for ans in question.answers 
        xmltext *= moodle_answer( ans... )
    end

    if length( question.tags ) > 0  
        xmltext *= "<tags>\n"
        for tag in question.tags 
            xmltext *= "<tag>\n<text>"*tag*"</text>\n</tag>\n"
        end
        xmltext *= "</tags>\n"
    end

    xmltext *= "</question>\n"
    return xmltext
end 