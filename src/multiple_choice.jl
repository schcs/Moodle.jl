# this file contains the functions related to 
# multiple choice questions

@doc """
The data structure to hold a multiple choice type Moodle question

$(TYPEDEF)
$(TYPEDFIELDS)

There are several ways to create multiple choice questions. The following line creates a multiple choice question that asks the students to mark the even numbers among 0, -1, and 2.

```@repl
q = multiple_choice_question( "Even numbers", "Which of the following numbers are even?", [(0,true),(-1,false),(2,true)])
```
The same question can be created by specifying separately the list of right answers and the list of wrong answers as follows. 

```@repl
q = multiple_choice_question( "Even numbers", "Which of the following numbers are even?", [0,2], [-1] )
```

Alternatively, one might define this question by specifying the list of options and defining a boolean function that can be applied to these options and decides whether a certain option is right or wrong.

```@repl
q = multiple_choice_question( "Even numbers", "Which of the following numbers are even?", [0,2,-2], x -> x%2 == 0 )
```

Multiple choice questions can also be defined by using parameters. Consider, for example, the following line.

```@repl
q = multiple_choice_question( "Remainder", "Mark the integers that give remainder \$[[1]]\$ modulo \$[[2]]\$.", (2,4,(0,2,4,6,8,10)), (x,y,z) -> z % y == x )
```

This line creates a question asking which of the numbers 0, 2, 4, 6, 8, 10 give remainder 2 modulo 4. The first two arguments are the name of the question and the question text, respectively. The third argument is a tuple whose first two entries are substituted in the placeholders [[1]] and [[2]], while the third argument is itself a tuple containing the options that appear among the possible answers. The last argument is a boolean function with three arguments. This function is applied to the first two entries of the tuple and to each entry of the third entry to calculate which of the answers are correct.

This parametric form can be used to create a large number of questions that correspond to a list of parameters. Take, for instance, the following example.


```@repl
params = [ (a,b,(b,b+1,b+2,b+3,b+4)) for b in 10:20 for a in 1:4 ]
q = [ multiple_choice_question( "Divisible numbers", "Mark the integers that give remainder \$[[1]]\$ modulo \$[[2]]\$.", par, (x,y,z) -> z % y == x ) for par in params ]
```
In each of these versions, the function multiple_choice_question has the following optional arguments:
- penalty: see the Moodle system for documentation;
- tags: array of strings specifying the tags that appear on Moodle after import;
- defgrade: see the Moodle system for documentation;
- single: true or false; if true then there is only one correct answer and the options appear on Moodle with radio buttons;
- shuffle: true or false; controls if the answers should or should not be shuffled;
- wrongmarkzero: true or false; controls if marking an incorrect answer should result in the reduction of the mark recieved by the student. The default is true and the marks for the answers are calculated in such a way that the students receive zero marks if they click all the options, and also when they leave all the options unclicked. 

The parametric version also accepts the optional argument `sep_left` and/or `sep_right` that are strings marking the beginning and the end of the placeholders. The default values are "[[" and "]]", but these can be changed if the user needs these characters for other purposes.

""" ->

struct multiple_choice_question
    title::AbstractString                   # the title of the question
    text::AbstractString                    # the text of the question
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

@doc """
Version 1:

$(SIGNATURES)
""" ->

function multiple_choice_question( title, text, answers; 
                                    penalty = 0.1, 
                                    tags = [], 
                                    defgrade = 1, 
                                    single = false,
                                    shuffle = true,
                                    wrongmarkzero = false )
    
    # the following is the list of valid marks in Moodle
    validmarks = [ 100, 90, 83.33333, 80, 75, 70, 66.66667, 60, 50, 
            40, 33.33333, 30, 25, 20, 16.66667, 14.28571, 12.5, 
            11.11111, 10, 5, 0, -100, -90, -83.33333, -80, -75, 
            -70, -66.66667, -60, -50, -40, -33.33333, -30, -25, 
            -20, -16.66667, -14.28571, -12.5, -11.11111, -10, -5 ]    

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

    return multiple_choice_question( title, 
                            text, 
                            answers, penalty, tags, defgrade, 
                            single, shuffle, wrongmarkzero )
end 

# in the following function we can create multiple choice question specifying the 
# lists of right and wrong answers

@doc """
Version 2:

$(SIGNATURES)
""" ->

function multiple_choice_question( title::AbstractString, text::AbstractString, 
        rightanswers::Vector, wronganswers::Vector;  
    penalty = 0.1, 
    tags = [], 
    defgrade = 1, 
    single = false,
    shuffle = true, 
    wrongmarkzero = false )::multiple_choice_question

    answers = [ (x,true) for x in rightanswers ]
    append!( answers, [ (x,false) for x in wronganswers ])

    return multiple_choice_question( title, text, answers, 
        penalty = penalty, tags = tags, defgrade = defgrade, 
        single = single, shuffle = shuffle, 
        wrongmarkzero = wrongmarkzero )
end 

@doc """
Version 3:

$(SIGNATURES)
""" ->

function multiple_choice_question( title::AbstractString, text::AbstractString, 
    answers::Vector, func::Function;  
    penalty = 0.1, 
    tags = [], 
    defgrade = 1, 
    single = false,
    shuffle = true, 
    wrongmarkzero = false )::multiple_choice_question

    answers = [ (x,func( x )) for x in answers ]

    return multiple_choice_question( title, text, answers, penalty, 
        tags, defgrade, single, shuffle, wrongmarkzero )
end 

@doc """
Version 4:

$(SIGNATURES)
""" ->

function multiple_choice_question( title::AbstractString, text::AbstractString, param::Tuple, 
    func; sep_left = "[[", sep_right = "]]", tags = [], single = false )::multiple_choice_question

    text = substitute_latex_string( text, param, sep_left = sep_left, sep_right = sep_right ) 
    answers::Vector{Any} = [( param[end][k], 
            func( Tuple( vcat( [ x for x in param[1:end-1]], param[end][k]))...)) 
            for k in 1:length(param[end])]


    return multiple_choice_question( title, text, answers, tags = tags, single = false ) 
end 



function Base.show( io::IO, q::multiple_choice_question )  
        print(io, "Multiple choice question\n\tTitle: ", q.title, 
                "\n\tText: ", q.text[1:min(length(q.text),40)]*"...", 
                "\n\t", length( q.answers ), " options" )
end


function moodle_answer( answer, value )

    text = "<answer fraction=\""*string( value )*"\" format=\"html\">\n"* 
            "<text><![CDATA[<p>"*moodle_string( answer )*
            "</p>]]></text>\n</answer>\n"

    return text
end

@doc """
Writes a Moodle question into a LaTeX string.

$(SIGNATURES)
""" ->

function write_latex( q::multiple_choice_question ) 
    latex_answers = prod( string( k[1] )*"\\ \\rightarrow\\ "*string( k[2] )*";\\ \\ " 
            for k in q.answers )  
    L"{\bf Title:} %$(q.title)\\\smallskip\\{\bf Type:} Multiple Choice\\\smallskip\\{\bf Text:} %$(q.text)\\\smallskip\\{\bf Answers: }%$(latex_answers)"
end 

@doc """
Shows a question or a list of questions as a pdf document. Requires external LaTeX engines for proper functioning.

$(SIGNATURES)
""" ->

show_pdf( q::multiple_choice_question ) = render( write_latex( q ), MIME( "application/pdf" ))

@doc """ 
    Writes a Moodle question into an XML string.

$(SIGNATURES)
""" ->

function question_to_xml( question::multiple_choice_question )
   
    xmltext = "<question type=\"multichoice\">\n<name format=\"html\">\n"*
            "<text><![CDATA["*moodle_string( question.title )*"]]></text>\n"*
            "</name>\n"*
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>"*moodle_string( question.text )*"</p>]]></text>\n"*
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